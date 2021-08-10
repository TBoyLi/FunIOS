//
//  BaseTableViewCell.swift
//  FunIOS
//
//  Created by redli on 2021/7/22.
//

import UIKit
import Reusable


// Reusable 是用回收的

class BaseTableViewCell: UITableViewCell, Reusable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    open func configUI() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
