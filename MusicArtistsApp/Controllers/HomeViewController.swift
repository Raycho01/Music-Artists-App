//
//  HomePageViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 3.07.22.
//

import UIKit
import ViewAnimator

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var artistConsumerManager: ConsumingPagination = ConsumerPaginationManager<Artist, ArtistsService>()
    private var songConsumerManager: ConsumingPagination = ConsumerPaginationManager<Song, SongService>()
    
    private var artistError: ModelError?
    private var songError: ModelError?
    
    override func viewDidLoad() {
        
        navigationItem.backBarButtonItem?.title = "Back"
        
        artistConsumerManager.reset()
        songConsumerManager.reset()
        
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CouldntLoadErrorView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "CouldntLoadErrorView")

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionHeadersPinToVisibleBounds = false
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case TypeModel.artist.rawValue:
            guard artistError == nil && artistConsumerManager.models.count > 0 else {
                return 0
            }
            return 1
        case TypeModel.song.rawValue:
            guard songError == nil && songConsumerManager.models.count > 0 else {
                return 0
            }
            return 1
        default:
            preconditionFailure("Section \(section) doesn't exist.")
        }
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeWelcomeCollectionViewCell", for: indexPath) as? HomeWelcomeCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeWelcomeCollectionViewCell", for: indexPath)
            }
            cell.welcomeViewWidthConstraint.constant = view.frame.width - 16
            cell.delegate = self
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)
        }
        
        cell.collectionViewWidthConstraint?.constant = view.frame.width
        cell.parent = self
        

        switch indexPath.section {
            
        case TypeModel.artist.rawValue:
            cell.setup(manager: artistConsumerManager, typeModel: .artist, delegate: self)
        case TypeModel.song.rawValue:
            cell.setup(manager: songConsumerManager, typeModel: .song, delegate: self)
        default:
            preconditionFailure("Section \(indexPath.section) doesn't exist.")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionViewSectionHeader", for: indexPath) as? HomeCollectionViewSectionHeader else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == TypeModel.artist.rawValue {
                sectionHeader.setup(typeModel: .artist)

            } else if indexPath.section == TypeModel.song.rawValue {
                sectionHeader.setup(typeModel: .song)
            }
            
            sectionHeader.delegate = self

            return sectionHeader
            
        case UICollectionView.elementKindSectionFooter:
            
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CouldntLoadErrorView", for: indexPath) as? CouldntLoadErrorView else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == TypeModel.artist.rawValue,
               let artistError = artistError {
                footerView.setup(typeModel: .artist, error: artistError)

            } else if indexPath.section == TypeModel.song.rawValue,
                let songError = songError {
                footerView.setup(typeModel: .song, error: songError)
            }
            
            footerView.delegate = self
            return footerView

        default:
            
            fatalError("Unexpected element kind")
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        
        
        if artistError != nil && section == TypeModel.artist.rawValue {
            return CGSize(width: view.bounds.width, height: 188)
        }
        
        if songError != nil && section == TypeModel.song.rawValue {
            return CGSize(width: view.bounds.width, height: 188)
        }

        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return .zero
        }
        
        return CGSize(width: view.bounds.width, height: 98)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HomeCollectionViewCell,
              cell.collectionView.dataSource == nil else {
            return
        }
        
        cell.collectionView.dataSource = cell
        cell.collectionView.reloadData()
    }

}

extension HomeViewController: HomeCollectionViewSectionHeaderDelegate {
    
    func pushToViewAll(typeModel: TypeModel) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewAllViewController") as? ViewAllViewController else {
            return
        }
        
        if typeModel == .artist {
            destinationViewController.setupManager(manager: artistConsumerManager as! ConsumerPaginationManager<Artist, ArtistsService>, typeModel: typeModel)
        } else if typeModel == .song {
            destinationViewController.setupManager(manager: songConsumerManager as! ConsumerPaginationManager<Song, SongService>, typeModel: typeModel)
        }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension HomeViewController: CouldntLoadErrorViewDelegate {
    func didTapRetry(typeModel: TypeModel) {
        
        switch typeModel {
        case .artist:
            artistError = nil
            artistConsumerManager.reset()
        case .song:
            songError = nil
            songConsumerManager.reset()
        }
        
        collectionView.reloadData()

    }
}

extension UIView {
    
    func setShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.14
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    static var standartAnimations: [Animation] {
        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        return [fromAnimation, zoomAnimation, rotateAnimation]
    }
}

extension HomeViewController: HomeWelcomeCollectionViewCellDelegate {
    
    func didChangeDescriptionLabel() {
        collectionView.reloadData()
    }
    
    func didTapShareButton() {
        let message = "Share your profile with your friends!"

        if let link = NSURL(string: "http://MusicArtists-MyProfile.com") {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: HomeCollectionViewCellDelegate {
    
    func didReceiveError(error: ModelError, typeModel: TypeModel) {

        switch typeModel {
        case .artist:
            artistError = error
        case .song:
            songError = error
        }
        
        collectionView.reloadItems(at: [IndexPath(item: 0, section: typeModel.rawValue)])
    }
}
