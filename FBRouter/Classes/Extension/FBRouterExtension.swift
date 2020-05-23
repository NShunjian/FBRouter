//
//  FBRouterExtension.swift
//  Example
//
//  Created by Ori on 2020/5/16.
//  Copyright © 2020 Ori. All rights reserved.
//

import UIKit

extension  NSObject {
    public class func swizzleMethod(for aClass:AnyClass, originalSelector:Selector,swizzledSelector:Selector){
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)

        let didAddMethod = class_addMethod(aClass, originalSelector,
                                           method_getImplementation(swizzledMethod!),
                                           method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
           class_replaceMethod(aClass, swizzledSelector,
                               method_getImplementation(originalMethod!),
                               method_getTypeEncoding(originalMethod!))
        } else {
           method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}





// MARK - Extension
extension UINavigationController {

    func inBlockMode() -> Bool {
        return self.inAnimating;
    }
    
    private struct AssociatedKey {
        static var inAnimatingIdentifier: String = "inAnimatingIdentifier"
    }
    public var inAnimating:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.inAnimatingIdentifier) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.inAnimatingIdentifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
	
	
	
    public func pushViewController(_ viewController:UIViewController, completion: (() -> Void)? = nil) {
        inAnimating = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            guard completion != nil else{
                return;
            }
            completion!()
        }
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
	public func pushViewController(_ viewController:UIViewController, animated:Bool, completion: (() -> Void)? = nil) {
		inAnimating = true
		if !animated {
			pushViewController(viewController, animated: animated)
			inAnimating = false
			guard completion != nil else{
				return;
			}
			completion!()
			return
		}
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            guard completion != nil else{
                return;
            }
            completion!()
        }
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    public func popViewController(animated:Bool = true, _ completion: (() -> Void)? = nil){
        CATransaction.begin()
        CATransaction.setCompletionBlock{
            ()in
            guard completion != nil else{
                return;
            }
            completion!()
        }
        popViewController(animated: animated)
        CATransaction.commit()
    }
	
	public func popToViewController(_ viewController:UIViewController,animated:Bool = true, _ completion: (([UIViewController]?) -> Void)? = nil){
		var controllers:[UIViewController]?
        CATransaction.begin()
        controllers = popToViewController(viewController, animated: animated)
        CATransaction.setCompletionBlock{
            ()in
            guard completion != nil else{
                return;
            }
            completion!(controllers)
        }
        CATransaction.commit()
    }
	
    
    
    @objc func fbr_pushViewController(_ viewController:UIViewController,
                                      animated:Bool = true){
        if !animated && !(viewController.urlAction?.animation ?? false){
            fbr_pushViewController(viewController, animated: animated)
            self.inAnimating = false
            return
        }
        self.inAnimating = true
        CATransaction.begin()
        fbr_pushViewController(viewController, animated: animated)
        CATransaction.setCompletionBlock{
            ()in
            self.inAnimating = false
        }
        CATransaction.commit()
    }
    
    
    class func initializeMethod() {
        self.swizzleMethod(for: self, originalSelector: #selector(pushViewController(_:animated:)), swizzledSelector: #selector(fbr_pushViewController(_:animated:)))
    }
    
    
}


class FBRSwizzleManager:NSObject {
    private static let shareManager:FBRSwizzleManager = {
        let shared = FBRSwizzleManager.init()
        return shared
    }()
    
    private override init(){
        UINavigationController.initializeMethod()
    }
    
    @discardableResult
    public class func shared() -> FBRSwizzleManager{
        return shareManager
    }
}





