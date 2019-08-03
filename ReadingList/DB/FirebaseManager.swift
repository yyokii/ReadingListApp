//
//  FirebaseManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/18.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

/**
 collとdocのデータ取得方法の注意点についいて：https://qiita.com/sosumii/items/010e9a2d1b5e7698bf77
 
 timestampについて: https://stackoverflow.com/questions/51008044/converting-firestore-timestamp-to-date-data-type
 */

import Firebase

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchArticles(completion: @escaping (_ result: [Article]) -> Void) {
        let collectionRef = db.collection("Articles")
                
        collectionRef.order(by: "date", descending: true).limit(to: 50).getDocuments { (snapShot, error) in
            guard error == nil else {
                return
            }
            
            // 記事データを全て取得
            let datas = snapShot?.documents.map({ (docSnapShot) in
                docSnapShot.data()
            })
            
            // 記事の配列
            var articles = [Article]()
            // 記事データを配列に格納する
            datas?.forEach { data  in
                
                let timeStamp = data["date"] as! Timestamp
                let dateValue = timeStamp.dateValue()
                
                let article = Article(url: data["url"] as! String, title: data["title"] as! String, imageUrl: data["imgUrl"] as? String, summary: data["summary"] as? String, date: dateValue)
                articles.append(article)
            }
            completion(articles)
        }
    }
}

