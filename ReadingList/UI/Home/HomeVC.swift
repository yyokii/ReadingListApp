//
//  HomeVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

import FloatingPanel
import AMPopTip

class HomeVC: UIViewController {
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var todayDeleteCollectionView: UICollectionView!
    @IBOutlet weak var readingCollectionView: UICollectionView!
    @IBOutlet weak var noTodayDeleteItemsLbl: UILabel!
    @IBOutlet weak var noReadingItemsLbl: UILabel!
    @IBOutlet weak var userButton: UIButton!
    
    var floatingPanelController: FloatingPanelController!
    var displayTodayDeleteItems: [ReadingListItem] = [ReadingListItem]()
    var displayReadingItems: [ReadingListItem] = [ReadingListItem]()
    let userStatusPopTip = PopTip()
    
    private weak var presenter: HomePresenterInput!
    
    static func vc() -> HomeVC {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeVC
        let dataStore = UserDefaultsDataStore()
        let homePresenter = HomePresenter(view: homeVC, authUseCase: Application.shared.authUseCase, readingListUseCase: Application.shared.readingListUseCase, dataStore: dataStore)
        
        homeVC.inject(homePresenter: homePresenter)
        return homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.viewWillAppear()
    }
    
    private func configureView() {        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        baseScrollView.contentInset = adjustForTabbarInsets
        
        configurePopTip()
        configureFloatingPanel()
        configureCollectionView()
    }
    
    private func configurePopTip() {
        userStatusPopTip.font = UIFont(name: "Avenir-Medium", size: 14)!
        userStatusPopTip.shouldDismissOnTap = true
        userStatusPopTip.shouldDismissOnTapOutside = true
        userStatusPopTip.shouldDismissOnSwipeOutside = true
        // バブル部分左のマージン
        userStatusPopTip.edgeMargin = 0
        // 左のオフセット
        userStatusPopTip.bubbleOffset = 2
        // 対象との距離
        userStatusPopTip.offset = 20
        // バブル内の上下左右
        userStatusPopTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userStatusPopTip.bubbleColor = UIColor.init(named: Constant.Color.cornFlower)!

        userStatusPopTip.actionAnimation = .bounce(8)
    }
    
    private func configureFloatingPanel() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        let floatingVC: FloatingVC = FloatingVC.vc(homePresenter: presenter)
        floatingPanelController.set(contentViewController: floatingVC)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    private func configureCollectionView() {
        let todayDeleteListLayout = UICollectionViewFlowLayout()
        todayDeleteListLayout.itemSize = CGSize(width:320, height:178)
        todayDeleteListLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        todayDeleteListLayout.scrollDirection = .horizontal
        
        let readingListlayout = UICollectionViewFlowLayout()
        readingListlayout.itemSize = CGSize(width:320, height:178)
        readingListlayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        readingListlayout.scrollDirection = .horizontal
        
        todayDeleteCollectionView.collectionViewLayout = todayDeleteListLayout
        readingCollectionView.collectionViewLayout = readingListlayout
        todayDeleteCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        readingCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        
        todayDeleteCollectionView.dataSource = self
        readingCollectionView.dataSource = self
        todayDeleteCollectionView.delegate = self
        readingCollectionView.delegate = self
        
        todayDeleteCollectionView.showsHorizontalScrollIndicator = false
        readingCollectionView.showsHorizontalScrollIndicator = false
    }
    
    #warning("未実装のためコメントアウト")
    //    @IBAction func tapShowingTodayDeleteItems(_ sender: Any) {
    //
    //        presenter.tapDisplayTodayDeleteView()
    //    }
    
    #warning("未実装のためコメントアウト")
    //    @IBAction func tapShowingReadingItems(_ sender: Any) {
    //
    //        let readingListVC = ReadingListTableVC.viewController()
    //        navigationController?.pushViewController(readingListVC, animated: true)
    //    }
    
    @IBAction func displayAboutAppVeiw(_ sender: Any) {
        
        let aboutAppVC = UIStoryboard(name: "AboutApp", bundle: nil).instantiateInitialViewController() as! AboutAppVC
        navigationController?.pushViewController(aboutAppVC, animated: true)
    }
    
    @IBAction func tapUserButton(_ sender: Any) {
        presenter.tapUserButton()
    }
}

extension HomeVC: HomePresenterInjectable {
    func inject(homePresenter: HomePresenterInput) {
        presenter = homePresenter
    }
}

extension HomeVC: HomePresenterOutput {
    
    func updateTodayDeleteList(items: [ReadingListItem]) {
        noTodayDeleteItemsLbl.isHidden = true
        displayTodayDeleteItems = items
        todayDeleteCollectionView.reloadData()
    }
    
    func updateReadingList(items: [ReadingListItem]) {
        noReadingItemsLbl.isHidden = true
        displayReadingItems = items
        readingCollectionView.reloadData()
    }
    
    func updateFinishedReadingList(items: [ReadingListItem]) {
        guard let floatingVC = floatingPanelController.contentViewController as? FloatingVC  else { return }
        
        floatingVC.updateFinishedList(items: items)
    }
    
    func displayReadingListDialog(item: ReadingListItem) {
        SwiftMessageUtil.showReadingListDialog(title: item.title, delegate: self)
    }
    
    func displayFinishedListDialog(item: ReadingListItem) {
        SwiftMessageUtil.showFinishedListDialog(title: item.title, delegate: self)
    }
    
    func displayTodayDeleteView(items: [ReadingListItem]) {
        let todayDeleteVC = TodayDeleteTableVC.viewController(items: items)
        navigationController?.pushViewController(todayDeleteVC, animated: true)
    }
    
    func showNoTodayDeleteItemsView() {
        noTodayDeleteItemsLbl.isHidden = false
    }
    
    func showNoReadingItemsView() {
        noReadingItemsLbl.isHidden = false
    }
    
    func showPopTip() {
        graphView.showPopTip(with: .first)
    }
    
    func showUserStatusPopTip(text: String) {
        userStatusPopTip.show(text: text, direction: .down, maxWidth: 300, in: view, from: userButton.frame, duration: 3)
    }
    
    func showRegisterDialog() {
        let dialog = AuthUserDialog.createRegisterDialog(registerAction: { [weak self]
            (mail, pass) in
            
            guard let self = self else { return }
            self.presenter.tapRegisterButton(mail: mail, pass: pass)
        }) { [weak self] (mail, pass) in
            
            guard let self = self else { return }
            self.presenter.tapLoginButton(mail: mail, pass: pass)
        }
        self.present(dialog, animated: true, completion: nil)
    }
    
    func showLogoutDialog() {
        let dialog = AuthUserDialog.createLogoutDialog {
            [weak self] in
            
            guard let self = self else { return }
            self.presenter.tapLogoutButton()
        }
        
        self.present(dialog, animated: true, completion: nil)
    }
    
    func displayUserData(viewData: GraphViewData) {
        graphView.configureView(datas: viewData)
    }
    
    func displayTutorialDialog() {
        SwiftMessageUtil.showTutorialDialog()
    }
}

extension HomeVC: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ArticleListPanelLayout()
    }
}

extension HomeVC: ReadingItemDialogViewDelegate {
    
    func tapToFinishedList() {
        presenter.tapMoveItemToFinishedList()
    }
    
    func tapDelete() {
        presenter.tapDeleteItem()
    }
}

extension HomeVC: FinishedItemDialogViewDelegate {
    func tapToReadingList() {
        presenter.tapMoveItemToReadingList()
    }
    
    func tapDeleteFinishedItem() {
        presenter.tapDeleteItem()
    }
}

extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == todayDeleteCollectionView {
            todayDeleteCollectionView.collectionViewLayout.invalidateLayout()
        } else if collectionView == readingCollectionView {
            readingCollectionView.collectionViewLayout.invalidateLayout()
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayDeleteCollectionView {
            return displayTodayDeleteItems.count
        } else if collectionView == readingCollectionView {
            return displayReadingItems.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == todayDeleteCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            let item = displayTodayDeleteItems[indexPath.row]
            let optionTappedAction = {
                self.presenter.tapOptionBtn(item: item)
            }
            cell.articleView.articleImage.image = nil
            cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: optionTappedAction)
            return cell
            
        } else if collectionView == readingCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            let item = displayReadingItems[indexPath.row]
            #warning("ここ循環参照しないかな？")
            let optionTappedAction = {
                self.presenter.tapOptionBtn(item: item)
            }
            cell.articleView.articleImage.image = nil
            cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: optionTappedAction)
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item: ReadingListItem?
        if collectionView == todayDeleteCollectionView {
            item = displayTodayDeleteItems[indexPath.row]
        } else if collectionView == readingCollectionView {
            item = displayReadingItems[indexPath.row]
        }
        guard let selectedItem = item else { return }
        let vc = ArticleWebVC.viewController(item: selectedItem)
        present(vc, animated: true, completion: nil)
    }
}
