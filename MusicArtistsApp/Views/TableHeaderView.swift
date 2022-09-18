//
//  TableHeaderView.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 30.05.22.
//

import Foundation
import UIKit

final class TableHeaderView: UICollectionReusableView {
    
    let nothingToShowLabel: UILabel = {
          let nothingToShowLabel = UILabel(frame: CGRect(x: 35,
                                                         y: 100,
                                                         width: 300,
                                                         height: 40))
            nothingToShowLabel.text = "Nothing to show..."
            nothingToShowLabel.textAlignment = .center
            nothingToShowLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
            return nothingToShowLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(nothingToShowLabel)
    }
}
