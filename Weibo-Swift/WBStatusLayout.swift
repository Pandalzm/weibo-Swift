//
//  WBStatusLayout.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/23.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation
import YYText
import Kingfisher
import YYImage

enum WBStatusCardType {
    case WBStatusCardTypeNone
    case WBStatusCardTypeNormal
    case WBStatusCardTypeVideo
}

class WBStatusStatic {

}

/// 微博布局
class WBStatusLayout {
    // 高度
    let kWBCellTitleHeight: CGFloat = 36     // 标题高度
    let kWBCellProfileHeight: CGFloat = 56   // 名片高度
    
    // 宽度
    let kWBCellNameWidth: CGFloat = kScreenWidth() - 110 // 名字最大宽度
    
    // 字体
    let kWBCellNameFontSize: CGFloat = 14        // 名字字体大小
    let kWBCellTitlebarFontSize: CGFloat = 14    // 标题栏字体大小
    let kWBCellSourceFontSize: CGFloat = 12      // 来源字体大小
    let kWBCellTextFontRetweetSize: CGFloat = 16 // 转发字体大小
    
    // 颜色
    let kWBCellNameOrangeColor: UIColor! = UIColor(hexString: "f26220")      // 橙色颜色
    let kWBCellToolbarTitleColor: UIColor! = UIColor(hexString:"929292")     // 工具栏文本色
    let kWBCellNameNormalColor: UIColor! = UIColor(hexString: "333333")      // 名字颜色
    let kWBCellTimeNormalColor: UIColor! = UIColor(hexString: "828282")      // 时间颜色
    let kWBCellTextHighlightColor: UIColor! = UIColor(hexString: "527ead")   // 链接颜色
    let kWBCellTextSubTitleColor: UIColor! = UIColor(hexString: "5d5d5d")    // 次要文本色(转发)
    
    // 固定字符
    let kWBLinkHrefName: String! = "href"
    let kWBLinkURLName: String! = "url"
    let kWBLinkAtName: String! = "at"
    
    
    //----------------------------------------------------------
    let status: WBStatus
    // 顶部灰色留白
    let marginTop: CGFloat = 8
    
    // 标题栏
    var titleHeight: CGFloat = 0  // 标题栏高度，默认为0，如果为0，则代表这一部分并没有在这条微博中显示，下同
    var titleTextLayout : YYTextLayout?
    
    // 个人资料
    var profileHeight: CGFloat = 0  // 个人资料高度（包括上下留白）
    var nameTextLayout: YYTextLayout!  // 名字
    var sourceTextLayout: YYTextLayout!  //  时间和来源
    
    // 正文文本
    var textHeight: CGFloat = 0  // 正文文本高度 (包括上下留白)
    var textLayout: YYTextLayout?  // 文本
    
    // 图片
    var picHeight: CGFloat = 0  // 图片高度
    var picSize: CGSize?
    
    // 转发
    var retweetHeight: CGFloat = 0  // 转发高度
    var retweetTextHeight: CGFloat = 0  //
    var retweetTextLayout: YYTextLayout?
    var retweetPicHeight: CGFloat = 0
    var retweetPicSize: CGSize?
    var retweetCardHeight: CGFloat = 0  // 转发中的卡片高度
    var retweetCardType: WBStatusCardType = WBStatusCardType.WBStatusCardTypeNone
    var retweetCardText: YYTextLayout?
    var retweetCardTextRect: CGRect?
    
    // 卡片
    var cardHeight: CGFloat = 0  // 卡片高度
    var cardType: WBStatusCardType = WBStatusCardType.WBStatusCardTypeNone
    var cardTextLayout: YYTextLayout?
    var cardTextRect: CGRect?
    
    // 工具栏 －－－>> |  转发  |  评论  |   点赞  ｜
    var toolbarHeight: CGFloat =  35
    var toolbarRepostTextLayout: YYTextLayout?
    var toolbarCommentTextLayout: YYTextLayout?
    var toolbarLikeTextLayout: YYTextLayout?
    var toolbarRepostTextWidth: CGFloat = 0
    var toolbarCommentTextWidth: CGFloat = 0
    var toolbarLikeTextWidth: CGFloat = 0
    
    // 下部留白
    var marginBottom: CGFloat = 2
    
    //  总高度
    var height: CGFloat = 0
    
    init? (status: WBStatus) {
        self.status = status
        if status.user == nil {return nil}
        // 进行布局计算
        self.layout()
    }
    
    func layout() {
        // 布局计算
        self.layoutTitle()
        self.layoutProfile()
        self.layoutRetweet()
    }

    /// 标题布局计算 (例如“热门”“推荐”)
    func layoutTitle() {
        self.titleHeight = 0
        self.titleTextLayout = nil
        
        let title = self.status.title
        if title == nil || title?.text.characters.count == 0 {return}
        
        let text = NSMutableAttributedString(string: (title?.text)!)
        if title?.iconURL != nil {
            let icon: NSAttributedString = self.attachment(kWBCellTitlebarFontSize, imageURL: (title?.iconURL)!, shrink: false)
            text.insertAttributedString(icon, atIndex: 0)
        }
        text.yy_color = kWBCellToolbarTitleColor
        text.yy_font =  UIFont.systemFontOfSize(kWBCellTitlebarFontSize)

        let container = YYTextContainer(size: CGSize(width: kScreenWidth() - 100, height: kWBCellTitleHeight))
        self.titleTextLayout = YYTextLayout(container: container, text: text)
        self.titleHeight = kWBCellTitleHeight
    }
    
    /// 头部布局计算 (包括头像, 名称, 时间等等)
    func layoutProfile() {
        self.layoutName()
        self.layoutSourse()
        self.profileHeight = kWBCellProfileHeight
    }
    
    /// 名字
    func layoutName() {
        let user:WBUser = self.status.user!
        var nameStr: String!
        if user.remark != nil && user.remark!.characters.count > 0 {
            nameStr = user.remark!
        } else {
            nameStr = user.name!
        }
        if nameStr.characters.count == 0 {
            self.nameTextLayout = nil
            return
        }
        
        let nameText: NSMutableAttributedString = NSMutableAttributedString(string: nameStr)
        
        // 蓝V
        if user.userVerifyType == WBUserVerifyType.WBUserVerifyTypeClub {
            let blueVImage: UIImage = WBStatusHelper().imageNamed("avatar_enterprise_vip")!
            let blueVText: NSAttributedString = self.attachment(kWBCellNameFontSize, image: blueVImage, shrink: false)
            nameText.yy_appendString(" ")
            nameText.appendAttributedString(blueVText)
        }
        
        // VIP
        if user.mbrank > 0 {
            var yellowVImage: UIImage? = WBStatusHelper().imageNamed("common_icon_membership_level\(user.mbrank)")
            if yellowVImage == nil {
                yellowVImage = WBStatusHelper().imageNamed("common_icon_membership")
            }
            let vipText: NSAttributedString! = self.attachment(kWBCellNameFontSize, image: yellowVImage!, shrink: false)
            nameText.yy_appendString(" ")
            nameText.appendAttributedString(vipText)
        }
        nameText.yy_font = UIFont.systemFontOfSize(kWBCellNameFontSize)
        nameText.yy_color = user.mbrank > 0 ? kWBCellNameOrangeColor : kWBCellNameNormalColor
        
        let container = YYTextContainer(size: CGSizeMake(kWBCellNameWidth, 9999))
        container.maximumNumberOfRows = 1
        self.nameTextLayout = YYTextLayout(container: container, text: nameText)
    }
    
    /// 来源
    func layoutSourse() {
        let sourceText: NSMutableAttributedString! = NSMutableAttributedString()
        let createTime: String = WBStatusHelper().stringWithTimeLineDate(self.status.createdAt)
        
        // 时间
        if createTime.characters.count != 0{
            let timeText: NSMutableAttributedString = NSMutableAttributedString(string: createTime)
            timeText.yy_appendString("  ")
            timeText.yy_font = UIFont.systemFontOfSize(kWBCellSourceFontSize)
            timeText.yy_color = kWBCellTimeNormalColor
        }
        
        // 来自 XXX
        if self.status.source.characters.count != 0 {
            // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
            struct Static {     //  正则匹配
                static var hrefRegex: NSRegularExpression! = NSRegularExpression()
                static var textRegex: NSRegularExpression! = NSRegularExpression()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken, { () -> Void in
                Static.hrefRegex = try! NSRegularExpression(pattern:"(?<=href=\").+(?=\" )", options: .CaseInsensitive)
                Static.textRegex = try! NSRegularExpression(pattern:"(?<=>).+(?=<)", options: .CaseInsensitive)
            })
            
            var hrefResult: NSTextCheckingResult?
            var textResult: NSTextCheckingResult?
            var href: NSString?
            var text: NSString?
            hrefResult = Static.hrefRegex.firstMatchInString(self.status.source, options:[], range: NSMakeRange(0, self.status.source.characters.count))!
            textResult = Static.hrefRegex.firstMatchInString(self.status.source, options:[], range: NSMakeRange(0, self.status.source.characters.count))!
            if hrefResult != nil && textResult != nil && hrefResult!.range.location != NSNotFound && textResult!.range.location != NSNotFound {
                href = (self.status.source as NSString).substringWithRange(hrefResult!.range)
                text = (self.status.source as NSString).substringWithRange(textResult!.range)
            }
            if href != nil && text != nil && href?.length > 0 && text?.length > 0 {
                let from: NSMutableAttributedString = NSMutableAttributedString()
                from.yy_appendString("来自 \(text)")
                from.yy_font = UIFont.systemFontOfSize(kWBCellSourceFontSize)
                from.yy_color = kWBCellTimeNormalColor
                if self.status.sourceAllowClick > 0 {       // 允许点击,字体为蓝色，而且有点击效果
                    let range: NSRange! = NSMakeRange(3, text!.length)
                    from.yy_setColor(kWBCellTextHighlightColor, range: range)
                    
                    let backed: YYTextBackedString = YYTextBackedString(string: (href as! String))
                    from.yy_setTextBackedString(backed, range: range)
                    
                    let border: YYTextBorder = YYTextBorder()
                    border.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
                    border.fillColor = kWBCellTextHighlightColor
                    border.cornerRadius = 3
                    
                    let highlight: YYTextHighlight = YYTextHighlight()
                    highlight.userInfo = [kWBLinkHrefName : href!]
                    highlight.setBackgroundBorder(border)
                    from.yy_setTextHighlight(highlight, range: range)
                }
                sourceText.appendAttributedString(from)
            }
        }
        
        if sourceText.length == 0 {
            self.sourceTextLayout = nil
        } else {
            let container = YYTextContainer(size: CGSizeMake(kWBCellNameWidth, 9999))
            container.maximumNumberOfRows = 1
            self.sourceTextLayout = YYTextLayout(container: container, text: sourceText)
        }
    }
    
    /// 转发微博
    func layoutRetweet() {
        self.retweetHeight = 0
        self.layoutRetweetedText()
        self.layoutRetweetPics()
        
    }
    
    /// 转发微博正文
    func layoutRetweetedText() {
        self.retweetHeight = 0
        self.retweetTextLayout = nil
        let text: NSMutableAttributedString? = self.textWithStatus(self.status.retweetedStatus, isRetweet: true, fontSize: kWBCellTextFontRetweetSize, textColor: kWBCellTextSubTitleColor)
        
    
    }
    
    /// 转发微博图片
    func layoutRetweetPics() {
        
    
    }
    
    // 根据微博正文进行转化
    func textWithStatus(status:WBStatus?, isRetweet: Bool, fontSize: CGFloat, textColor: UIColor) -> NSMutableAttributedString? {
        if status == nil { return nil }
        var string: String! = status!.text
        if string.characters.count == 0 { return nil }
        if isRetweet == true {
            var name: String! = status!.user?.name
            if name != nil && name!.characters.count == 0 {
                name = status!.user?.screenName
            }
            if name != nil {
                string = "@\(name):\(string)"
            }
        }
        
        let font: UIFont = UIFont.systemFontOfSize(fontSize)
        
        let highlightBorder: YYTextBorder = YYTextBorder()  // 高亮状态的背景
        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
        highlightBorder.cornerRadius = 3
        highlightBorder.fillColor = kWBCellTextHighlightColor
        
        let text: NSMutableAttributedString = NSMutableAttributedString(string: string)
        text.yy_font = font
        text.yy_color = textColor
        
        // 根据URL匹配正文
        for wburl: WBURL in self.status.urlStruct {
            if wburl.shortURL.characters.count == 0 { continue }
            if wburl.urlTitle.characters.count == 0 { continue }
            
            var urlTitle: NSString = wburl.urlTitle
            if urlTitle.length > 27 {   // 如果url的标题大于27 ,则截取
                urlTitle = urlTitle.substringToIndex(27).stringByAppendingString(YYTextTruncationToken)
            }
            
            var searchRange: NSRange = NSMakeRange(0, text.string.characters.count)
            repeat {
                let range: NSRange = (text.string as NSString).rangeOfString(wburl.shortURL, options: [], range: searchRange)
                if range.location == NSNotFound { break }
                
                if range.location + range.length == text.length {   // 如果URL在结尾
                    if self.status.pageInfo?.pageID.length > 0 && wburl.pageID.length > 0 &&
                        self.status.pageInfo?.pageID == wburl.pageID {
                            
                            if (isRetweet == false && status?.retweetedStatus == nil) || isRetweet == true {
                                if status?.pics.count == 0{
                                    text.replaceCharactersInRange(range, withString: "")    // 卡片显示
                                    break
                                }
                            }
                    }
                }
                
                if text.yy_attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location)) == nil {
                    
                    // 替换字符 例如"查看图片" ----> "🐰查看图片" 这个"🐰"图片，需要在网络获取
                    let replace : NSMutableAttributedString = NSMutableAttributedString(string: (urlTitle as String))
                    
                    if wburl.urlTypeURL.characters.count > 0 {
                        let picURL: NSURL = WBStatusHelper().defaultURLForImageURLStr(wburl.urlTypeURL)!
                        var imageView: UIImageView? = UIImageView()
                        imageView!.kf_setImageWithURL(picURL)
                        let pic: NSAttributedString = (imageView!.image != nil && wburl.pics.count > 0) ? self.attachment(fontSize, image: imageView!.image!, shrink: true) : self.attachment(fontSize, imageURL: wburl.urlTypeURL, shrink: true)
                        replace.insertAttributedString(pic, atIndex: 0)
                        imageView = nil
                    }
                    replace.yy_font = font
                    replace.yy_color = kWBCellTextHighlightColor
                    
                    // 高亮
                    let highlight: YYTextHighlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    // 数据信息
                    highlight.userInfo = [kWBLinkURLName : wburl]
                    replace.yy_setTextHighlight(highlight, range: NSMakeRange(0, replace.length))
                    
                    // 替换原始字符串
                    let backed: YYTextBackedString = YYTextBackedString(string: (text.string as NSString).substringWithRange(range))
                    replace.yy_setTextBackedString(backed, range: NSMakeRange(0, replace.length))
                    
                    // 最后进行替换
                    text.replaceCharactersInRange(range, withAttributedString: replace)
                    
                    searchRange.location = searchRange.location + (replace.length > 0 ? replace.length : 1)
                    if searchRange.location + 1 >= text.length { break }
                    searchRange.length = text.length - searchRange.location
                } else {
                    searchRange.location = searchRange.location + (searchRange.length > 0 ? searchRange.length : 0)
                    if searchRange.location + 1 >= text.length { break }
                    searchRange.length = text.length - searchRange.location
                }
            } while(true)
        }
        
        /// 匹配话题
        for topic: WBTopic in self.status.topicStruct {
            if topic.topiceTitle.length == 0 { continue }
            let topicTitle: String! = "#\(topic.topiceTitle)#"       // 两边添加#号  "XXX" -> "#XXX#"
            var searchRange: NSRange = NSMakeRange(0, text.string.length)
            repeat {
                let range: NSRange = (text.string as NSString).rangeOfString(topicTitle, options: [], range: searchRange)
                if range.location == NSNotFound { break }
                
                if text.yy_attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location)) == nil {
                    text.yy_setColor(kWBCellTextHighlightColor, range: range)
                    
                    // 高亮
                    let highlight: YYTextHighlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    // 数据信息
                    highlight.userInfo = [kWBLinkURLName : topic]
                    text.yy_setTextHighlight(highlight, range:range)
                }
                
                searchRange.location = searchRange.location + (searchRange.length > 0 ? searchRange.length : 1)
                if searchRange.location + 1 >= text.length { break }
                searchRange.length = text.length - searchRange.location
            } while (true)
        }

        /// 匹配用户名 ---> @XXX
        let atRestults = WBStatusHelper().regexAt.matchesInString(text.string, options: [], range: NSMakeRange(0, text.length))
        
        for at: NSTextCheckingResult in atRestults {
            if at.range.location == NSNotFound && at.range.length <= 1 { continue }
            if text.yy_attribute(YYTextHighlightAttributeName, atIndex:UInt(at.range.location)) == nil {
                text.yy_setColor(kWBCellTextHighlightColor, range: at.range)
                
                // 高亮
                let highlight: YYTextHighlight = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                // 数据
                highlight.userInfo = [kWBLinkAtName: (text.string as NSString).substringWithRange(NSMakeRange(at.range.location + 1, at.range.length - 1))]
                text.yy_setTextHighlight(highlight, range: at.range)
            }
        }
        
        /// 匹配表情 [🐰]
        
        let emotionResults = WBStatusHelper().regexEmotion.matchesInString(text.string, options: [], range: NSMakeRange(0, text.length))
        var emoClipLength: Int = 0
        for emo: NSTextCheckingResult in emotionResults {
            if emo.range.location == NSNotFound && emo.range.length <= 1 { continue }
            var range: NSRange = emo.range
            range.location -= emoClipLength
            if text.yy_attribute(YYTextHighlightAttributeName, atIndex:UInt(range.location)) != nil { continue }
            if text.yy_attribute(YYTextAttachmentAttributeName, atIndex: UInt(range.location)) != nil { continue }
            
            let emoString: NSString = (text.string as NSString).substringWithRange(range)
            print(emoString)
            let imagePath: NSString = WBStatusHelper().emoticonDic[emoString] as! NSString
            
            
        
        
        }
        
        
        
        
        return text
    }
    
    
    
    
    
    
    
    func attachment(fontSize: CGFloat, imageURL: String, shrink: Bool) -> NSAttributedString {
        let ascent = fontSize * 0.86
        let descent = fontSize * 0.14
        let bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize)
        var contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0)
        var size = CGSizeMake(fontSize, fontSize)
        
        if shrink {
            let scale: CGFloat = 1 / 10.0
            contentInsets.top += fontSize * scale
            contentInsets.bottom += fontSize * scale
            contentInsets.left += fontSize * scale
            contentInsets.right += fontSize * scale
            contentInsets = UIEdgeInsetPixelFloor(contentInsets)
            size = CGSizeMake(fontSize - fontSize * scale * 2, fontSize - fontSize * scale * 2)
            size = CGSizePixelRound(size)
        }
        let delegate = YYTextRunDelegate()
        delegate.ascent = ascent
        delegate.descent = descent
        delegate.width = bounding.size.width
        
        let attachment = WBTextImageViewAttachment()
        attachment.contentMode = UIViewContentMode.ScaleAspectFit
        attachment.contentInsets = contentInsets
        attachment.size = size
        attachment.imageURL = WBStatusHelper().defaultURLForImageURLStr(imageURL)
        
        let art = NSMutableAttributedString(string: YYTextAttachmentToken)
        art.yy_setTextAttachment(attachment, range: NSMakeRange(0, art.length))
        var ctDelegate = delegate.CTRunDelegate()
        art.yy_setRunDelegate(ctDelegate, range: NSMakeRange(0, art.length))
        if ctDelegate != nil {ctDelegate = nil}

        return art
    }
    
    func attachment(fontSize: CGFloat, image: UIImage, shrink: Bool) -> NSAttributedString {
        let ascent = fontSize * 0.86
        let descent = fontSize * 0.14
        let bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize)
        var contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0)
        
        let delegate = YYTextRunDelegate()
        delegate.ascent = ascent
        delegate.descent = descent
        delegate.width = bounding.size.width
        
        let attachment = WBTextImageViewAttachment()
        attachment.contentMode = UIViewContentMode.ScaleAspectFit
        attachment.content = image
        
        if shrink {
            let scale: CGFloat = 1 / 10.0
            contentInsets.top += fontSize * scale
            contentInsets.bottom += fontSize * scale
            contentInsets.left += fontSize * scale
            contentInsets.right += fontSize * scale
            contentInsets = UIEdgeInsetPixelFloor(contentInsets)
            attachment.contentInsets = contentInsets
        }

        let art = NSMutableAttributedString(string: YYTextAttachmentToken)
        art.yy_setTextAttachment(attachment, range: NSMakeRange(0, art.length))
        var ctDelegate = delegate.CTRunDelegate()
        art.yy_setRunDelegate(ctDelegate, range: NSMakeRange(0, art.length))
        if ctDelegate != nil {ctDelegate = nil}
        return art
    }
}


class WBTextImageViewAttachment: YYTextAttachment {
    var size: CGSize?
    var imageURL: NSURL?
    private var imageView: AnyObject?
    
    override var content: AnyObject! {
        get {
            // 非主线程返回
            if pthread_main_np() == 0 {return nil}
            if self.imageView != nil {return self.imageView}
            
            // 完成文本渲染后，进行图片初始化和下载
            let cImageView = UIImageView()
            cImageView.size = self.size!
            cImageView.kf_setImageWithURL(self.imageURL!, placeholderImage: nil)
            self.imageView = cImageView
            return self.imageView
        }
        set(content) {
            self.imageView = UIImageView()
            self.imageView = content
        }
    
    }
}

