//
//  HomeCollectionViewSectionHeader.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 4.07.22.
//

import Foundation
import UIKit

enum TypeModel: Int {
    
    case artist = 1
    case song = 2
}

protocol HomeCollectionViewSectionHeaderDelegate: AnyObject {
    
    func pushToViewAll(typeModel: TypeModel)
}

class HomeCollectionViewSectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: HomeCollectionViewSectionHeaderDelegate?
    
    private var typeModel: TypeModel? {
        didSet {
            if typeModel == .artist {
                tittleLabel.text = "Top Artists"
                descriptionLabel.text = "Checkout our top artists this month"
            } else if typeModel == .song {
                tittleLabel.text = "Top Songs"
                descriptionLabel.text = "Checkout our top songs this month"
            }
        }
    }

    @IBAction func viewAllButtonTapped(_ sender: Any) {
        if let typeModel = typeModel {
            delegate?.pushToViewAll(typeModel: typeModel)
        }
    }
    
    func setup(typeModel: TypeModel) {
        
        self.typeModel = typeModel
    }
    
}
