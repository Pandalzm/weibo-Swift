//
//  CALayer+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/29.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation


extension CALayer {
    
    var size: CGSize! {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        } set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
}