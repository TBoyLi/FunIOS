//
//  WechatAccountVController.swift
//  FunIOS
//
//  Created by redli on 2021/7/21.
//

import UIKit
import SnapKitExtend
import JXSegmentedView

class WechatVController: UIViewController {
    
    private let segmentedView = JXSegmentedView()
    
    private let segmentedDataSource = JXSegmentedTitleDataSource()
    
    private lazy var  divLine = UIView().then({ (attr) in
        attr.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    })
    
    //配置指示器
    private let indicator = JXSegmentedIndicatorLineView()
    
    private lazy var listContainerView:JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    //指示器内容
    private var tabTitles : [String] = []
    
    private var viewControllers: [WechatArticlesVController] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        Api.fetchWechatSegmented { (value:Array<StructureModel>?) in
            value?.forEach({ (item: StructureModel) in
                self.tabTitles.append(item.name)
                self.viewControllers.append(WechatArticlesVController(cid: item.id))
            })
            self.loadUI()
        }
    }
    
    private func loadUI() {
        self.segmentedDataSource.titles = self.tabTitles
        self.segmentedView.dataSource = self.segmentedDataSource
        self.view.addSubview(self.segmentedView)
        self.view.addSubview(self.divLine)
        self.indicator.indicatorWidth = 20
        self.segmentedView.indicators = [self.indicator]
        self.segmentedView.listContainer = self.listContainerView
        self.view.addSubview(self.listContainerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        segmentedView.frame = CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: 50)
        
        divLine.frame = CGRect(x: 0, y: statusBarHeight + 50, width: screenWidth, height: 1)
        
        listContainerView.frame = CGRect(x: 0, y: statusBarHeight + 50 + 1, width: screenWidth, height: screenHeight - statusBarHeight - 50 - 1)
    }
}

extension WechatVController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return viewControllers.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return viewControllers[index]
    }
}
