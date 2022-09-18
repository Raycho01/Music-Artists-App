//
//  DetailsFirstViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 9.06.22.
//

import UIKit

final class DetailsViewFirstCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    var strLastFMChart: String!
    
    func setup(artist: Artist) {
        nameLabel.text = artist.name
        genreLabel.text = artist.genre
        strLastFMChart = artist.website
        
        guard let url = URL(string: artist.image),
              let placeholder = UIImage(named: "musicIcon")
        else { return  }
        
        thumbnailImageView.setImageWith(url: url, placeholderImage: placeholder)

    }
    
    @IBAction func iTunesButtonTapped(_ sender: Any) {
        if let url = URL(string: strLastFMChart) {
            UIApplication.shared.open(url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.cornerRadius = 24.15
    }
    
}
