//
//  FavoritePodcastCell.swift
//  PodcastsCourseLBTA
//
//  Created by Brian Voong on 3/13/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            let url = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: url)
        }
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    
    fileprivate func stylizeUI() {
        nameLabel.text = "Podcast Name"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.text = "Artist Name"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = .lightGray
    }
    
    fileprivate func setupViews() {
        
        //Here we anchor the height of image view to width of image view
        //This will ensure that aspect ratio is set to 1
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        //Add imageview, name label and artist name label in vertical stack view
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])

        stackView.axis = .vertical
        
        // set this property to false to enable auto layout programatically
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        //To make the image apepar in a square shape,
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylizeUI()
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
