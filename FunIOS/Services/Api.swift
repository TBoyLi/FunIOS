//
//  Api.swift
//  FunIOS
//
//  Created by redli on 2021/7/22.
//

import Foundation
import HandyJSON

class Api {
    
    //获取轮播图列表
    static func fetchBanners(block: @escaping(_ result: Array<BannerModel>?) -> ()) {
        HttpUtils.request(url: "banner/json", block: block)
    }
    
    //获取置顶文章列表
    static func fetchTopArticles(block: @escaping(_ result: Array<ArticleItemModel>?) -> ()) {
        HttpUtils.request(url: "article/top/json", block: block)
    }
    
    //获取文章列表
    static func fetchArticles(page: Int, block: @escaping(_ result: ArticleModel?) -> ()) {
        HttpUtils.request(url: "article/list/\(page)/json", block: block)
    }
    
    //获取项目分类
    static func fetchProjectSegmented(block: @escaping(_ result: Array<StructureModel>?) -> ()) {
        HttpUtils.request(url: "project/tree/json", block: block)
    }
    
    //获取项目文章列表
    static func fetchProjectArticles(page: Int, cid: Int, block: @escaping(_ result: ArticleModel?) -> ()) {
        HttpUtils.request(url: "article/list/\(page)/json?cid=\(cid)", block: block)
    }
    
    //获取公众号分类
    static func fetchWechatSegmented(block: @escaping(_ result: Array<StructureModel>?) -> ()) {
        HttpUtils.request(url: "wxarticle/chapters/json", block: block)
    }
    
    //获取公众号文章列表
    static func fetchWechatArticles(page: Int, cid: Int, block: @escaping(_ result: ArticleModel?) -> ()) {
        HttpUtils.request(url: "wxarticle/list/\(cid)/\(page)/json", block: block)
    }
    
    //获取navigation item 体系中的体系列表
    static func fetchStructures(block: @escaping(_ result: Array<StructureModel>?) -> ()) {
        HttpUtils.request(url: "tree/json", block: block)
    }
    
    //获取navigation item 体系中的导航列表
    static func fetchNavigations(block: @escaping(_ result: Array<NavigationModel>?) -> ()) {
        HttpUtils.request(url: "navi/json", block: block)
    }

    //登录
    static func login(username: String, password: String, block: @escaping(_ result: UserModel?) -> ()) {
        HttpUtils.request(url: "user/login", type: MethodType.post, params: ["username": username, "password" : password], block: block)
    }
    
    //获取用户等级和积分
    static func fetchUserCoinLevel(block: @escaping(_ result: UserCoinLevelModel?) -> ()) {
        HttpUtils.request(url: "lg/coin/userinfo/json", block: block)
    }
    
    //获取收藏文章列表
    static func fetchCollectArticles(page: Int, block: @escaping(_ result: ArticleModel?) -> ()) {
        HttpUtils.request(url: "/lg/collect/list/\(page)/json", block: block)
    }
    
    //获取个人积分
    static func fetchMyIntegral(page: Int, block: @escaping(_ result: IntegralModel?) -> ()) {
        HttpUtils.request(url: "lg/coin/list/\(page)/json", block: block)
    }
    
    //获取积分排行榜
    static func fetchRanking(page: Int, block: @escaping(_ result: RankingModel?) -> ()) {
        HttpUtils.request(url: "coin/rank/\(page)/json", block: block)
    }
}
