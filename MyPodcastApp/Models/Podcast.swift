//
//  Podcast.swift
//  PodcastsCourseLBTA
//
//  Created by Pradeep Gianchandani on 07/10/20.
//  Copyright © 2020 Brian Voong. All rights reserved.
//

import Foundation

struct Podcast :Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}
