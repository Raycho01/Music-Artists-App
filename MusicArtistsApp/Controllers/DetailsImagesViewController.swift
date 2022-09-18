//
//  DetailsImagesViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 10.06.22.
//

import UIKit

final class DetailsImagesViewController: UIViewController {
    
    var imagesURLs: [URL] = []
    var selectedArtist: Artist?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setUpDataSource()
        setUpCollectionViewLayout()

    }
    
    func setUpCollectionViewLayout() {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 7
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
    }
    
    func setUpDataSource() {
        
        if let selectedArtist = selectedArtist {

            let urlsAsStrings = selectedArtist.getAllFanarts
            
            for str in urlsAsStrings {
                guard let url = URL(string: str) else {
                    continue
                }
                imagesURLs.append(url)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery" {
            let destinationController = segue.destination as? GalleryViewController
            destinationController?.imagesURLs = imagesURLs
        }
    }
        
}

extension DetailsImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsImagesCollectionViewCell", for: indexPath) as? DetailsImagesCollectionViewCell else {
            fatalError("Error with ImagesCollectionViewCell!")
        }

        imageCell.setup(url: imagesURLs[indexPath.row])

        return imageCell

    }
        
}
