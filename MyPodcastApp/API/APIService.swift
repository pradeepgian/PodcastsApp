//
//  APIService.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 09/10/20.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    //singleton
    static let shared = APIService()
    
    //Benefit of using singleton is - here we can have one base url for all API requests
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
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
