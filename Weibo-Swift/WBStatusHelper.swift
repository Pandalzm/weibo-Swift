//
//  WBStatusHelper.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/25.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation
import YYCache
import YYImage

class WBStatusHelper {
    
    /// 图片缓存单例
    var imageCache: YYMemoryCache! {
        get{
            struct Static {
                static var cache: YYMemoryCache = YYMemoryCache()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.cache.shouldRemoveAllObjectsOnMemoryWarning = false
                Static.cache.shouldRemoveAllObjectsWhenEnteringBackground = false
                Static.cache.name = "WeiboImageCache"
            }
            return Static.cache
        }
    }
    
    // weibo图片包
    var bundle: NSBundle! {
        get{
            struct Static {
                static var bundle: NSBundle = NSBundle()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                let path: String? = NSBundle.mainBundle().pathForResource("ResourceWeibo", ofType: "bundle")
                Static.bundle = NSBundle(path: path!)!
            }
            return Static.bundle
        }
    }
    
    // weibo表情包
    var emoticonDic: NSDictionary  {
        get{
            struct Static {
                static var dic: NSDictionary = NSDictionary()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                let path: String! = NSBundle.mainBundle().pathForResource("EmoticonWeibo", ofType: "bundle")
                Static.dic = self.emotionDicFromPath(path)
            }
            return Static.dic
        }
    }
    
    // 表情
    func emotionDicFromPath(path: String) -> [String: String] {
        let jsonPath: NSString! = (path as NSString).stringByAppendingPathComponent("info.json")
        let json: NSData? = NSData(contentsOfFile: jsonPath as String)
        var group: WBEmoticonGroup?
        var dic: [String : String] = [:]
        if json?.length > 0 {
            group = WBEmoticonGroup(data: json!)
        }
        if group == nil {
            let plistPath = (path as NSString).stringByAppendingPathComponent("info.plist")
            let plist: NSDictionary? = NSDictionary(contentsOfFile: plistPath)
            if plist?.count > 0 {
                group = WBEmoticonGroup(data: NSKeyedArchiver.archivedDataWithRootObject(plist!))
            }
        }
        if group?.emoticons != nil {
            for emotion: WBEmoticon in (group?.emoticons)! {
                if emotion.png?.length == 0 { continue }
                let pngPath: String = (path as NSString).stringByAppendingPathComponent(emotion.png!)
                if emotion.chs?.length > 0 { dic = [emotion.chs! : pngPath] }
                if emotion.cht?.length > 0 { dic = [emotion.cht! : pngPath] }
            }
            let folders: [String] = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
            for folder: String in folders {
                if folder.length == 0 { continue }
                let subDic: [String : String]? = self.emotionDicFromPath((path as NSString).stringByAppendingPathComponent(folder))
                if subDic != nil {
                    dic.addEntriesFromDictionary(subDic!)
                }
            }
        }

        return dic
    }
    
    // at正则匹配单例
    var regexAt: NSRegularExpression! {
        get {
            struct Static {
                static var regex: NSRegularExpression = NSRegularExpression()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.regex = try! NSRegularExpression(pattern: "@[-_a-zA-Z0-9\\u4E00-\\u9FA5]+", options: [])
            }
            return Static.regex
        }
    }
    
    // 表情正则匹配
    var regexEmotion: NSRegularExpression! {
        get {
            struct Static {
                static var regex: NSRegularExpression = NSRegularExpression()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.regex = try! NSRegularExpression(pattern: "\\[[^ \\[\\]]+?\\]", options: [])
            }
            return Static.regex
        }
    }
    
    ///  URL转换
    func defaultURLForImageURLStr(imageURL: String?) -> NSURL? {
        /*
        微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
        http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
        http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
        
        http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
        http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
        */
        
        if imageURL == nil || imageURL!.characters.count == 0 {return nil}
        var link = imageURL!
        
        if link.hasSuffix(".png") == true {
            // add "_default"
            if link.hasSuffix("_default.png") == false {
                let sub = link.substringToIndex(link.startIndex.advancedBy(link.characters.count - 4))
                link = sub.stringByAppendingString("_default.png")
            }
        } else {
            // replace "_y.png" with "_os7.png"
            if link.rangeOfString("_y.png?version") != nil{
                let mutable = link
                link = mutable.stringByReplacingOccurrencesOfString("_y.png?version",withString:"os7.png?version")
            }
        }
        return NSURL(string: link)
    }
    
    /// 图片名字取图片(已使用缓存)
    func imageNamed(name: String?) -> UIImage? {
        let nsName: NSString? = name! as NSString
        if nsName == nil || nsName?.length == 0 { return nil }
        var image: UIImage? = self.imageCache.objectForKey(name) as? UIImage
        if image != nil {return image}
        var ext = nsName?.pathExtension
        if ext?.characters.count == 0 { ext = "png" }
        let path: String? = self.bundle.pathForScaledResource(name!, ofType: ext!)
        if path == nil {return nil}
        image = UIImage(contentsOfFile: path!)
        image = image?.yy_imageByDecoded()
        if image == nil {return nil}
        self.imageCache.setObject(image, forKey: name)
        return image
    }
    
    /// 图片地址取图片(已使用缓存)
    func imageWithPath(path: NSString?) -> UIImage? {
        if path == nil { return nil }
        var image: UIImage? = self.imageCache.objectForKey(path) as? UIImage
        if image != nil { return image }
        if path?.pathScale == 1 {
            let scales: [Int] = NSBundle().preferredScales
            for scale: Int in scales {
                image = UIImage(contentsOfFile: (path as! String).stringByAppendingPathScale(scale))
                if image != nil { break }
            }
        } else {
            image = UIImage(contentsOfFile: path as! String)
        }
        if image != nil {
            image = image?.yy_imageByDecoded()
            self.imageCache.setObject(image, forKey: path)
        }
        return image
    }
    
    /// 数字转换
    func shortedNumberDesc(number: Int) -> String {
        if number <= 9999 { return "\(number)" }
        if number <= 9999999 { return "\(number / 10000)万" }
        return "\(number / 10000000)千万"
    }
    
    /// 时间的格式转换
    func stringWithTimeLineDate(date: NSDate?) -> String {
        if date == nil { return "" }
        
        struct Static {
            static var formatterYesterday: NSDateFormatter = NSDateFormatter()
            static var formatterSameYear: NSDateFormatter = NSDateFormatter()
            static var formatterFullDate: NSDateFormatter = NSDateFormatter()
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.formatterYesterday.dateFormat = "昨天 HH:mm"
            Static.formatterYesterday.locale = NSLocale.currentLocale()
            
            Static.formatterSameYear.dateFormat = "M-d"
            Static.formatterSameYear.locale = NSLocale.currentLocale()
            
            Static.formatterFullDate.dateFormat = "yy-M-dd"
            Static.formatterFullDate.locale = NSLocale.currentLocale()
        }
        
        let now = NSDate()
        let delta: NSTimeInterval = now.timeIntervalSince1970 - date!.timeIntervalSince1970
        
        if delta < -60 * 10 {       // 时间出错了
            return Static.formatterFullDate.stringFromDate(date!)
        } else if delta < 60 * 10 {     // 10分钟内
            return "刚刚"
        } else if delta < 60 * 60 {     // 1小时内
            return "\(Int(delta / 60.0))分钟前"
        } else if date?.isToday() == true {
            return "\(Int(delta / 60.0 / 60.0))小时前"
        } else if date?.isYesterday() == true {
            return Static.formatterYesterday.stringFromDate(date!)
        } else if date?.year == now.year {
            return Static.formatterSameYear.stringFromDate(date!)
        } else {
            return Static.formatterFullDate.stringFromDate(date!)
        }
    }
}