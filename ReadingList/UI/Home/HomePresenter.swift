//
//  HomePresenter.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomePresenterInput: AnyObject {
    func tapOptionBtn(item: ReadingListItem)
    func tapFinishedListOptionBtn(item: ReadingListItem)
    func tapDisplayTodayDeleteView()
    func tapMoveItemToFinishedList()
    func tapMoveItemToReadingList()
    func tapDeleteItem()
    func tapUserButton()
    func tapRegisterButton(mail: String, pass: String)
    func tapLoginButton(mail: String, pass: String)
    func tapLogoutButton()
    func viewDidLoad()
    func viewWillAppear()
}

protocol  HomePresenterOutput: CanDisplayErrorDialog, Loadable {
    func displayTutorialDialog()
    func displayReadingListDialog(item: ReadingListItem)
    func displayFinishedListDialog(item: ReadingListItem)
    func displayUserData(viewData: GraphViewData)
    func displayTodayDeleteView(items: [ReadingListItem])
    func showRegisterDialog()
    func showLogoutDialog()
    func showNoTodayDeleteItemsView()
    func showNoReadingItemsView()
    func showPopTip()
    func showUserStatusPopTip(text: String)
    func updateFinishedReadingList(items: [ReadingListItem])
    func updateTodayDeleteList(items: [ReadingListItem])
    func updateReadingList(items: [ReadingListItem])
}

final class  HomePresenter {
    private var view: HomePresenterOutput!
    private weak var authUsecase: AuthUseCaseProtocol!
    private weak var readingListUseCase:  ReadingListUseCaseProtocol!
    private var dataStore: DataStoreProtocol!
    
    let notificationCenter = NotificationCenter.default
    
    private var optionTappedItem: ReadingListItem!
    private var notFinishedItems: [ReadingListItem]!
    private var errorMessage: [String] = []
    
    init(view: HomePresenterOutput, authUseCase: AuthUseCaseProtocol, readingListUseCase: ReadingListUseCaseProtocol, dataStore: DataStoreProtocol) {
        self.view = view
        self.authUsecase = authUseCase
        self.readingListUseCase = readingListUseCase
        self.dataStore = dataStore
        
        self.readingListUseCase.output = self
        self.authUsecase.output = self
        
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        // アプリがフォアグラウンドになったことを検知
        notificationCenter.addObserver(
            self, selector: #selector(saveReadingItem), name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    private func getTodayDeleteItems(from items: [ReadingListItem], now: Date) -> [ReadingListItem] {
        
        var readingItems: [ReadingListItem] = [ReadingListItem]()
        
        for item: ReadingListItem in items where item.differenceDay(fromDate: now) <= 1 {
            readingItems.append(item)
        }
        
        return readingItems
    }
    
    private func emailValidate(email: String) {
        do {
            _ = try Validator.validatedText(text: email, validationType: .email)
        } catch {
            errorMessage.append((error as? AppError)?.message ?? "")
        }
    }
    
    private func passwordValidate(password: String) {
        do {
            _ = try Validator.validatedText(text: password, validationType: .password)
        } catch {
            errorMessage.append((error as? AppError)?.message ?? "")
        }
    }
    
    private func showUserStatusPoptip() {
        
        guard let user = authUsecase.currentUser else {
            return
        }
        
        switch user.status {
        case .uninitialized:
            break
        case .authenticated:
            // ログイン状態
            view.showUserStatusPopTip(text: "現在ログイン中です😊")
        case .authenticatedAnonymously:
            // 匿名ログイン状態
            view.showUserStatusPopTip(text: "現在ゲストログイン中です")
        }
    }
    
    @objc private func saveReadingItem() {
        readingListUseCase.saveReadingItem()
    }
}

extension  HomePresenter: HomePresenterInput {
    
    func tapMoveItemToFinishedList() {
        guard let item = optionTappedItem else {
            return
        }
        readingListUseCase.finishReadingItem(item)
    }
    
    func tapMoveItemToReadingList() {
        
        guard let item = optionTappedItem else {
            return
        }
        readingListUseCase.saveToReadingList(item)
    }
    
    func tapDeleteItem() {
        guard let item = optionTappedItem else {
            return
        }
        readingListUseCase.deleteReadingItem(item)
    }
    
    func tapDisplayTodayDeleteView() {
        let items = getTodayDeleteItems(from: notFinishedItems, now: Date())
        view.displayTodayDeleteView(items: items)
    }
    
    func tapOptionBtn(item: ReadingListItem) {
        optionTappedItem = item
        view.displayReadingListDialog(item: item)
    }
    
    func tapFinishedListOptionBtn(item: ReadingListItem) {
        optionTappedItem = item
        view.displayFinishedListDialog(item: item)
    }
    
    func tapUserButton() {
        guard let user = authUsecase.currentUser else {
            return
        }
        
        switch user.status {
        case .uninitialized:
            break
        case .authenticated:
            // ログイン状態、ログアウトボタンを出す
            view.showLogoutDialog()
        case .authenticatedAnonymously:
            // 匿名ログイン状態、新規登録 or ログインボタンを出す
            view.showRegisterDialog()
        }
    }
    
    func tapRegisterButton(mail: String, pass: String) {
        
        emailValidate(email: mail)
        passwordValidate(password: pass)
        
        if errorMessage.isEmpty {
            authUsecase.registerUser(mail: mail, pass: pass)
        } else {
            let message = errorMessage.joined(separator: "\n")
            view.showErrorDialog(message: message, buttonAction: nil)
            errorMessage.removeAll()
        }
    }
    
    func tapLoginButton(mail: String, pass: String) {
        
        emailValidate(email: mail)
        passwordValidate(password: pass)
        
        if errorMessage.isEmpty {
            authUsecase.signIn(mail: mail, pass: pass)
        } else {
            let message = errorMessage.joined(separator: "\n")
            view.showErrorDialog(message: message, buttonAction: nil)
            errorMessage.removeAll()
        }
    }
    
    func tapLogoutButton() {
        authUsecase.signOut()
    }
    
    func viewDidLoad() {
        if dataStore.isFirstOpenArticleView() {
            // 初回表示時
            view.displayTutorialDialog()
            dataStore.setFirstOpenArticleView()
        }
    }
    
    func viewWillAppear() {
        view.showLoadingView()
        authUsecase.fetchUser()
    }
}

extension HomePresenter: AuthUseCaseOutput {
    
    func didFetchUser() {
        showUserStatusPoptip()
        readingListUseCase.fetchReadingItems()
    }
    
    func didsignIn() {
        readingListUseCase.fetchReadingItems()
    }
    
    func didRegisterUser() {
    }
    
    func useCaseDidReceiveError(error: AppError) {
    }
}

extension HomePresenter: ReadingListUseCaseOutput {
    
    func didUpdateItemData() {
        readingListUseCase.fetchReadingItems()
    }
    
    func didUpdateReadingItemsData(_ items: [ReadingListItem]) {
        view.hideLoadingView()
        let viewData = GraphViewData(items: items)
        view.displayUserData(viewData: viewData)
        view.showPopTip()
    }
    
    func didUpdateFinishedReadingItems(_ items: [ReadingListItem]) {
        view.hideLoadingView()
        view.updateFinishedReadingList(items: items)
    }
    
    func didUpdateReadingItemsWillDelete(_ items: [ReadingListItem]) {
        view.hideLoadingView()
        if items.count > 0 {
            view.updateTodayDeleteList(items: items)
        } else {
            view.updateTodayDeleteList(items: [ReadingListItem]())
            view.showNoTodayDeleteItemsView()
        }
    }
    
    func didUpdateReadingItems(_ items: [ReadingListItem]) {
        
        if items.count > 0 {
            view.updateReadingList(items: items)
        } else {
            view.updateReadingList(items: [ReadingListItem]())
            view.showNoReadingItemsView()
        }
    }
}
