//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

// Input
protocol ReadingListUseCaseProtocol: AnyObject {
    /// 読み終わったもの一覧取得
    func fetchFinishedItems()
    
    /// 読み終わっていない and 近い内に削除予定のもの一覧取得
    func fetchReadingItemsWillDelete()
    
    /// 読み終わっていない and 削除されるまで時間があるもの一覧取得
    func fetchReadingItems()
    
    /// 保存
    func saveReadingItem(items: [[String: Any]])
    
    /// 削除
    func deleteReadingItem()
    
    /// 読み終わり
    func finishReading()
    
    /// 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReadingListUseCaseOutput! { get set }
}

// Output
protocol ReadingListUseCaseOutput {
    
    func didSaveReadingItem()
    
    // 読み終わったもの一覧が更新されたときに呼ばれる
    func didUpdateFinishedReadingItems(_ repoStatuses: String)
    
    //  読み終わっていない and 近い内に削除予定のもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItemsWillDelete(_ repoStatuses: String)
    
    // 読み終わっていない and 削除されるまで時間があるもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItems(_ repoStatuses: String)
    
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

final class ReadingListUseCase: ReadingListUseCaseProtocol {
    
    var userGateway: UserGatewayProtocol!
    
    func fetchFinishedItems() {
        
    }
    
    func fetchReadingItemsWillDelete() {
    }
    
    func fetchReadingItems() {
        userGateway.fetchReadingList { items in
            print(items)
        }
    }
    
    func saveReadingItem(items: [[String: Any]]) {
        
        userGateway.saveItems(items: items) { [weak self] res in
            
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
    
    var output: ReadingListUseCaseOutput!
    
    
}
