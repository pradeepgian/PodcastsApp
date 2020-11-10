//
//  UserDefaults.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 27/10/20.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    
    func deleteEpisode(episode: Episode) {
        let savedEpisodes = downloadedEpisodes()
        let filteredEpisodes = savedEpisodes.filter { (e) -> Bool in
            // you should use episode.collectionId to be safer with deletes
            return e.title != episode.title
        }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func downloadEpisode(episode: Episode) {
        //Here we will create an array of episode model object
        //Then we will encode that array to json and save it to User Defaults
        do {
            var episodes = downloadedEpisodes()
//            episodes.append(episode)
            //insert episode at the front of the list
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        //Here we fetch the encoded episodes array data from user defaults
        //Then we decode the episodes data to array of episodes model object
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("Failed to decode:", decodeErr)
        }
        
        return []
    }
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
//        do {
//            guard let savedPodcasts = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: savedPodcastsData) as? [Podcast] else { return [] }
//            return savedPodcasts
//        } catch {
//            print(error)
//            return []
//        }
        
        do {
            guard let savedPodcasts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData as Data) as? [Podcast] else { return [] }
            return savedPodcasts
        }
//        guard let savedPodcasts = NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: savedPodcastsData) as? [Podcast] else { return [] }
//        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
        
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
    
}
