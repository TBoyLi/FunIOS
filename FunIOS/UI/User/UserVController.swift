//
//  UserVController.swift
//  FunIOS
//
//  Created by redli on 2021/7/21.
//

import UIKit
import Foundation
import SnapKitExtend
import SwiftEventBus

struct Menu {
    var type: Int
    var code: String
    var title: String
}

class UserVController: UIViewController {
    
    private let topView = UIView().then { (attr) in
        attr.backgroundColor = UIColor.red.withAlphaComponent(0.6)
    }
    
    //头像
    private let imgProfile = UIImageView().then { (attr) in
        attr.layer.cornerRadius = 30
        attr.layer.masksToBounds = true
        attr.isUserInteractionEnabled = true
        attr.image = UIImage(named: "mine_author")
    }
    
    //昵称
    private let labelNickName = UILabel().then { (attr) in
        attr.text = "立即登录"
        attr.lineBreakMode = .byTruncatingTail
        attr.numberOfLines = 1
        attr.font = UIFont.boldSystemFont(ofSize: 18)
        attr.isUserInteractionEnabled = true
        attr.textColor = UIColor.white
    }
    
    //等级
    private let labelLevel = UILabel().then { (attr) in
        attr.text = "lv 0"
        attr.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        attr.textColor = UIColor.white
    }
    
    //积分
    private let labelIntegral = UILabel().then { (attr) in
        attr.text = "积分 0"
        attr.textColor = UIColor.white
        attr.backgroundColor = UIColor.white
    }
    
    private let menus = [
        Menu(type: 1, code: "ic_collection", title: "收藏"),
        Menu(type: 2, code: "ic_share", title: "分享"),
        Menu(type: 3, code: "ic_integral", title: "积分"),
        Menu(type: 4, code: "ic_ranking", title: "排行榜"),
        Menu(type: 5, code: "ic_browsing", title: "浏览历史")
    ]
    
    private let normalToolView = UIView().then { (attr) in
        attr.layer.cornerRadius = 10
        attr.layer.masksToBounds = true
        attr.backgroundColor = UIColor.white
    }
    
    private let labelNormalTool = UILabel().then { (attr) in
        attr.text = "常用工具"
        attr.textColor = UIColor.black
        attr.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private let tools =  [
        Menu(type: 6, code: "ic_google", title: "Google仓库"),
        Menu(type: 7, code: "ic_todo", title: "TODO"),
        Menu(type: 8, code: "ic_calendar", title: "日历"),
        Menu(type: 9, code: "ic_courier", title: "快递"),
        Menu(type: 10, code: "ic_weather", title: "天气")
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        view.addSubview(topView)
        topView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(screenHeight / 4)
        }
        
        topView.addSubview(imgProfile)
        imgProfile.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(60)
            maker.leading.equalToSuperview().offset(20)
            maker.centerY.equalToSuperview().offset(20)
        }
        
        topView.addSubview(labelNickName)
        labelNickName.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview().offset(20)
            maker.leading.equalTo(imgProfile.snp.trailing).offset(15)
        }
        
        topView.addSubview(labelLevel)
        labelLevel.snp.makeConstraints { maker in
            maker.leading.equalTo(imgProfile.snp.trailing).offset(15)
            maker.top.equalTo(labelNickName.snp.bottom)
                .offset(10)
        }
        labelLevel.isHidden = true
        
        topView.addSubview(labelIntegral)
        labelIntegral.snp.makeConstraints { maker in
            maker.leading.equalTo(labelLevel.snp.trailing).offset(10)
            maker.top.equalTo(labelNickName.snp.bottom)
                .offset(10)
        }
        labelIntegral.isHidden = true
        
        let collectionMenusView = UserMenuCollectionView.init(source: menus)
        collectionMenusView.delegate = self
        view.addSubview(collectionMenusView)
        collectionMenusView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.height.equalTo(60)
        }
        
        view.addSubview(normalToolView)
        normalToolView.snp.makeConstraints { (attr) in
            attr.leading.equalToSuperview().offset(10)
            attr.trailing.equalToSuperview().offset(-10)
            attr.top.equalTo(collectionMenusView.snp.bottom).offset(15)
            attr.height.equalTo(200)
        }
        
        normalToolView.addSubview(labelNormalTool)
        labelNormalTool.snp.makeConstraints { (attr) in
            attr.leading.equalToSuperview().offset(10)
            attr.trailing.equalToSuperview().offset(-10)
            attr.top.equalToSuperview().offset(10)
            attr.height.equalTo(20)
        }
        
        let collectionToolsView = UserToolsCollectionView.init(source: tools)
        collectionToolsView.delegate = self
        normalToolView.addSubview(collectionToolsView)
        collectionToolsView.snp.makeConstraints { (attr) in
            attr.leading.equalToSuperview().offset(10)
            attr.trailing.equalToSuperview().offset(-10)
            attr.top.equalTo(labelNormalTool.snp.bottom).offset(10)
            attr.height.equalTo(150)
        }
        
        let userTap = UITapGestureRecognizer.init(target: self, action: #selector( onUserClick))
        
        let userJson = UserDefaults.standard.string(forKey: userKey)
        if userJson == nil {
            imgProfile.addGestureRecognizer(userTap)
            labelNickName.addGestureRecognizer(userTap)
        } else {
            let userModel = UserModel.deserialize(from: userJson)
            refreshUser(user: userModel)
        }
        
        SwiftEventBus.onMainThread(self, name: userEvent) { result in
            let userModel = result?.object as! UserModel
            self.refreshUser(user: userModel)
        }
        
    }
    
    @objc func onUserClick() {
        navigationController?.pushViewController(LoginVController(), animated: true)
    }
    
    private func refreshUser(user: UserModel?) {
        labelNickName.snp.updateConstraints { maker in
            maker.centerY.equalToSuperview().offset(5)
        }
        let coinCount = user?.coinCount ?? 0
        labelNickName.text = user?.nickname
        labelIntegral.text = String(coinCount)
        labelLevel.isHidden = false
        labelIntegral.isHidden = false
    }
}

extension UserVController : MenusDelegate, ToolsDelegate {
    
    func onMenuClick(type: Int, index: Int) {
        
        let userJson = UserDefaults.standard.string(forKey: userKey)
        
        if userJson == nil && ((userJson?.isEmpty) != nil) {
            navigationController?.pushViewController(LoginVController(), animated: true)
            return
        }
        
        switch type {
            case 1:
                
                break
            case 2:
                
                break
            case 3:
                
                break
            case 4:
                
                break
            case 5:
                
                break
            default:
                break
        }
    }

    func onToolClick(type: Int, index: Int) {
        var url = ""
        switch type {
            case 6:
                url = "https://www.wanandroid.com/maven_pom/index"
                break
            case 7:
                url = "https://www.wanandroid.com/lg/todo/list/0"
                break
            case 8:
                url = "https://wannianrili.bmcx.com/"
                break
            case 9:
                url = "https://www.kuaidi100.com/courier/"
                break
            case 10:
                url = "http://weathernew.pae.baidu.com/weathernew/pc?query=%E4%BA%91%E5%8D%97%E6%98%86%E6%98%8E%E5%A4%A9%E6%B0%94&srcid=4982&city_name=%E6%98%86%E6%98%8E&province_name=%E4%BA%91%E5%8D%97"
                break
            default:
                break
        }
        let webController = WebVController(title: self.tools[index].title, url: url)
        navigationController?.pushViewController(webController, animated: true)
    }
}
