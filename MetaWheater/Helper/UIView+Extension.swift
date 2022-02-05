//
//  UIView+Extension.swift
//  MetaWheater
//
//  Created by Hasan Dag on 5.02.2022.
//

import UIKit

extension UIView {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIViewController {

    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
