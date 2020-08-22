//
//  ItemViewerUseCase.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/17.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class ItemViewerUseCase: ItemViewerUseCaseProtocol {
    
    var localPushGateway: LocalPushGatewayProtocol!
    var readingListGateway: ReadingListGatewayProtocol!
    var output: ItemViewerUseCaseOutput!
    
    func finishReadingItem(_ item: ReadingListItem) {
        
        readingListGateway.changeStateToFinished(id: item.id!) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData(item.id!)
                // 通知の削除
                self.localPushGateway.deleteNotification(id: item.id!)
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func saveToReadingList(_ item: ReadingListItem) {
        
        let now = Date()
        // 一週間後の日付（=読み終わり予定の期限日）を取得
        let calendar = Calendar.current
        let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
        guard let due = dueDate else { return }
        
        readingListGateway.changeStateToReading(id: item.id!, dueDate: due) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData(item.id!)
                
                // 通知の登録
                self.localPushGateway.registerOneDayBeforePush(id: item.id!, title: item.title, targetDate: due)
                self.localPushGateway.registerTwoDaysBeforePush(id: item.id!, title: item.title, targetDate: due)
                
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
}
