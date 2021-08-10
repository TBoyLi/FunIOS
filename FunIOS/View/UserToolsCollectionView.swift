//
//  UserToolsCollectionView.swift
//  FunIOS
//
//  Created by redli on 2021/7/30.
//

import UIKit

public protocol ToolsDelegate: NSObjectProtocol {
    func onToolClick(type: Int, index: Int) -> Void
}

class UserToolsCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak open var delegate: ToolsDelegate?
    
    private var data: Array<Menu>!
    
    private let collectionToolsView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then { (attr) in
        attr.itemSize = CGSize(width: (screenWidth - 10 - 10) / 5 - 5, height: 60)
    }).then { (attr) in
        attr.register(MenuCell.self, forCellWithReuseIdentifier: "tools_cell")
        attr.backgroundColor = UIColor.white
        attr.layer.cornerRadius = 10
        attr.layer.masksToBounds = true
    }
    
    init(source data: Array<Menu>) {
        super.init(frame: .zero)
        self.data = data
        
        collectionToolsView.delegate = self
        collectionToolsView.dataSource = self
        
        addSubview(collectionToolsView)
        collectionToolsView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.onToolClick(type: self.data[indexPath.row].type, index: indexPath.row)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tools_cell", for: indexPath) as! MenuCell
        cell.imgIcon.image = UIImage(named: self.data[indexPath.row].code)
        cell.labelTitle.text = self.data[indexPath.row].title
        return cell
    }
    
    
}
