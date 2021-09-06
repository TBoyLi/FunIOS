//
//  BaseVController.swift
//  FunIOS
//
//  Created by redli on 2021/9/6.
//

import Foundation
import UIKit


class BaseCVontroller:  UIViewController{
    
    func error(error: String?) {
        view.makeToast(error)
    }
}
