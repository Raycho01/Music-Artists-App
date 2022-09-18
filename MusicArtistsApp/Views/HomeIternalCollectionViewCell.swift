//
//  HomeIternalCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 3.07.22.
//

import UIKit

final class HomeIternalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    func setup(model: Model, typeModel: TypeModel) {

        if model is Skeleton {
            
            self.showGradientSkeleton(usingGradient: .init(baseColor: .silver, secondaryColor: .clouds), animated: true, delay: .zero, transition: .crossDissolve(0.25))
            return
        }
        self.hideSkeleton()
        
        nameLabel.text = model.name
        
        if typeModel == .artist {
            if let artist = model as? Artist {
                descriptionLabel.text = "Total albums: \(artist.albumCount % 100)"
                guard let url = URL(string: model.image),
                      let placeholder = UIImage(named: "profilePic")
                else { return  }
                
                imageView.setImageWith(url: url, placeholderImage: placeholder)
            }
        }
        
        if typeModel == .song {
            if let song = model as? Song {
                descriptionLabel.text = song.artist_name
                guard let url = URL(string: model.image),
                      let placeholder = UIImage(named: "musicIcon")
                else { return  }
                
                imageView.setImageWith(url: url, placeholderImage: placeholder)
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 4

//        cellView.clipsToBounds = false
        cellView.setShadow()
    }
    
}
