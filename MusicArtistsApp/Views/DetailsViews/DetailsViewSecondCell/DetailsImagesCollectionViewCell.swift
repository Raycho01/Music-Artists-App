//
//  DetailsImagesCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 9.06.22.
//

import UIKit

final class DetailsImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    func setup(url: URL) {
        
        guard let placeholder = UIImage(named: "musicIcon") else {
            return
        }
        imageView.setImageWith(url: url, placeholderImage: placeholder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 22.14
    }
}
