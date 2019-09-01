//
//  HomeVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import FloatingPanel

class HomeVC: UIViewController {
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var todayDeleteCollectionView: UICollectionView!
    @IBOutlet weak var readingCollectionView: UICollectionView!
    
    var floatingPanelController: FloatingPanelController!
    
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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:300, height:100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        
        todayDeleteCollectionView.collectionViewLayout = layout
        readingCollectionView.collectionViewLayout = layout
        todayDeleteCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        readingCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        
        todayDeleteCollectionView.dataSource = self
        readingCollectionView.dataSource = self
        todayDeleteCollectionView.delegate = self
        readingCollectionView.delegate = self
        
    }
}

extension HomeVC: HomePresenterOutput {
    func displayUserData(dataViewModel: GraphViewModel) {
        graphView.configureView(datas: dataViewModel)
    }
    
    func displayTodayDeleteList() {
    }
    
    func displayReadingList() {
    }
    
    func displayTutorialDialog() {
        SwiftMessageUtil.showCenteredIconMessage(iconImage: UIImage.init(named: "footer_icon")!, title: "ようこそ「Yomu」へ！", body: "ダウンロードありがとうございます☺️\n「Yomu」は通知の来る最新のリーディングリストアプリです。\n他のアプリから記事を「Yomu」へ追加し、「積ん読」をなくしましょう！", buttonTitle: "OK")

    }
}

extension HomeVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ArticleListPanelLayout()
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayDeleteCollectionView {
            return 2
        } else if collectionView == readingCollectionView {
            return 2
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == todayDeleteCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            return cell
            
        } else if collectionView == readingCollectionView {
            
            let cell : ArticleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            return cell

        } else {
            
            return UICollectionViewCell()
        }
    }
    
    
}

extension HomeVC: UICollectionViewDelegate {
    
}
