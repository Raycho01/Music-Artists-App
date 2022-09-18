//
//  DetailsWrapperTableViewController.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 14.06.22.
//

import Foundation
import UIKit

class DetailsWrapperTableViewController: UIViewController {
    var selectedArtist: Artist?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededDetails" {
                let controller = segue.destination as! DetailsTableViewController
                controller.selectedArtist = selectedArtist
        }
    }
}
