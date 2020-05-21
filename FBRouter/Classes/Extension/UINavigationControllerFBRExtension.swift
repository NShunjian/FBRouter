//
//  UINavigationControllerFBRExtension.swift
//  Example
//
//  Created by Ori on 2020/5/17.
//  Copyright © 2020 Ori. All rights reserved.
//

import UIKit


extension UINavigationController{
    func inBlockMode() -> Bool {
        guard self.presentedViewController != nil else {
            return false
        }
        return self.inAnimating;
    }
    
}
