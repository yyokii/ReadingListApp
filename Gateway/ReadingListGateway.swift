//
//  ReadingListGateway.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class ReadingListGateway: ReadingListGatewayProtocol {
    
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
    
    func fetchReadingList( completion: @escaping ([ReadingItem]) -> Void) {
        fireStoreClient.fetchReadingList {
            //            completion()
        }
    }
}
