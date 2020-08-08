//
//  FirestoreClient.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

final class FireStoreClient: FirestoreClientProtocol {
    
    private var user: User!
    let auth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    func fetchReadingList(completion: @escaping () -> Void) {
        let ref = fireStore
            .collection(FiryeStoreKeyConstant.users)
            .document(user.uid)
            .collection(FiryeStoreKeyConstant.items)

        ref.getDocuments { (shapShot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                let items = shapShot!.documents.map {
                     try? $0.data(as: ReadingListItem.self)
                }
                print(items)
            }
        }
    }
    
    func fetchUser(completion: @escaping (AppUser) -> Void) {
        user = auth.currentUser
        completion(AppUser(from: user))
    }
    
    func deleteReadingItem() {
    }
    
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                self.user = user
                completion(.success(AppUser(from: self.user)))
            }
        }
    }
    
    func convertToPermanent(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        user?.link(with: credential) { (authResult, error) in
            
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                self.user = user
                completion(.success(AppUser(from: self.user)))
            }
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                //                completion(.success(user))
            }
        }
    }
    
    // ログアウト（Emailログインしている場合）
    func signOut(completion: @escaping (Result<Bool, WebClientError>) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let signOutError as NSError {
            print ("エラー サインアウト: %@", signOutError)
            completion(.failure(.serverError(signOutError)))
        }
    }
}

extension AppUser {
    init(from firebaseUser: User?) {
        
        if  firebaseUser == nil {
            // 未認証
            id = ""
            name = ""
            status = .uninitialized
        } else if firebaseUser!.isAnonymous {
            // 匿名ログイン
            id = firebaseUser!.uid
            name = ""
            status = .authenticatedAnonymously
        } else {
            // ログイン済
            id = firebaseUser!.uid
            name = ""
            status = .authenticatedAnonymously
        }
    }
}
