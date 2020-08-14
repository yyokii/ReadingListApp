//
//  ReadingListGateway.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class ReadingListGateway: ReadingListGatewayProtocol {
    
    func changeFinishedState(id: String, isFinished: Bool, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.changeFinishedState(docId: id, isFinished: isFinished) { res in
            
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
    
    
    private weak var useCase: ReadingListUseCaseProtocol!
    var fireStoreClient: FirestoreClientProtocol!
    var dataStore: DataStoreProtocol!
    
    init(useCase: ReadingListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchReadingListFromLocal() -> [[String: Any]]? {
        return dataStore.fetchReadingItems()
    }
    
    func deleteLocalReadingListDatas() {
        dataStore.deleteReadingItems()
    }
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.addReadingItems(items: items) { res in
            
            switch res {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void) {
        
        fireStoreClient.fetchReadingList { res in
            //            completion()
            switch res {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
}
