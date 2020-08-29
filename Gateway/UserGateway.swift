//
//  UserGateway.swift
//  GateWay
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class UserGateway: UserGatewayProtocol {
    
    var fireStoreClient: FirestoreClientProtocol!
    
    var currentUser: AppUser?    
    
    func convertToPermanent(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        fireStoreClient.convertToPermanent(email: email, pass: pass) { [weak self] res in
            
            guard let self = self else {
                completion(.failure(.other(nil)))
                return
            }
            
            switch res {
            case .success(let appUser):
                self.currentUser = appUser
                completion(.success(self.currentUser!))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }

    
    func fetchUser(completion: @escaping (AppUser) -> Void) {
        
        if let appUser = currentUser {
            // キャッシュを返す
            completion(appUser)
        } else {
            fireStoreClient.fetchUser { user in
                self.currentUser = user
                completion(user)
            }
        }
    }
    
    func signOut(completion: @escaping (WebClientError?) -> Void) {
        
        fireStoreClient.signOut { error in
            
            if let error = error {
                self.currentUser = nil
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        fireStoreClient.signIn(email: email, pass: pass) { [weak self] res in
            
            guard let self = self else {
                completion(.failure(.other(nil)))
                return
            }
            
            switch res {
            case .success(let appUser):
                self.currentUser = appUser
                completion(.success(self.currentUser!))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        fireStoreClient.signSignInAnonymously { [weak self] res in
            guard let self = self else {
                completion(.failure(.other(nil)))
                return
            }
            
            switch res {
            case .success(let appUser):
                self.currentUser = appUser
                completion(.success(self.currentUser!))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
}
