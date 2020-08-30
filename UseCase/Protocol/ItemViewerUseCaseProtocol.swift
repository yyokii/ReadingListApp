//
//  ItemViewerUseCaseProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/17.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

// Input
protocol ItemViewerUseCaseProtocol: AnyObject {
    
    /// 既存アイテムのステータスを読み終わりにする
    func finishReadingItem(_ item: ReadingListItem)
    
    /// 既存アイテムをリーディングリストに追加
    func saveToReadingList(_ item: ReadingListItem)
    
    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ItemViewerUseCaseOutput! { get set }
    
    var readingListGateway: ReadingListGatewayProtocol! { get set }
    var localPushGateway: LocalPushGatewayProtocol! { get set }
}

// Output
protocol ItemViewerUseCaseOutput {
    
    /// アイテムのデータが更新された時に呼ばれる
    func didUpdateItemData(_ itemID: String)
    
    /// Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: AppError)
}
