//
//  ViewAllViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 12.05.22.
//

import UIKit
import SkeletonView

final class ViewAllViewController: UIViewController {
    
    enum TypeFetch {
        case initial
        case next
        case refresh
    }

    private var debounceTimer: Timer?
    private var showArtistsError: Bool = false
    private var lastSearched: String? = nil
    private var isFetchingInProgress = false
    private var isSearchingInProgress: Bool {
        if lastSearched != nil {
            return true
        }
        return false
    }
    private var allowsSelection = true
    
    private var consumerManager: ConsumingPagination?
    
    func setupManager(manager: ConsumingPagination, typeModel: TypeModel) {
        consumerManager = manager
        if typeModel == .song {
            allowsSelection = false
            navigationItem.title = "Songs"
            return
        }
        allowsSelection = true
        navigationItem.title = "Artists"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var searchImageView: UIImageView!
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        tableView.prefetchDataSource = self
        tableView.allowsSelection = allowsSelection
        
        searchView.layer.cornerRadius = 7
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails",
           let indexPath = self.tableView.indexPathForSelectedRow,
           let artist = consumerManager?.models[indexPath.row] as? Artist {
            
            let controller = segue.destination as! DetailsWrapperTableViewController
            controller.selectedArtist = artist
        }
    }
    
    private func getArtistsDebounce() {
        debounceTimer?.invalidate()

        changeSearchState(isSearching: true)

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in

            self.getArtists(type: .initial)

        })
    }
    
    private func getArtists(type: TypeFetch) {
        
        let consumerCompletion: ConsumerCompletion = { [weak self] result in
            DispatchQueue.main.async {
                defer {
                    self?.isFetchingInProgress = false
                }
                
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let artists):
                    
                    self.changeHeaderState(isHidden: !(artists.isEmpty))

                case .failure(let error):

                    self.showArtistsError = true
                    print(error)
                }
                
                self.changeSearchState(isSearching: false)
                self.tableView.reloadData()
            }
        }
        
        switch type {
        case .initial:
            consumerManager?.invalidate()
            consumerManager?.getNextPage(searchCriteria: lastSearched, completion: consumerCompletion)
        case .next:
            consumerManager?.getNextPage(searchCriteria: nil, completion: consumerCompletion)
        case .refresh:
            consumerManager?.getNextPage(searchCriteria: nil, completion: consumerCompletion)
        }

        isFetchingInProgress = true
        tableView.reloadData()
    }

}

extension ViewAllViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllTableViewCell", for: indexPath) as? ViewAllTableViewCell,
              let manager = consumerManager else {
            return tableView.dequeueReusableCell(withIdentifier: "ViewAllTableViewCell", for: indexPath)
        }
        
        cell.setup(model: manager.models[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return consumerManager?.models.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ViewAllTableViewCell"
    }
}

extension ViewAllViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if showArtistsError {
            guard let view = Bundle.main.loadNibNamed("CouldntLoadErrorView", owner: nil, options: nil)?[0] as? CouldntLoadErrorView else {
                fatalError("xib CouldntLoadErrorView error")
            }
            view.delegate = self
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        
        if showArtistsError {
            return UITableView.automaticDimension
        }
        return 0
    }
    
}

extension ViewAllViewController: UITextFieldDelegate {
    
    func changeSearchState(isSearching: Bool) {
        if isSearching {
            activityIndicatorView.isHidden = false
            searchImageView.isHidden = true
        } else {
            activityIndicatorView.isHidden = true
            searchImageView.isHidden = false
        }
    }
    
    func changeHeaderState(isHidden: Bool) {
        if isHidden {
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = TableHeaderView(frame: self.tableView.frame)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textAfterUpdate = textField.text as NSString?
        guard let newString = textAfterUpdate?.replacingCharacters(in: range, with: string), newString.count > 0 else {
            lastSearched = nil
            getArtists(type: .initial)
            return true
        }
        lastSearched = newString
        getArtistsDebounce()
        
        return true
    }

}

extension ViewAllViewController: CouldntLoadErrorViewDelegate {
    func didTapRetry(typeModel: TypeModel) {
        showArtistsError = false
        getArtists(type: .refresh)
    }
}

extension ViewAllViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard let manager = consumerManager else {
            return
        }
        
        if !isFetchingInProgress && !manager.pagingEnded {
            for indexPath in indexPaths {
                if indexPath.row == manager.models.count - 2 || indexPath.row == manager.models.count - 1 {
                    getArtists(type: .next)
                    return
                }
            }
        }
    }
    
}
