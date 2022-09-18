//
//  Model.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 30.06.22.
//

import Foundation

protocol Model: Codable {

    var name: String { get }
    var genre: String { get }
    var image: String { get }
}

enum ModelError: LocalizedError {
    
    case canNotProccessData(typeModel: TypeModel)
    case noDataAvailable
    
    var errorDescription: String? {
            switch self {
            case .canNotProccessData(let typeModel):
                if typeModel == .artist {
                    return "Oops! Something went wrong. We couldn’t load the rest of the artists."
                }
                return "Oops! Something went wrong. We couldn’t load the rest of the songs."
            case .noDataAvailable:
                return "Oops! No information is available."
            }
        }
}
