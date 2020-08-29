//
//  ReadingListUseCaseProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

// Input
protocol ReadingListUseCaseProtocol: AnyObject {
    
    /// 読み終わっていない and 削除されるまで時間があるもの一覧取得
    func fetchReadingItems()
    
    /// 他のアプリから本アプリへシェアしたものをサーバーに保存
    func saveReadingItem()
    
    /// 任意のアイテムを1件削除
    func deleteReadingItem(_ item: ReadingListItem)
    
    /// 既存アイテムのステータスを読み終わりにする
    func finishReadingItem(_ item: ReadingListItem)
    
    /// 既存アイテムをリーディングリストに追加
    func saveToReadingList(_ item: ReadingListItem)
    
    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReadingListUseCaseOutput! { get set }
    
    var readingListGateway: ReadingListGatewayProtocol! { get set }
    var localPushGateway: LocalPushGatewayProtocol! { get set }
}

// Output
protocol ReadingListUseCaseOutput {
    
    /// アイテムのデータが更新された時に呼ばれる
    func didUpdateItemData()
    
    /// 読み終わったもの一覧が更新された時に呼ばれる
    func didUpdateFinishedReadingItems(_ items: [ReadingListItem])
    
    /// 読み終わってないもの一覧が更新された時に呼ばれる
    func didUpdateReadingItemsData(_ items: [ReadingListItem])

    ///  読み終わっていない and 近い内に削除予定のもの一覧が更新された時に呼ばれる
    func didUpdateReadingItemsWillDelete(_ items: [ReadingListItem])
    
    /// 読み終わっていない and 削除されるまで時間があるもの一覧が更新された時に呼ばれる
    func didUpdateReadingItems(_ items: [ReadingListItem])
    
    /// Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(error: WebClientError)
}
