//
//  Application.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/07/05.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import UIKit

class Application {

    static let shared = Application()
    private init() {}

    // ユースケース
    private(set) var authUseCase: AuthUseCase!
    private(set) var redingListUseCase: ReadingListUseCase!

    func configure(with window: UIWindow) {
        buildLayer()

        let homeVC = HomeVC.vc()
        let homeNav = UINavigationController()
        homeNav.viewControllers = [homeVC]
        window.rootViewController = homeNav
    }

    private func buildLayer() {

        // -- Use Case
        authUseCase = AuthUseCase()
        redingListUseCase = ReadingListUseCase()

        // -- Interface Adapters
        let userGateway = UserGateway(useCase: authUseCase)

        // -- Framework & Drivers
        let fireStoreClient = FireStoreClient()

        // Interface Adaptersとのバインド
        userGateway.fireStoreClient = fireStoreClient
        
        // Use Caseとのバインド
        authUseCase.userGateway = userGateway
        redingListUseCase.userGateway = userGateway
        
        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
    }
}

protocol HomePresenterInjectable {
    func inject(homePresenter: HomePresenterInput)
}

