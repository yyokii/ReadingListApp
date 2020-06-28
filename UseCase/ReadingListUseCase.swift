//
//  ReadingListUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import GateWay

// Input
// Use Caseが外側に公開するインターフェイス
protocol ReadingListUseCaseProtocol: AnyObject {
    // 読み終わったもの一覧取得
    func fetchFinishedItems()
    
    // 読み終わっていない and 近い内に削除予定のもの一覧取得
    func fetchReadingItemsWillDelete()
    
    // 読み終わっていない and 削除されるまで時間があるもの一覧取得
    func fetchReadingItems()
    
    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReadingListUseCaseOutput! { get set }
}

// Output
protocol ReadingListUseCaseOutput {
    // 読み終わったもの一覧が更新されたときに呼ばれる
    func didUpdateFinishedReadingItems(_ repoStatuses: Data)
    
    //  読み終わっていない and 近い内に削除予定のもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItemsWillDelete(_ repoStatuses: Data)
    
    // 読み終わっていない and 削除されるまで時間があるもの一覧が更新されたときに呼ばれる
    func didUpdateReadingItems(_ repoStatuses: Data)
    
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}
