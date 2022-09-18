//
//  ConsumerManager.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 29.06.22.
//

import Foundation

typealias ConsumerCompletion = (Result<[Model], ModelError>) -> Void

struct Cursor {
    static let start = 1
    
    private var page: Int
    let limit: Int
    
    init(limit: Int) {
        self.page = 1
        self.limit = limit
    }

    var toURLQuery: [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
    }
    
    var isAtStart: Bool {
        page == 1
    }
    
    mutating func moveToNextPage() {
        page += 1
    }
    
}

protocol ConsumingPagination {
    
    var pagingEnded: Bool { get }
    
    var models: [Model] { get }
    
    func getNextPage(searchCriteria: String?, completion: @escaping ConsumerCompletion)
    
    func reset()
    
    func invalidate()
}

final class ConsumerPaginationManager<TModel: Model, TService: ConsumerService>: ConsumingPagination
    where TService.TModel == TModel {
    
    private var cursor = Cursor(limit: 10)
    private(set) var pagingEnded = false
    private(set) var models: [Model] = []
    private var currentSearchCriteria: String?
    
    func reset() {
        models.append(contentsOf: [Skeleton(), Skeleton(), Skeleton()])
    }
    
    func getNextPage(searchCriteria: String?, completion: @escaping ConsumerCompletion) {
        
        currentSearchCriteria = searchCriteria
        reset()
    
        TService.getModels(searchCriteria: currentSearchCriteria, cursor: cursor) { [weak self] result in
            
            guard let self = self else { return }
            
            var getModelResult: Result<[Model], ModelError>
            
            switch result {
            case .success(let serviceModels):
                if serviceModels.count < self.cursor.limit {
                    self.pagingEnded = true
                }
                
                self.models.removeLast(3)
                self.models.append(contentsOf: serviceModels)
                self.cursor.moveToNextPage()
                

                getModelResult = .success(self.models)
                completion(getModelResult)
                
            case .failure(let error):
                self.pagingEnded = true
//                self.models.removeLast(3)
                
                getModelResult = .failure(error)
                completion(getModelResult)
            }
        }
    }
    
    func invalidate() {
        cursor = Cursor(limit: 10)
        pagingEnded = false
        models = []
        currentSearchCriteria = nil
    }
}
