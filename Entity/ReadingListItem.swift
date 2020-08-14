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
    var finishedReadingAt: Timestamp?
    var isDeleted: Bool
    
    func differenceDay(fromDate: Date) -> Int {
        guard let dueDate = self.dueDate else { return 0 }
        let diff = fromDate.differenceInDay(dueDate.dateValue())
        return diff
    }
}
