//
//  PandaCGUtilities.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/24.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation


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

public func kScreenWidth() -> CGFloat {
    return PandaScreenSize().kScreenWidth
}

public func kScreenHeight() -> CGFloat {
    return PandaScreenSize().kScreenHeight
}

