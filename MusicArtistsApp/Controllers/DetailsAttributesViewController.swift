//
//  DetailsAttributesViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 10.06.22.
//

import UIKit

enum DetailsType: String {
    
    case mood = "Mood"
    case age = "Age"
    case gender = "Gender"
    case country = "Country"
}

protocol DetailsAttribute {
    
    var type: DetailsType { get }
    var value: String { get }
}

struct DetailsNumericAttribute: DetailsAttribute {
    
    let type: DetailsType
    let numeric: Int
    let value: String

}

struct DetailsIconAttribute: DetailsAttribute {
    
    let type: DetailsType
    let icon: String
    let value: String

}

final class DetailsAttributesViewController: UIViewController {
    
    private var details: [DetailsAttribute] = []
    var selectedArtist: Artist?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        setUpDataSource()
        collectionView.reloadData()
    }
    
    private func setUpDataSource() {
        
        guard let selectedArtist = selectedArtist,
        let year = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year else {
            return
        }
        
        let age = year - selectedArtist.getFormedYear
        let ageDetails = DetailsNumericAttribute(type: .age, numeric: age, value: " years old")
        details.append(ageDetails)

        let moodDetails = DetailsIconAttribute(type: .mood, icon: "moodIcon", value: selectedArtist.mood)
        details.append(moodDetails)
        
        let genderDetails = DetailsIconAttribute(type: .gender, icon: "genderIcon", value: selectedArtist.getGender)
        details.append(genderDetails)
        
        let countryDetails = DetailsIconAttribute(type: .country, icon: "countryIcon", value: selectedArtist.country)
        details.append(countryDetails)

    }
        
}

extension DetailsAttributesViewController: UICollectionViewDataSource,
                                           UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return details.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let attributesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsAttributesCollectionViewCell", for: indexPath) as? DetailsAttributesCollectionViewCell else {
            fatalError("Error with AttributesCollectionViewCell!")
        }
        
        if let numericDetails = details[indexPath.row] as? DetailsNumericAttribute {
            attributesCell.setup(upperText: numericDetails.type.rawValue,
                                 numeric: numericDetails.numeric,
                                 downText: numericDetails.value)
        }
        
        if let iconDetails = details[indexPath.row] as? DetailsIconAttribute,
            let image = UIImage(named: iconDetails.icon) {
            attributesCell.setup(upperText: iconDetails.type.rawValue,
                                 image: image,
                                 downText: iconDetails.value)
        }
        
        return attributesCell

    }
}
