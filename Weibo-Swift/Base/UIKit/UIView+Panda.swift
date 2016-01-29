
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
    
    /// < shortcut for frame.origin
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(origin) {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    
    }
    
    ///< Shortcut for frame.origin.y + frame.size.height
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(bottom) {
            var frame = self.frame
            frame.origin.y = bottom - frame.size.height
            self.frame = frame
        }
    }
    
    ///< Shortcut for frame.origin.y
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }
    
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x){
            var frame = self.frame
            frame.origin.x = x
            self.frame = frame
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(right) {
            var frame = self.frame
            frame.origin.x = right - frame.size.width
            self.frame = frame
        }
    }
    
}
