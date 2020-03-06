//
//  Common.swift
//  Fast_Buy_iOS
//
//  Created by null on 3/4/19.
//  Copyright © 2019 chinchilla. All rights reserved.
//

import Foundation
import UIKit

class Common {
    static let SCHEME = "https"
    static let HOST   = "fastbuych.com"
    static let HOSTNAME = "https://fastbuych.com"
    static let MAIN_COLOR = UIColor(red: 1/255, green: 196/255, blue: 164/255, alpha: 1)
    
    static func setButtomStyleZero(_ btn: UIButton, _ cornerRadius: CGFloat = 21) {
        btn.layer.cornerRadius = cornerRadius // default 21
        btn.layer.shadowOpacity = 0.25
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 1
    }
}

extension Double
{
    func toString(_ presicion: Int = 2) -> String
    {
        return String(format: "%.\(presicion)f", self)
    }
}

extension Int
{
    func toString() -> String
    {
        return "\(self)"
    }
}

extension UINavigationController
{
    func pushViewControllerFade(_ viewController: UIViewController)
    {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func popToRootViewControllerFade()
    {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        popToRootViewController(animated: false)
    }
}
