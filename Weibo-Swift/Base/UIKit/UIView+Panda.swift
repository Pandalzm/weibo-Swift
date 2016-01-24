
//
//  UIView+Panda.swift
//  DoubleCircleAnimation
//
//  Created by PandaLZMing on 16/1/19.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    
    ///< Shortcut for frame.size.width
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    ///< Shortcut for frame.size.height
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    ///< Shortcut for center.x
    public var centerX: CGFloat {
        get{
            return self.center.x
        }
        set(centerX) {
            self.center = CGPoint(x: centerX, y: self.center.y)
        }
    }
    
    ///< Shortcut for center.y
    public var centerY: CGFloat {
        get{
            return self.center.y
        }
        set(centerY) {
            self.center = CGPoint(x: self.center.x, y: centerY)
        }
    }
    
    ///< Shortcut for frame.size
    public var size: CGSize {
        get{
            return self.frame.size
        }
        set(size) {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
}
