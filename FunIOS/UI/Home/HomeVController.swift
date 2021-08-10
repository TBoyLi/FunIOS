//
//  MainVController.swift
//  FunIOS
//
//  Created by redli on 2021/7/21.
//

import UIKit
import Then
import LLCycleScrollView
import SnapKit
import SVProgressHUD
import MBProgressHUD
import HandyJSON

class HomeVController: UIViewController {
    
    var page = 0
    
    private var articleList = Array<ArticleItemModel>()
    
    private var bannerLists = Array<BannerModel>()
    
    private lazy var dispatchGroup = { return DispatchGroup.init() }()
    
    private lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain).then({ (attr) in
        attr.backgroundColor = UIColor.white
        attr.delegate = self
        attr.dataSource = self
        attr.alwaysBounceVertical = true
        //        attr.separatorStyle = .none
    })
    
    private lazy var bannerView = LLCycleScrollView().then({ (attr) in
        attr.backgroundColor = UIColor.yellow
        attr.autoScrollTimeInterval = 5
        attr.placeHolderImage = UIImage(named: "normal_placeholder_h")
        attr.coverImage = UIImage(named: "normal_placeholder_h")
        attr.imageViewContentMode = .scaleToFill
        attr.pageControlPosition = .right
        attr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth / 2)
        attr.lldidSelectItemAtIndex = self.didSelectBanner(index:)
    })
    
    private func didSelectBanner(index: NSInteger) {
        let bannerModel = self.bannerLists[index]
        let webVController = WebVController(title: bannerModel.title, url: bannerModel.url)
        navigationController?.pushViewController(webVController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.tableHeaderView = bannerView
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        setRefresh()
    }
    
    private func setRefresh() {
        
        let refreshHeader = RefreshHeader{ [weak self] in
            self?.page = 0
            self?.getData(false)
        }
        
        refreshHeader.isAutomaticallyChangeAlpha = true
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        tableView.mj_header = refreshHeader
        refreshHeader.beginRefreshing()
        
        tableView.mj_footer =  RefreshFooter{ [weak self] in
            self?.getData(true)
        }
        tableView.mj_footer?.isAutomaticallyChangeAlpha = true
    }
    
    
    private func getData(_ loadMore: Bool = false) {
        if !loadMore {
            page = 0
        } else {
            page += 1
        }
        
        if !loadMore {
            Api.fetchBanners(block: {(value:Array<BannerModel>?) in
                self.bannerLists = value ?? []
                self.bannerView.imagePaths = value?.map{$0.imagePath} ?? []
                self.bannerView.titles = value?.map{ $0.title} ?? []
            })
            
            self.dispatchGroup.enter()
            Api.fetchTopArticles(block: {(value: Array<ArticleItemModel>?) in
                self.articleList = value ?? []
                self.dispatchGroup.leave()
            })
        }
        
        self.dispatchGroup.enter()
        Api.fetchArticles(page: page) {(value: ArticleModel?) in
            //结束刷新
            if self.tableView.mj_header!.isRefreshing  { self.tableView.mj_header?.endRefreshing()
            }
            
            if self.tableView.mj_footer!.isRefreshing { self.tableView.mj_footer?.endRefreshing()
            }
            
            //是否加载更多
            if loadMore {
                if value?.datas.count ?? 0 <= 0 {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()                } else {
                        self.articleList.append(contentsOf: value!.datas)
                    }
            } else {
                if value?.datas.count ?? 0 < 20 {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.articleList.append(contentsOf: value!.datas)
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
}

extension HomeVController: UITableViewDataSource, UITableViewDelegate {
    //数据
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    //每行行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    //每行加载样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: ArticleCell.self)
        tableViewCell.model = articleList[indexPath.row]
        return tableViewCell
    }
    
    //item点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.articleList[indexPath.row]
        let webVController = WebVController(title: model.title, url: model.link)
        navigationController?.pushViewController(webVController, animated: true)
    }
    
}
