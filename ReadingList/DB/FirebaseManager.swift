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
    
    func fetchRssArticles(completion: (([Article]) -> Void)?) {
        let collectionRef = db.collection("Rss")
        
        collectionRef.getDocuments { (snapShot, error) in
            // 各Rssの記事の配列
            var articles = [Article]()

            // 各Rssのドキュメント参照を取得
            let rssRefs = snapShot?.documents.map({ (docSnapShot) in
                docSnapShot.reference
            })
            
            rssRefs?.forEach({ reference in
                reference.collection("Items").getDocuments { (itemsSnapShot, error) in
                    // 記事データを全て取得
                    let datas = itemsSnapShot?.documents.map({ (docSnapShot) in
                        docSnapShot.data()
                    })
                    // 記事データを配列に格納する
                    datas?.forEach { data  in
                        let timeStamp = data["date"] as! Timestamp
                        let dateValue = timeStamp.dateValue()
                        
                        let article = Article(url: data["url"] as! String, title: data["title"] as! String, imageUrl: data["imageUrl"] as? String, summary: data["summary"] as? String, date: dateValue)
                        articles.append(article)
                    }
                }
            })
        }
    }
}

