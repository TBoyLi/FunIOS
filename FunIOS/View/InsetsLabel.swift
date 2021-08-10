//
//  InsetsLabel.swift
//  FunIOS
//
//  Created by redli on 2021/7/23.
//

import UIKit

class InsetsLabel: UILabel {
    
    var textInsets: UIEdgeInsets? // 控制字体与控件边界的间隙
    
    init() {
        super.init(frame: CGRect.zero)
        textInsets = .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textInsets = .zero
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets!))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
