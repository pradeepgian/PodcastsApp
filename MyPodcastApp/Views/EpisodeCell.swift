//
//  EpisodeCell.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 09/10/20.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            let url = URL(string: episode.imageUrl ?? "")
            print("Episode image url => \(episode.imageUrl ?? "")")
            episodeImageView.sd_setImage(with: url)
        }
    }
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    
}
