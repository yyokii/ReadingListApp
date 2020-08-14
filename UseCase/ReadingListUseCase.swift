//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class ReadingListUseCase: ReadingListUseCaseProtocol {
    
    var readingListGateway: ReadingListGatewayProtocol!
    var output: ReadingListUseCaseOutput!
    
    func deleteReadingItem(_ id: String) {
        
        readingListGateway.deleteReadingItem(id: id) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func finishReadingItem(_ id: String) {
        
        readingListGateway.changeFinishedState(id: id, isFinished: true) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func fetchFinishedItems() {
        
    }
    
    func fetchReadingItemsWillDelete() {
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
                
                self.output.didUpdateReadingItemsData(items)
                self.output.didUpdateReadingItemsWillDelete(lessOneDayItems)
                self.output.didUpdateReadingItems(moreThanOneDayItems)
                self.output.didUpdateFinishedReadingItems(finishedReadingItems)
                
                
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func saveReadingItem() {
        
        guard let items = readingListGateway.fetchReadingListFromLocal() else {
            self.output.didSaveReadingItem()
            return
        }
        
        readingListGateway.saveItems(items: items) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didSaveReadingItem()
                // 通知設定
                items.forEach {
                    NotificationManager.addNotification(title: $0[Constant.ReadingItem.title] as! String, targetDate: $0[Constant.ReadingItem.dueDate] as! Date, type: .OneDayBefore )
                    NotificationManager.addNotification(title: $0[Constant.ReadingItem.title] as! String, targetDate: $0[Constant.ReadingItem.dueDate] as! Date, type: .TwoDaysBefore )
                }
                
                self.readingListGateway.deleteLocalReadingListDatas()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func saveToReadingList(_ id: String) {
        
        readingListGateway.changeFinishedState(id: id, isFinished: true) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
}
