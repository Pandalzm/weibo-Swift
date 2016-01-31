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
    
    func imageWithColor(color: UIColor) -> UIImage? {
        return self.imageWithColor(color, size: CGSizeMake(1, 1))
    }
    
    func imageWithColor(color: UIColor?, size: CGSize) -> UIImage? {
        if color == nil || size.width <= 0 || size.height <= 0 { return nil }
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color?.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}