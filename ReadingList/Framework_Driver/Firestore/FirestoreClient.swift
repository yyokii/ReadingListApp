//
//  FirestoreClient.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStoreClient: FirestoreClientProtocol {
    
    private var user: User!
    let auth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    func addReadingItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void) {
        
        // FireStoreに保存するデータ整形
        let saveItems = items.map {
            [Constant.ReadingItem.title : $0[Constant.ReadingItem.title] as! String, Constant.ReadingItem.url: $0[Constant.ReadingItem.url] as! String, Constant.ReadingItem.createdAt: Timestamp(date: $0[Constant.ReadingItem.createdAt] as! Date) , Constant.ReadingItem.dueDate: Timestamp(date: $0[Constant.ReadingItem.dueDate] as! Date), Constant.ReadingItem.isDeleted: false]
        }
        
        let ref = fireStore
            .collection(FiryeStoreKeyConstant.users)
            .document(user.uid)
            .collection(FiryeStoreKeyConstant.items)
        
        // バッチ書き込み
        let batch: WriteBatch = fireStore.batch()
        
        // 通信成功時に返却する、id付きのエンティティ配列
        var saveItemsWithId: [ReadingListItem] = []
        
        saveItems.forEach {
            
            let docRef = ref.document()
            batch.setData($0, forDocument: docRef)
            
            saveItemsWithId.append(ReadingListItem(id: docRef.documentID, title: $0[Constant.ReadingItem.title] as! String, url: $0[Constant.ReadingItem.url] as! String, createdAt: Timestamp(date: $0[Constant.ReadingItem.createdAt] as! Date), dueDate: Timestamp(date: $0[Constant.ReadingItem.dueDate] as! Date), finishedReadingAt: nil, isDeleted: false))
        }
        
        batch.commit() { err in
            if let err = err {
                completion(.failure(.serverError(err)))
            } else {
                completion(.success(saveItemsWithId))
            }
        }
    }
    
    func changeFinishedState(docId: String, isFinished: Bool, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        let ref = fireStore
            .collection(FiryeStoreKeyConstant.users)
            .document(user.uid)
            .collection(FiryeStoreKeyConstant.items)
            .document(docId)
        
        let data: [String: Any] = [Constant.ReadingItem.finishedAt: isFinished ? FieldValue.serverTimestamp() : NSNull()]
        
        ref.updateData(data) { (error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func deleteReadingItem(docId: String, completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        let ref = fireStore
            .collection(FiryeStoreKeyConstant.users)
            .document(user.uid)
            .collection(FiryeStoreKeyConstant.items)
            .document(docId)
        
        ref.updateData(
        [Constant.ReadingItem.isDeleted: true]) { (error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void) {
        let ref = fireStore
            .collection(FiryeStoreKeyConstant.users)
            .document(user.uid)
            .collection(FiryeStoreKeyConstant.items)
        
        ref.getDocuments { (shapShot, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                let items = shapShot!.documents.compactMap {
                    try! $0.data(as: ReadingListItem.self)
                }
                completion(.success(items))
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
