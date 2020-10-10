//
//  PodcastCell.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 09/10/20.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    
    var podcast: Podcast! {
        didSet {
            trackName.text = podcast.trackName
            artistName.text = podcast.artistName
            episodeCount.text = "\(podcast.trackCount ?? 0) episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            //            URLSession.shared.dataTask(with: url) { (data, _, _) in
            //                print("Finished downloading image data:", data)
            //                guard let data = data else { return }
            //                DispatchQueue.main.async {
            //                    self.podcastImageView.image = UIImage(data: data)
            //                }
            //
            //            }.resume()
            podcastImageView.sd_setImage(with: url)
        }
    }
}
