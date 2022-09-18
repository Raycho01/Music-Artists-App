//
//  ClientAPI.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 27.05.22.
//

import Foundation

protocol ConsumerService {
    
    associatedtype TModel
    static func getModels(searchCriteria: String?, cursor: Cursor, completion: @escaping (Result<[TModel], ModelError>) -> Void)
}

final class ArtistsService: ConsumerService {
    
    typealias TModel = Artist
    
    static func getModels(searchCriteria: String?, cursor: Cursor, completion: @escaping (Result<[Artist], ModelError>) -> Void) {
        
        getModels(url: "https://62a6f30e97b6156bff83508f.mockapi.io/api/v1/artists", searchCriteria: searchCriteria, cursor: cursor) { data, response, error in
            
            do {
                if let data = data {
                    let root = try JSONDecoder().decode([Artist].self, from: data)
                    completion(.success(root))
                }
            } catch {
                completion(.failure(.canNotProccessData(typeModel: .artist)))
            }
        }
    }
    
}

final class SongService: ConsumerService {
    
    typealias TModel = Song
    
    static func getModels(searchCriteria: String?, cursor: Cursor, completion: @escaping (Result<[Song], ModelError>) -> Void) {
        
        getModels(url: "https://62a6f30e97b6156bff83508f.mockapi.io/api/v1/songs", searchCriteria: searchCriteria, cursor: cursor) { data, response, error in
            
            do {
                if let data = data {
                    let root = try JSONDecoder().decode([Song].self, from: data)
                    completion(.success(root))
                }
            } catch {
                print(error)
                completion(.failure(.canNotProccessData(typeModel: .song)))
            }
        }
    }
    
}

extension ConsumerService {
    
    static func getModels(url: String, searchCriteria: String?, cursor: Cursor, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var components = URLComponents(string: url)
        
        components?.queryItems = cursor.toURLQuery
        
        if searchCriteria != nil {
            components?.queryItems?.append(URLQueryItem(name: "search", value: searchCriteria))
        }
        
        guard let url = components?.url else {
            fatalError("Consuming API error!")
        }
            
        let session = URLSession.shared
        let request = URLRequest(url: url)

        session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            completion(data, response, error)
        }).resume()
    }
}
