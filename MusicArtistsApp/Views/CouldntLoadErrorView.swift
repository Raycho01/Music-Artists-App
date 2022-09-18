//
//  CouldntLoadErrorView.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 23.06.22.
//

import UIKit

protocol CouldntLoadErrorViewDelegate: AnyObject {
    func didTapRetry(typeModel: TypeModel)
}

class CouldntLoadErrorView: UICollectionReusableView {
    
    weak var delegate: CouldntLoadErrorViewDelegate?

    @IBOutlet weak var textLabel: UILabel!
    
    private var typeModel: TypeModel?
    
    @IBAction func retryButtonPushed(_ sender: Any) {
        if let typeModel = typeModel {
            delegate?.didTapRetry(typeModel: typeModel)
        }
    }
    
    func setup(typeModel: TypeModel, error: LocalizedError) {
        textLabel.text = error.localizedDescription
        self.typeModel = typeModel
    }
    
}
