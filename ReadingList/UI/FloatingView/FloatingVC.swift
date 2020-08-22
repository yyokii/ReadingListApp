//
//  FloatingVC.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/30.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift

class FloatingVC: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    
    // 表示するアイテムの配列
    private var displayItems: [ReadingListItem]?
    // ここweakにしたいけど、そうするとnilになる、なぜ？？、他で参照されないweakはnilになるってよ
    // private var presenter: FloatingViewPresenterInput!
    private weak var homePresenter: HomePresenterInput!

    static func vc(homePresenter: HomePresenterInput) -> FloatingVC {
        
        let floatingVC: FloatingVC = UIStoryboard(name: "FloatingVC", bundle: nil).instantiateInitialViewController() as! FloatingVC
//        let readingListUseCase: ReadingListUseCase! = Application.shared.redingListUseCase
//        let floatingPresenter = FloatingViewPresenter(view: floatingVC, readingListUseCase: readingListUseCase)
        floatingVC.inject(homePresenter: homePresenter)
        
        return floatingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  presenter.viewWillAppear()
    }
    
    private func configureTableView() {
        articleTableView.dataSource = self
        articleTableView.delegate = self
        
        articleTableView.separatorStyle = .none
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
}

extension FloatingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = displayItems {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            if let items = displayItems {
                let item = items[indexPath.row]
                let optionTappedAction = {
                    #warning("ここ循環参照しないの？")
                    self.homePresenter.tapFinishedListOptionBtn(item: item)
                }
                cell.articleView.articleImage.image = nil
                cell.configureCell(row: indexPath.row, item: item, type: .FinishedList, tapOptionBtnAction: optionTappedAction)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
}

extension FloatingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = displayItems?[indexPath.row] {
            let vc = ArticleWebVC.viewController(item: item)
            present(vc, animated: true, completion: nil)
        }
    }   
}

extension FloatingVC: FloationPresenterInjectable {
    
    func inject(homePresenter: HomePresenterInput) {
        self.homePresenter = homePresenter
    }
}

extension FloatingVC: FloatingViewPresenterOutput {
    
    func displayNoContentView() {
    }
    
    func dismissNoContentView() {
    }
    
    func updateFinishedList(items: [ReadingListItem]) {
        displayItems = items
        articleTableView.reloadData()
    }
    
    func updateList() {
        // homePresenter.requestUpdateView()
    }
}
