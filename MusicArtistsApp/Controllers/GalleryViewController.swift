//
//  GalleryViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 18.05.22.
//

import UIKit
import AnimatedCollectionViewLayout

final class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesURLs: [URL] = []
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        setUpCollectionViewLayout()
    }
    
    func setUpCollectionViewLayout() {
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()

        let width = (view.frame.size.width) - 5
        let height = (view.frame.size.height) - 40

        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell else {
            fatalError("Gallery GalleryCollectionViewCell error!")
        }

        cell.setup(url: imagesURLs[indexPath.row])
        return cell
    }
    
}
