//
//  FBURLAction.swift
//  Example
//
//  Created by Ori on 2020/5/16.
//  Copyright © 2020 Ori. All rights reserved.
//

import UIKit

public enum FBTargetType {
    case undefined
	case controller
	case bridge
}

public struct FBRouterOptions:OptionSet {
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public let rawValue: UInt
    static let push = FBRouterOptions(rawValue: 1 << 0)
    static let present = FBRouterOptions(rawValue: 1 << 1)
    static let wrap_nc = FBRouterOptions(rawValue: 1 << 2)

}

func URLFromString(host:String) -> URL {
    return  URL.init(string: FBRouter.router().scheme + "://" + host)!
}

public class FBURLAction:NSObject {
    
    public var options:[FBRouterOptions] = [FBRouterOptions.push]
    public private(set) var params:Dictionary<String, Any> = [:]
	public var animation:Bool = true
	public var openExternal:Bool = false
	public var isSingleton:Bool = false
    public weak var from:UIViewController?
    public var completeBlock:((Bool)->Void)? = nil
    public var url:URL?
	public var urlTarget:FBURLTarget?
	
	
	override init() {
		super.init()
	}
    
    public convenience init(url:URL){
        self.init()
        self.url = url
        guard let para = url.queryParameters else {
            return
        }
        for item in para {
            params[item.key.lowercased()] = item.value
        }
    }
    
    public convenience init(urlString:String) {
        let url = URL.init(string: urlString) ?? URLFromString(host: "")
        self.init(url:url)
    }
    
	public convenience init(host:String) {
        self.init(url:URLFromString(host: host))
	}
    
	public convenience init(httpUrl:String?) {
		var url = URLFromString(host: "web")
		if httpUrl?.isBlank == false{
            url = url.appendingQueryParameters(["url" : httpUrl!])
		}
        self.init(url:url)
	}
    
    func setCompleteBlock(_ block: ((Bool) -> Void)? = nil) {
        self.completeBlock = block
    }
    
}


public extension FBURLAction{
    
    
    
    
}







extension String {
	var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
}


public class FBURLTarget:NSObject{
    var    key:String?
    var    targetString:String?
    var    targetClass:AnyClass?
    var    targetType:FBTargetType
    
    
    public override init() {
        self.targetType = FBTargetType.undefined
    }
    
    public convenience  init(key:String,target:String){
        self.init()
        self.key = key
        self.targetString = target
        self.targetClass =  FBClassFromString(string: target)
        if self.targetClass is UIViewController.Type{
            self.targetType = FBTargetType.controller
        }
    }
}



let FBRouterAppName =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String?

public func  FBClassFromString(string: String)-> AnyClass?{
    let stringName = FBRouterAppName! + "." + string
    return NSClassFromString(stringName)
}


public extension UIViewController {
    private struct AssociatedKey {
        static var urlActionIdentifier: String = "urlActionIdentifier"
    }
    var urlAction:FBURLAction{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.urlActionIdentifier) as? FBURLAction ?? FBURLAction.init()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.urlActionIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setURLAction(urlAction:FBURLAction) {
        self.urlAction = urlAction
    }
    
    convenience init(urlAction:FBURLAction) {
        self.init()
        self.urlAction = urlAction
    }
    
}
