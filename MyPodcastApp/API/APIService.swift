//
//  APIService.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 09/10/20.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name {
    
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    //singleton
    static let shared = APIService()
    
    //Benefit of using singleton is - here we can have one base url for all API requests
    let baseiTunesSearchURL = "https://itunes.apple.com/search"

    func downloadEpisode(episode: Episode) {
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)
        
        //Fetch suggested file download location using Alamofire built-in method
        let fileDownloadLocation = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streamUrl, to: fileDownloadLocation).downloadProgress { (progress) in
            // Notify DownloadsController about download progress
            // Post a notification and pass download progress data in dictionary using userinfo parameter
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            }.response { (resp) in
                print(resp.fileURL?.absoluteString ?? "")
                //Post notification once download is complete
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: resp.fileURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                //Fetch the episode object from downloaded episodes array in UserDefaults
                //Update the fileUrl property of fetched episode - with the location where downloaded episode is present
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
                downloadedEpisodes[index].fileUrl = resp.fileURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("Failed to encode downloaded episodes with file url update:", err)
                }
                
                
        }
    }
    
    func fetchPodcasts(searchText:String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseiTunesSearchURL, parameters: parameters)
            .validate()
            .responseDecodable(of: SearchResults.self) { (dataResponse) in
                
                if let err = dataResponse.error {
                    print("Failed to connect to server", err)
                    return
                }
                guard let data = dataResponse.value else { return }
                completionHandler(data.results)
            }
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
//        let secureFeedUrl = feedUrl.toSecureHTTPS()
        
        guard let url = URL(string: feedUrl) else { return }
        
        //In older Feedkit API, in init method, this parser used to fetch the xml synchronously on UI thread
        //That means it used to block UI thread for brief moment
        //Hence we had to move the entire code in asynchronous request
        print("Before Parser")
        let parser = FeedParser(URL: url)
        print("After Parser")
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .background)) { (result) in
            
            switch result {
            case .success(let feed):
                print("Successfully parse feed:", result)
                // Grab the parsed feed directly as an optional rss, atom or json feed object
                guard let rssFeed = feed.rssFeed else { return }
                let episodes = rssFeed.toEpisodes()
                completionHandler(episodes)
                
            case .failure(let error):
                print("Failed to parse XML feed:", error)
                return
            }
        }
        
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
