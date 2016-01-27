//
//  String+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/25.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation

extension String {

    func stringByAppendingNameScale(scale: Int) -> String {
        if fabs(Float(scale) - 1) <= __FLT_EPSILON__ || self.characters.count == 0 || self.hasSuffix("/"){
            return self
        }
        return self.stringByAppendingString("@\(scale)x")
    }
    
    func stringByAppendingPathScale(scale: Int) -> String {
        if fabs(Float(scale) - 1) <= __FLT_EPSILON__ || self.characters.count == 0 || self.hasSuffix("/"){ return self }
        let ext: NSString = self as NSString
        let path: NSString = ext.pathExtension
        var extRange: NSRange = NSMakeRange(self.characters.count - path.length, 0)
        if path.length > 0 { extRange.location -= 1}
        return ext.stringByReplacingCharactersInRange(extRange, withString: "@\(scale)x")
    }
    
    //< shortcut of characters.count
    var length: Int {
        return self.characters.count
    }


}