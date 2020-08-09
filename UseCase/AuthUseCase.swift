//
//  AuthUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class AuthUseCase: AuthUseCaseProtocol {
    var userGateway: UserGatewayProtocol!
    var output: AuthUseCaseOutput!
    
    func fetchUser() {
        userGateway.fetchUser {[weak self] user in
            
            guard let self = self else { return }
            
            switch user.status {
            case .uninitialized:
                self.userGateway.signSignInAnonymously { (res) in
                    switch res {
                    case .success(let appUser):
                        self.output.didFetchUser()
                        break
                    case .failure(let error):
                        self.output.useCaseDidReceiveError(error)
                        break
                    }
                }
            case .authenticatedAnonymously:
                self.output.didFetchUser()
                break
            case .authenticated:
                self.output.didFetchUser()
                break
            }
        }
    }
    
    func signIn() {
    }
    
    func signOut() {
        
    }
}
