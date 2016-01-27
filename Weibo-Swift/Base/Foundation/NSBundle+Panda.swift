//
//  NSBundle+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/25.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation

extension NSBundle {

    func pathForScaledResource(name: String,ofType ext: String) -> String? {
        if name.characters.count == 0 { return nil }
        if name.hasSuffix("/") { return self.pathForResource(name, ofType: ext) }
        
        let scales: NSArray! = self.preferredScales
        var path: String?
        for s in 0..<scales.count {
            let scale: Int = scales[s] as! Int
            let scaleName: String = ext.characters.count != 0 ? name.stringByAppendingNameScale(scale) : name.stringByAppendingPathScale(scale)
            path = self.pathForResource(scaleName, ofType: ext)
            if path != nil {
                break
            }
        }
        return path
    }
    
    var preferredScales: NSArray! {
        get {
            struct Static {
                static var scales: NSArray = NSArray()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                let screenScale = UIScreen.mainScreen().scale
                if screenScale <= 1 {
                    Static.scales = [1,2,3]
                } else if screenScale <= 2{
                    Static.scales = [2,3,1]
                } else {
                    Static.scales = [3,2,1]
                }
            }
            return Static.scales
        }
    }

}