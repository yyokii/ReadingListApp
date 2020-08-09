//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

final class ReadingListUseCase: ReadingListUseCaseProtocol {
    
    var readingListGateway: ReadingListGatewayProtocol!
    var output: ReadingListUseCaseOutput!
    
    func fetchFinishedItems() {
        
    }
    
    func fetchReadingItemsWillDelete() {
    }
    
    func fetchReadingItems() {
        readingListGateway.fetchReadingList { items in
            print(items)
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
                // TODO: ここで通知設定を行う
                // TODO: ここでuserDefaultsのデータを削除する、gatewayを呼ぶ
                UserDefaultManager.shareInstance.deleteReadingItems()
                break
            case .failure(let error):
                self.output.useCaseDidReceiveError(error)
                break
            }
        }
    }
    
    func deleteReadingItem() {
    }
    
    func finishReading() {
    }
}
