//
//  UserGateway.swift
//  GateWay
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class UserGateway: UserGatewayProtocol {
    
    var fireStoreClient: FirestoreClientProtocol!
    
    private var user: AppUser?
    
    func fetchUser(completion: @escaping (AppUser) -> Void) {
        
        if let appUser = user {
            // キャッシュ
            completion(appUser)
        } else {
            fireStoreClient.fetchUser { user in
                self.user = user
                completion(user)
            }
        }
    }
    
    func signIn(with email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
    }
    
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        fireStoreClient.signSignInAnonymously { [weak self] res in
            guard let self = self else {
                completion(.failure(.other(nil)))
                return
            }
            
            switch res {
            case .success(let appUser):
                self.user = appUser
                completion(.success(self.user!))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
}
