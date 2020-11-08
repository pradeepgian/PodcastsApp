//
//  UserDefaults.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 27/10/20.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    
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
