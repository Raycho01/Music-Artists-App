//
//  HomeCollectionViewCell.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 13.07.22.
//

import Foundation
import UIKit

protocol HomeCollectionViewCellDelegate: AnyObject {
    func didReceiveError(error: ModelError, typeModel: TypeModel)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint?
    
    private weak var delegate: HomeCollectionViewCellDelegate?
    private var consumerManager: ConsumingPagination?
    private var typeModel: TypeModel?
    private var showNoResults: Bool = false
    weak var parent: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCollectionViewLayout()
        collectionView.delegate = self
        
        collectionView.register(TableHeaderView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "TableHeaderView")
    }
    
    func setup(manager: ConsumingPagination, typeModel: TypeModel, delegate: HomeCollectionViewCellDelegate) {
        self.typeModel = typeModel
        self.delegate = delegate
        self.consumerManager = manager
        
        defer {
            self.collectionView.reloadData()
        }
        
        /// If there are only skeletons in the models we are still loading, so make another request
        guard consumerManager?.models.contains(where: { type(of: $0) != Skeleton.self }) == false else {
            return
        }
        
        let consumerCompletion: ConsumerCompletion = { [weak self] result in
            DispatchQueue.main.async {

                guard let self = self else { return }

                switch result {

                case .success(let artists):
                    
                    if artists.isEmpty {
                        self.showNoResults = true
                    } else {
                        self.showNoResults = false
                    }
                    
                    self.collectionView.reloadData()

                case .failure(let error):
                    self.delegate?.didReceiveError(error: error, typeModel: typeModel)
                }
            }
        }

        consumerManager?.invalidate()
        consumerManager?.getNextPage(searchCriteria: nil, completion: consumerCompletion)
    }
    
    func setUpCollectionViewLayout() {

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        flowLayout.itemSize = CGSize(width: 168 + 6, height: 242 + 6)
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func pushToDetailsView(artist: Artist) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTableViewController") as? DetailsTableViewController else {
            return
        }

        destinationViewController.selectedArtist = artist
        parent?.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    
}

extension HomeCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        consumerManager?.models.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeIternalCollectionViewCell", for: indexPath) as? HomeIternalCollectionViewCell,
                let consumerManager = consumerManager,
                let typeModel = typeModel else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeIternalCollectionViewCell", for: indexPath)
        }
        
        cell.setup(model: consumerManager.models[indexPath.row], typeModel: typeModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let artist = consumerManager?.models[indexPath.row] as? Artist {
            pushToDetailsView(artist: artist)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TableHeaderView", for: indexPath) as? TableHeaderView else {
            return TableHeaderView()
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if showNoResults {
            return CGSize(width: 300, height: 40)
        }
        return .zero
    }
    
}
