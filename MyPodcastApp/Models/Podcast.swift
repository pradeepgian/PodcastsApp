//
//  Podcast.swift
//  PodcastsCourseLBTA
//
//  Created by Pradeep Gianchandani on 07/10/20.
//

import Foundation

struct Podcast :Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}
