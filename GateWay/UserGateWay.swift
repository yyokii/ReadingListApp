//
//  UserGateWay.swift
//  GateWay
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class UserGateWay: UserGateWayProtocol {
    
    private weak var useCase: AuthUseCaseProtocol!
    var fireStoreClient: FirestoreClientProtocol!
//    var dataStore: DataStoreProtocol!
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchUser(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
    }
    
    func signIn(with email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
    }
    
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
    }
}
