//
//  PandaCGUtilities.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/24.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation




/// < shortcut of ScreenWidth
public func kScreenWidth() -> CGFloat {
    return PandaScreenSize().kScreenWidth
}

/// < shortcut of ScreenHeight
public func kScreenHeight() -> CGFloat {
    return PandaScreenSize().kScreenHeight
}

public func PandaScreenScale() -> CGFloat {
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var scale: CGFloat = CGFloat()
    }
    dispatch_once(&Static.onceToken) { () -> Void in
        Static.scale = UIScreen.mainScreen().scale
    }
    return Static.scale
}

public func CGFloatPixelFloor(value: CGFloat) -> CGFloat {
    let scale = PandaScreenScale()
    return round(value * scale) / scale
}

/// 按比例缩放像素
public func CGFloatPixelRound(value: CGFloat) -> CGFloat {
    let scale: CGFloat = PandaScreenScale()
    return round(value * scale) / scale
}

public func CGFloatFromPixel(value: CGFloat) -> CGFloat{
    return value / PandaScreenScale()
}

public func UIEdgeInsetPixelFloor(insets: UIEdgeInsets) -> UIEdgeInsets {
    var insets = insets
    insets.top = CGFloatPixelFloor(insets.top)
    insets.left = CGFloatPixelFloor(insets.left)
    insets.bottom = CGFloatPixelFloor(insets.bottom)
    insets.right = CGFloatPixelFloor(insets.right)
    return insets
}

/// 按比例缩放CGSize
public func CGSizePixelRound(size: CGSize) -> CGSize {
    let scale = PandaScreenScale()
    return CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale)
}

private struct PandaScreenSize {
    
    var kScreenWidth: CGFloat { get{ return pandaScreenSize.width }}
    var kScreenHeight: CGFloat { get{ return pandaScreenSize.height }}
    
    var pandaScreenSize: CGSize {
        get {
            struct Static {
                static var onceToken: dispatch_once_t = 0
                static var size: CGSize = CGSize()
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.size = UIScreen.mainScreen().bounds.size
                if Static.size.height < Static.size.width {
                    let tmp = Static.size.height
                    Static.size.height = Static.size.width
                    Static.size.width = tmp
                }
            }
            return Static.size
        }
    }
}


