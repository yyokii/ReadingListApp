//
//  Application.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/07/05.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import UIKit

final class Application {

    static let shared = Application()
    private init() {}

    // ユースケース
    
    private(set) var authUseCase: AuthUseCaseProtocol!
    private(set) var readingListUseCase: ReadingListUseCaseProtocol!
    // 記事閲覧ユースケース
    private(set) var itemViewerUseCase: ItemViewerUseCaseProtocol!

    func configure(with window: UIWindow) {
        buildLayer()

        let homeVC = HomeVC.vc()
        let homeNav = UINavigationController()
        homeNav.viewControllers = [homeVC]
        window.rootViewController = homeNav
    }

//    // authのところ消して、nilで落ちるの確認して、builクラス作成するか
//    
//    // -- Interface Adapters
//    let userGateway = UserGateway()
//    let readingListGateway = ReadingListGateway()
//    let localPushGateway = LocalPushGateway()
//
//    // -- Framework & Drivers
//    let fireStoreClient = FireStoreClient()
//    let userDefaultsDataStore = UserDefaultsDataStore()
//    let notificationClient = NotificationClient()
//    
//    
//    func getAuth() {
//        // -- Use Case
//        let authUseCase = AuthUseCase()
//        // Interface Adaptersとのバインド
//        userGateway.fireStoreClient = fireStoreClient
//        // Use Caseとのバインド
//        authUseCase.userGateway = userGateway
//    }

    private func buildLayer() {

        // -- Use Case
        authUseCase = AuthUseCase()
        readingListUseCase = ReadingListUseCase()
        itemViewerUseCase = ItemViewerUseCase()

        // -- Interface Adapters
        let userGateway = UserGateway()
        let readingListGateway = ReadingListGateway()
        let localPushGateway = LocalPushGateway()

        // -- Framework & Drivers
        let fireStoreClient = FireStoreClient()
        let userDefaultsDataStore = UserDefaultsDataStore()
        let notificationClient = NotificationClient()
        
        // Interface Adaptersとのバインド
        userGateway.fireStoreClient = fireStoreClient
        readingListGateway.fireStoreClient = fireStoreClient
        readingListGateway.dataStore = userDefaultsDataStore
        localPushGateway.notificationClient = notificationClient
        
        // Use Caseとのバインド
        authUseCase.userGateway = userGateway
        readingListUseCase.readingListGateway = readingListGateway
        readingListUseCase.localPushGateway = localPushGateway
        itemViewerUseCase.readingListGateway = readingListGateway
        itemViewerUseCase.localPushGateway = localPushGateway
        
        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
    }
}

protocol HomePresenterInjectable {
    func inject(homePresenter: HomePresenterInput)
}

protocol ArticleWebPresenterInjectable {
    func inject(articleWebPresenter: ArticleWebPresenterInput)
}

protocol FloationPresenterInjectable {
    // 親viewのpresenterを利用しています
    func inject(homePresenter: HomePresenterInput)
}

