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

    var currentUser: AppUser? {
         return userGateway.currentUser
     }
    
    func fetchUser() {
        
        // TODO: これresでエラーも返すようにしないといけなくね
        userGateway.fetchUser {[weak self] user in
            
            guard let self = self else { return }
            
            switch user.status {
            case .uninitialized:
                self.userGateway.signSignInAnonymously { (res) in
                    switch res {
                    case .success:
                        self.output.didFetchUser()
                        break
                    case .failure(let error):
                        self.output.useCaseDidReceiveError(error: error)
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
    
    func registerUser(mail: String, pass: String) {
        
        userGateway.convertToPermanent(email: mail, pass: pass) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didRegisterUser()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    func signIn(mail: String, pass: String) {

        userGateway.signIn(email: mail, pass: pass) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didsignIn()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    func signOut() {
        
    }
}
