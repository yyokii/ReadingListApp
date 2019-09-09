//
//  HomeVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import FloatingPanel
import RealmSwift

class HomeVC: UIViewController {
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var todayDeleteCollectionView: UICollectionView!
    @IBOutlet weak var readingCollectionView: UICollectionView!
    @IBOutlet weak var noTodayDeleteItemsLbl: UILabel!
    @IBOutlet weak var noReadingItemsLbl: UILabel!
    
    var floatingPanelController: FloatingPanelController!
    var displayTodayDeleteItems: Results<ReadingItem>?
    var displayReadingItems: Results<ReadingItem>?
    
    private var presenter: HomePresenterInput!
    
    func inject(presenter: HomePresenterInput) {
        self.presenter = presenter
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
        
        configureFloatingPanel()
        configureCollectionView()
    }
    
    private func configureFloatingPanel() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        //        if #available(iOS 11, *) {
        //            floatingPanelController.surfaceView.cornerRadius =
        //        } else {
        //            floatingPanelController.surfaceView.cornerRadius = 0.0
        //        }
        let storyboard: UIStoryboard = UIStoryboard(name: "FloatingVC", bundle: nil)
        let floatingVC = storyboard.instantiateInitialViewController() as! FloatingVC
        let floatingViewModel = FloatingViewModel()
        let floatingViewPresenter = FloatingViewPresenter(view: floatingVC, model: floatingViewModel)
        floatingVC.inject(presenter: floatingViewPresenter)
        floatingPanelController.set(contentViewController: floatingVC)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    private func configureCollectionView() {
        let todayDeleteListLayout = UICollectionViewFlowLayout()
        todayDeleteListLayout.itemSize = CGSize(width:320, height:178)
        todayDeleteListLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        todayDeleteListLayout.scrollDirection = .horizontal
        
        let readingListlayout = UICollectionViewFlowLayout()
        readingListlayout.itemSize = CGSize(width:320, height:178)
        readingListlayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        readingListlayout.scrollDirection = .horizontal
        
        todayDeleteCollectionView.collectionViewLayout = todayDeleteListLayout
        readingCollectionView.collectionViewLayout = readingListlayout
        todayDeleteCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        readingCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        
        todayDeleteCollectionView.dataSource = self
        readingCollectionView.dataSource = self
        todayDeleteCollectionView.delegate = self
        readingCollectionView.delegate = self
    }
    
    @IBAction func tapShowingTodayDeleteItems(_ sender: Any) {

        let todayDeleteVC = UIStoryboard(name: "TodayDelete", bundle: nil).instantiateInitialViewController() as! TodayDeleteTableVC
        let todayDeleteModel = TodayDeleteModel()
        let todayDeletePresenter = TodayDeletePresenter(view: todayDeleteVC, model: todayDeleteModel)
        todayDeleteVC.inject(presenter: todayDeletePresenter)
        navigationController?.pushViewController(todayDeleteVC, animated: true)
    }
    
    @IBAction func tapShowingReadingItems(_ sender: Any) {

        let readingListVC = UIStoryboard(name: "ReadingList", bundle: nil).instantiateInitialViewController() as! ReadingListTableVC
        let readingListModel = ReadingListModel()
        let readingListPresenter = ReadingListPresenter(view: readingListVC, model: readingListModel)
        readingListVC.inject(presenter: readingListPresenter)
        navigationController?.pushViewController(readingListVC, animated: true)
    }
    
    @IBAction func displayAboutAppVeiw(_ sender: Any) {
        
        let aboutAppVC = UIStoryboard(name: "AboutApp", bundle: nil).instantiateInitialViewController() as! AboutAppVC
        navigationController?.pushViewController(aboutAppVC, animated: true)
    }
}

extension HomeVC: HomePresenterOutput {
    func showNoTodayDeleteItemsView() {
        noTodayDeleteItemsLbl.isHidden = false
    }
    
    func showNoReadingItemsView() {
        noReadingItemsLbl.isHidden = false
    }

    func displayUserData(dataViewModel: GraphViewModel) {
        graphView.configureView(datas: dataViewModel)
    }
    
    func displayTutorialDialog() {
        SwiftMessageUtil.showCenteredIconMessage(iconImage: UIImage.init(named: "logo")!, title: "ようこそ「Yomu」へ！", body: "ダウンロードありがとうございます☺️\n「Yomu」は通知の来る最新のリーディングリストアプリです。\n他のアプリから記事を「Yomu」へ追加し、「積ん読」をなくしましょう！", buttonTitle: "OK")

    }
    
    func updateTodayDeleteList(items: Results<ReadingItem>?) {
        noTodayDeleteItemsLbl.isHidden = true
        displayTodayDeleteItems = items
        todayDeleteCollectionView.reloadData()
    }
    
    func updateReadingList(items: Results<ReadingItem>?) {
        noReadingItemsLbl.isHidden = true
        displayReadingItems = items
        readingCollectionView.reloadData()
    }
}

extension HomeVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ArticleListPanelLayout()
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
            return displayTodayDeleteItems?.count ?? 0
        } else if collectionView == readingCollectionView {
            return displayReadingItems?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == todayDeleteCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            if let items = displayTodayDeleteItems {
                let item = items[indexPath.row]
                cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: nil)
            }
            return cell
            
        } else if collectionView == readingCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            if let items = displayReadingItems {
                let item = items[indexPath.row]
                cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: nil)
            }
            return cell

        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    
}
