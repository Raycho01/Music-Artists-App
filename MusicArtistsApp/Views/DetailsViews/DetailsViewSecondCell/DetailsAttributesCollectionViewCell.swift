//
//  DetailsAttributesCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 9.06.22.
//

import UIKit

final class DetailsAttributesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var upperText: UILabel!
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var numericLabel: UILabel?
    @IBOutlet private weak var downText: UILabel!
    
    func setup(upperText: String, image: UIImage, downText: String) {
        self.upperText.text = upperText
        self.imageView?.image = image
        self.imageView?.setImageColor(color: UIColor(red: 138/255.0, green: 138/255.0, blue: 141/255.0, alpha: 1))
        self.downText.text = downText
        
        self.numericLabel?.removeFromSuperview()
    }
    
    func setup(upperText: String, numeric: Int, downText: String) {
        self.upperText.text = upperText
        self.numericLabel?.text = String(numeric)
        self.downText.text = downText
        
        self.imageView?.removeFromSuperview()
    }
}
