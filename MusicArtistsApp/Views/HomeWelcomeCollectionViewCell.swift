//
//  HomeWelcomeCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 13.07.22.
//

import Foundation
import UIKit

protocol HomeWelcomeCollectionViewCellDelegate: AnyObject {
    func didChangeDescriptionLabel()
    func didTapShareButton()
}

class HomeWelcomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandingLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    weak var delegate: HomeWelcomeCollectionViewCellDelegate?
    
    @IBAction func readMoreButtonTapped(_ sender: Any) {

        if expandingLabel.numberOfLines == 2 {
            
            expandingLabel.lineBreakMode = .byWordWrapping
            expandingLabel.numberOfLines = 0
            readMoreButton.setTitle("READ LESS", for: .normal)
        } else {
            
            expandingLabel.lineBreakMode = .byTruncatingTail
            expandingLabel.numberOfLines = 2
            readMoreButton.setTitle("READ MORE", for: .normal)
        }
        
        delegate?.didChangeDescriptionLabel()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        delegate?.didTapShareButton()
    }
    
    override func awakeFromNib() {
        welcomeView.setShadow()
    }
    
}
