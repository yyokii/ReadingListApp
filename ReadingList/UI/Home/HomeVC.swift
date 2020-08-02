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
    var displayTodayDeleteItems: [ReadingItem]?
    var displayReadingItems: [ReadingItem]?
    
    private weak var presenter: HomePresenterInput!
    
    static func vc() -> HomeVC {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeVC
        // todo: modelを後から外したい
        let homeModel = HomeModel()
        let authUseCase: AuthUseCase! = Application.shared.authUseCase
        let homePresenter = HomePresenter(view: homeVC, authUseCase: authUseCase, model: homeModel)
        authUseCase.output = homePresenter
        
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
    
    @IBAction func tapShowingTodayDeleteItems(_ sender: Any) {

        presenter.tapDisplayTodayDeleteView()
    }
    
    @IBAction func tapShowingReadingItems(_ sender: Any) {

        let readingListVC = ReadingListTableVC.viewController()
        navigationController?.pushViewController(readingListVC, animated: true)
    }
    
    @IBAction func displayAboutAppVeiw(_ sender: Any) {
        
        let aboutAppVC = UIStoryboard(name: "AboutApp", bundle: nil).instantiateInitialViewController() as! AboutAppVC
        navigationController?.pushViewController(aboutAppVC, animated: true)
    }
}

extension HomeVC: HomePresenterInjectable {
    func inject(homePresenter: HomePresenterInput) {
        presenter = homePresenter
    }
}

extension HomeVC: HomePresenterOutput {
    func updateTodayDeleteList(items: [ReadingItem]?) {
        noTodayDeleteItemsLbl.isHidden = true
        displayTodayDeleteItems = items
        todayDeleteCollectionView.reloadData()
    }
    
    func updateReadingList(items: [ReadingItem]?) {
        noReadingItemsLbl.isHidden = true
        displayReadingItems = items
        readingCollectionView.reloadData()
    }
    
    func displayReadingListDialog(item: ReadingItem) {
        SwiftMessageUtil.showReadingListDialog(title: item.title)
    }
    
    func displayTodayDeleteView(items: [ReadingItem]) {
        let todayDeleteVC = TodayDeleteTableVC.viewController(items: items)
        navigationController?.pushViewController(todayDeleteVC, animated: true)
    }
    
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
        SwiftMessageUtil.showTutorialDialog()
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
                let optionTappedAction = {
                    self.presenter.tapOptionBtn(item: item)
                }
                cell.articleView.articleImage.image = nil
                cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: optionTappedAction)
            }
            return cell
            
        } else if collectionView == readingCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            if let items = displayReadingItems {
                let item = items[indexPath.row]
                let optionTappedAction = {
                    self.presenter.tapOptionBtn(item: item)
                }
                cell.articleView.articleImage.image = nil
                cell.configureCell(row: indexPath.row, item: item, type: .ReadingList, tapOptionBtnAction: optionTappedAction)
            }
            return cell

        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item: ReadingItem?
        if collectionView == todayDeleteCollectionView {
            item = displayTodayDeleteItems?[indexPath.row]
        } else if collectionView == readingCollectionView {
            item = displayReadingItems?[indexPath.row]
        }
        guard let selectedItem = item else { return }
        let vc = ArticleWebVC.viewController(item: selectedItem)
        present(vc, animated: true, completion: nil)
    }
}
