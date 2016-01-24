//
//  NSData+Panda.swift
//  Twitter-Swift
//
//  Created by PandaLZMing on 16/1/20.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation

public extension NSData {
    
    public func dataNamed(name: String) -> NSData {

        if let path = NSBundle.mainBundle().pathForResource(name, ofType: "") {
            let data = NSData(contentsOfFile: path)
            return data!
        }
       return NSData.init()
    }
}
