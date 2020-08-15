//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class ReadingListUseCase: ReadingListUseCaseProtocol {
    
    var localPushGateway: LocalPushGateway!
    var readingListGateway: ReadingListGatewayProtocol!
    var output: ReadingListUseCaseOutput!
    
    func deleteReadingItem(_ id: String) {
        
        readingListGateway.deleteReadingItem(id: id) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                // 通知の削除設定必要
                
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
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func saveToReadingList(_ id: String) {
        
        readingListGateway.changeFinishedState(id: id, isFinished: false) { [weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.output.didUpdateItemData()
                
                // todo: 通知設定必要
                
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
}
