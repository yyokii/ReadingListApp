//
//  ReadingListUseCaseProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
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
    
    /// 他のアプリから本アプリへシェアしたものをサーバーに保存
    func saveReadingItem()
    
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
    func didUpdateFinishedReadingItems(_ items: [ReadingListItem])
    
    //  読み終わっていない and 近い内に削除予定のもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItemsWillDelete(_ items: [ReadingListItem])
    
    // 読み終わっていない and 削除されるまで時間があるもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItems(_ items: [ReadingListItem])
    
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: WebClientError)
}
