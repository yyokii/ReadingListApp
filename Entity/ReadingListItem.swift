//
//  ReadingItem.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/04.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

struct ReadingListItem: Codable {
    @DocumentID var id: String?
    let title: String
    let url: String
    let createdAt: Timestamp
    var dueDate: Timestamp?
    var finishedReadingDate: Timestamp?
    var isDeleted: Bool
    
}
