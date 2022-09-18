
//
//  Artist.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 12.05.22.
//

import UIKit

struct Root: Codable {
    let artists: [Artist]
}

struct Artist: Model {
    
    var id: String
    var name: String
    private var formedYear: String
    var getFormedYear: Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: formedYear)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)

        guard let year = components.year else {
            return 0
        }
        return year
        
    }
    var genre: String
    var country: String
    var image: String
    var fanart1: String
    var fanart2: String
    var fanart3: String
    var fanart4: String
    var getAllFanarts: [String] {
        return [fanart1, fanart2, fanart3, fanart4]
    }
    var website: String
    var mood: String
    private var gender: Bool
    var getGender: String {
        if gender {
            return "Male"
        } else {
            return "Female"
        }
    }
    var description: String
    var albumCount: Int
    
    private enum CodingKeys : String, CodingKey {
        case id,
             name,
             formedYear = "formed_year",
             genre,
             country,
             image,
             fanart1 = "fanart_1",
             fanart2 = "fanart_2",
             fanart3 = "fanart_3",
             fanart4 = "fanart_4",
             website,
             mood,
             gender,
             description,
             albumCount = "album_count"
    }
    
}
