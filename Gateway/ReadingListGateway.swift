//
//  ReadingListGateway.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class ReadingListGateway: ReadingListGatewayProtocol {
    
    var fireStoreClient: FirestoreClientProtocol!
    var dataStore: DataStoreProtocol!
    
    func changeStateToReading(id: String, dueDate: Date, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.changeStateToReading(docId: id, dueDate: dueDate) { res in
            
            switch res {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func changeStateToFinished(id: String, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.changeStateToFinished(docId: id) { res in
            
            switch res {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func deleteReadingItem(id: String, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.deleteReadingItem(docId: id) { res in
            
            switch res {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchReadingListFromLocal() -> [[String: Any]]? {
        return dataStore.fetchReadingItems()
    }
    
    func deleteLocalReadingListDatas() {
        dataStore.deleteReadingItems()
    }
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void) {
        
        fireStoreClient.addReadingItems(items: items) { res in
            
            switch res {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void) {
        
        fireStoreClient.fetchReadingList { res in
            
            switch res {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
}
