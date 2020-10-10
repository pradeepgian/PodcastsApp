//
//  RSSFeed.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 10/10/20.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        let podcastImageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = podcastImageUrl
            }
            episodes.append(episode)
        })
        return episodes
    }
}
