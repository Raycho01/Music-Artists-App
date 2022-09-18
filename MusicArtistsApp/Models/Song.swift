//
//  Song.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 15.06.22.
//

import UIKit

struct Song: Model {
    
    var id: String
    var createdAt: String
    var name: String
    var artist_name: String
    var image: String
    var genre: String
    var album: String
    
    private enum CodingKeys : String, CodingKey {
        case id,
             createdAt = "created_at",
             name = "title",
             artist_name,
             image = "song_cover",
             genre,
             album
    }
}
