//
//  CFFlowButtonView.swift
//  FunIOS
//
//  Created by redli on 2021/7/25.
//

import UIKit

class FlowButtonView: UIView {
    ///存放需要显示的button
    var buttonList: [UIButton]?
    
    ///  通过传入一组按钮初始化CFFlowButtonView
    ///
    ///  - Parameter buttonList: 按钮数组
    ///
    ///  - Returns: CFFlowButtonView对象
    init(buttonList: inout [UIButton]) {
        super.init(frame: .zero)
        self.buttonList = buttonList
        
        for button in self.buttonList ?? [] {
            guard let button = button as? UIButton else {
                continue
            }
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        
        let margin: CGFloat = 10
        
        // 存放每行的第一个Button
        var rowFirstButtons: [AnyHashable] = []
        
        // 对第一个Button进行设置
        let button0 = buttonList?[0]
        button0?.x = margin
        button0?.y = margin
        if let buttonList1 = buttonList?[0] {
            rowFirstButtons.append(buttonList1)
        }
        
        // 对其他Button进行设置
        var row = 0
        for i in 1..<(buttonList?.count ?? 0) {
            let button = buttonList?[i]
            
            var sumWidth = 0
            let start = buttonList?.firstIndex(of: rowFirstButtons[row] as! UIButton) ?? NSNotFound
            for j in start...i {
                let button = buttonList?[j]
                sumWidth += Int(((button?.width ?? 0.0) + margin))
            }
            sumWidth += 10
            
            let lastButton = buttonList?[i - 1]
            if sumWidth >= Int(width) {
                button?.x = margin
                button?.y = (lastButton?.y ?? 0.0) + margin + (button?.height ?? 0.0)
                if let button = button {
                    rowFirstButtons.append(button)
                }
                row += 1
            } else {
                button?.x = CGFloat(sumWidth) - margin - (button?.width ?? 0.0)
                button?.y = lastButton?.y ?? 0
            }
        }
        
        
        let lastButton = buttonList?.last
        height = (lastButton?.frame.maxY ?? 0.0) + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
