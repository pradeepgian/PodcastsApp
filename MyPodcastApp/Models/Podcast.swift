//
//  Podcast.swift
//  PodcastsCourseLBTA
//
//  Created by Pradeep Gianchandani on 07/10/20.
//

import Foundation

// In order to make encoding method available on podcast custom object, we have to confirm podcast model to NSCoding protocol
// Change Podcast from structure to class

class Podcast : NSObject, Decodable, NSCoding {
    func encode(with coder: NSCoder) {
        print("Trying to transform Podcast into Data")
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        coder.encode(feedUrl ?? "", forKey: "feedKey")
    }
    
    required init?(coder: NSCoder) {
        print("Trying to turn Data into Podcast")
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = coder.decodeObject(forKey: "feedKey") as? String
    }
    
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}
