//
//  ViewAllTableViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 12.05.22.
//

import UIKit

final class ViewAllTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    func setup(model: Model) {

        if model is Skeleton {
            
            self.showGradientSkeleton(usingGradient: .init(baseColor: .silver, secondaryColor: .clouds), animated: true, delay: .zero, transition: .crossDissolve(0.25))
            return
        }
        
        self.hideSkeleton()
        nameLabel.text = model.name
        genreLabel.text = model.genre
        
        guard let url = URL(string: model.image),
              let placeholder = UIImage(named: "musicIcon")
        else { return  }
        
        thumbnailImageView.setImageWith(url: url, placeholderImage: placeholder)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 7
    }
    
}
