//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class ReadingListUseCase: ReadingListUseCaseProtocol {
    
    var localPushGateway: LocalPushGatewayProtocol!
    var readingListGateway: ReadingListGatewayProtocol!
    var output: ReadingListUseCaseOutput!
    
    func deleteReadingItem(_ item: ReadingListItem) {
        
        readingListGateway.deleteReadingItem(id: item.id!) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                // 通知の削除
                self.localPushGateway.deleteNotification(id: item.id!)
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    func finishReadingItem(_ item: ReadingListItem) {
        
        readingListGateway.changeStateToFinished(id: item.id!) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                // 通知の削除
                self.localPushGateway.deleteNotification(id: item.id!)
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    func fetchReadingItems() {
        
        readingListGateway.fetchReadingList { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success(var items):
                
                let now = Date()
                
                items.sort {
                    $0.createdAt.dateValue() < $1.createdAt.dateValue()
                }
                
                let lessOneDayItems = items.filter { $0.isDeleted == false && $0.finishedReadingAt == nil && $0.differenceDay(fromDate: now) <= 1 }
                let moreThanOneDayItems = items.filter { $0.isDeleted == false && $0.finishedReadingAt == nil && $0.differenceDay(fromDate: now) > 1 }
                let finishedReadingItems = items.filter { $0.isDeleted == false && $0.finishedReadingAt != nil }
                
                self.output.didUpdateReadingItemsData(lessOneDayItems + moreThanOneDayItems)
                self.output.didUpdateReadingItemsWillDelete(lessOneDayItems)
                self.output.didUpdateReadingItems(moreThanOneDayItems)
                self.output.didUpdateFinishedReadingItems(finishedReadingItems)
                
                
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    func saveReadingItem() {
        
        guard let items = readingListGateway.fetchReadingListFromLocal() else {
            return
        }
        
        readingListGateway.saveItems(items: items) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success(let items):
                self.output.didUpdateItemData()
                
                items.forEach {
                    self.localPushGateway.registerOneDayBeforePush(id: $0.id!, title: $0.title, targetDate: $0.dueDate!.dateValue())
                    self.localPushGateway.registerTwoDaysBeforePush(id: $0.id!, title: $0.title, targetDate: $0.dueDate!.dateValue())
                }
                
                self.readingListGateway.deleteLocalReadingListDatas()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
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
                self.output.didUpdateItemData()
                
                self.localPushGateway.registerOneDayBeforePush(id: item.id!, title: item.title, targetDate: due)
                self.localPushGateway.registerTwoDaysBeforePush(id: item.id!, title: item.title, targetDate: due)
                
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error: error)
                break
            }
        }
    }
    
    /// ローカル（Realm）で永続化していたものをサーバーで持つように修正
    func convertDataToRemote() {
        
    }
}
