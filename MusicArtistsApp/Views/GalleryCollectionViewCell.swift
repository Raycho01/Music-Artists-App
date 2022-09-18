//
//  GalleryCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 18.05.22.
//

import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: GalleryCollectionViewCell.self)
    
    @IBOutlet var imageView: UIImageView!
    
    func setup(url: URL) {
        
        guard let placeholder = UIImage(named: "musicIcon") else {
            return
        }
        imageView.setImageWith(url: url, placeholderImage: placeholder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 7
    }
    
}
