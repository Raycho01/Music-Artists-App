//
//  DetailsViewThirdCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 20.06.22.
//

import UIKit

final class DetailsViewThirdCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func setup(description: String) {
        label.text = description
    }
    
    func switchNumberOfLines() {
        if label.numberOfLines == 2 {
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return
        }
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
    }
}
