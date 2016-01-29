//
//  UIImage+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/28.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation

extension UIImage {
    
    
    func imageWithSize(size: CGSize, drawBlock:(context: CGContextRef) -> Void) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()
        if context == nil { return nil }
        drawBlock(context: context!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}