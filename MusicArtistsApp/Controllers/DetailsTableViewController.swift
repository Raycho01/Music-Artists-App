//
//  DetailsTableViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 8.06.22.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    var selectedArtist: Artist?
    @IBOutlet weak var detailsViewFirstCell: DetailsViewFirstCell!
    @IBOutlet weak var detailsViewSecondCell: UITableViewCell!
    @IBOutlet weak var detailsViewThirdCell: DetailsViewThirdCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        guard let selectedArtist = selectedArtist
        else {
            fatalError("selectedArtist error!")
        }
        
        detailsViewSecondCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        detailsViewThirdCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        detailsViewFirstCell.setup(artist: selectedArtist)
        detailsViewThirdCell.setup(description: selectedArtist.description)
        
        detailsViewFirstCell.selectionStyle = .none
        detailsViewSecondCell.selectionStyle = .none
        detailsViewThirdCell.selectionStyle = .none
        
        detailsViewFirstCell.animate(animations: UIView.standartAnimations)
        detailsViewSecondCell.animate(animations: UIView.standartAnimations)
        detailsViewThirdCell.animate(animations: UIView.standartAnimations)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "attributesSegue",
            let destinationViewController = segue.destination as? DetailsAttributesViewController {
            destinationViewController.selectedArtist = selectedArtist
        }
        
        if segue.identifier == "imagesSegue", let destinationViewController = segue.destination as? DetailsImagesViewController {
            destinationViewController.selectedArtist = selectedArtist
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            detailsViewThirdCell.switchNumberOfLines()
            tableView.reloadData()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
    

