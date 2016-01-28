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

// 卡片类型
enum WBStatusCardType {
    case WBStatusCardTypeNone
    case WBStatusCardTypeNormal
    case WBStatusCardTypeVideo
}

// 标签类型
enum WBStatusTagType {
    case WBStatusTagTypeNone
    case WBStatusTagTypeNormal
    case WBStatusTagTypePlace
}



/// 微博布局计算
class WBStatusLayout {
    // 高度
    let kWBCellTitleHeight: CGFloat = 36     // 标题高度
    let kWBCellProfileHeight: CGFloat = 56   // 名片高度
    let kWBCellToolbarHeight: CGFloat = 35   // 工具栏高度
    
    
    // 宽度
    let kWBCellNameWidth: CGFloat = kScreenWidth() - 110    // 名字最大宽度
    let kWBCellPadding: CGFloat! = 12                       // cell内边框
    let kWBCellPaddingText: CGFloat = 10                    // 文本与其他元素的留白 e.g. "xxx 🐰 xxx"
    let kWBCellContentWidth: CGFloat                        // 内容宽度 kScreenWidth() - 2 * kWBCellPadding ---> | |xxxxxxxxx| |
    let kWBCellPaddingPic: CGFloat = 4                      // 多图间的留白
    
    // 字体
    let kWBCellNameFontSize: CGFloat = 14        // 名字字体大小
    let kWBCellTitlebarFontSize: CGFloat = 14    // 标题栏字体大小
    let kWBCellSourceFontSize: CGFloat = 12      // 来源字体大小
    let kWBCellTextFontRetweetSize: CGFloat = 16 // 转发字体大小
    let kWBCellCardTitleFontSize: CGFloat = 10   // 卡片标题文本字体大小
    let kWBCellCardDescFontSize: CGFloat = 12    // 卡片描述文本字体大小
    let kWBCellTextFontSize: CGFloat = 17        // 正文文本字体大小
    let kWBCellToolbarFontSize: CGFloat = 14     // 工具栏字体大小
    
    // 颜色
    let kWBCellNameOrangeColor: UIColor! = UIColor(hexString: "f26220")      // 橙色颜色
    let kWBCellToolbarTitleColor: UIColor! = UIColor(hexString:"929292")     // 工具栏文本色
    let kWBCellNameNormalColor: UIColor! = UIColor(hexString: "333333")      // 名字颜色
    let kWBCellTimeNormalColor: UIColor! = UIColor(hexString: "828282")      // 时间颜色
    let kWBCellTextHighlightColor: UIColor! = UIColor(hexString: "527ead")   // 链接颜色
    let kWBCellTextSubTitleColor: UIColor! = UIColor(hexString: "5d5d5d")    // 次要文本色(转发)
    let kWBCellTextNormalColor: UIColor! = UIColor(hexString: "333333")      // 一般文本色
    
    // 固定字符
    let kWBLinkHrefName: String! = "href"
    let kWBLinkURLName: String! = "url"
    let kWBLinkAtName: String! = "at"
    let kWBLinkTagName: String! = "tag"
    
    //-------------------------------------------------------------------------------------------

    // 数据
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
    var retweetTextHeight: CGFloat = 0
    var retweetTextLayout: YYTextLayout?
    var retweetPicHeight: CGFloat = 0
    var retweetPicSize: CGSize?
    // 转发中的卡片
    var retweetCardHeight: CGFloat = 0  // 转发中的卡片高度
    var retweetCardTextLayout: YYTextLayout?
    var retweetCardType: WBStatusCardType = .WBStatusCardTypeNone
    var retweetCardText: YYTextLayout?
    var retweetCardTextRect: CGRect?
    
    // 卡片
    var cardHeight: CGFloat = 0  // 卡片高度
    var cardType: WBStatusCardType = .WBStatusCardTypeNone
    var cardTextLayout: YYTextLayout?
    var cardTextRect: CGRect?
    
    // 标签
    var tagHeight: CGFloat = 0  // 标签高度
    var tagType: WBStatusTagType = .WBStatusTagTypeNone
    var tagTextLayout: YYTextLayout?
    
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
        self.kWBCellContentWidth = kScreenWidth() - 2 * kWBCellPadding
        if status.user == nil {return nil}
        // 进行布局计算
        self.layout()
    }
    
    func layout() {
        // 布局计算
        self.layoutTitle()
        self.layoutProfile()
        self.layoutRetweet()
        if self.retweetHeight == 0 {
            if self.picHeight == 0 {
                self.layoutCard()
            }
        }
        
        self.layoutText()
        self.layoutTag()
        self.layoutToolBar()
        
        // 高度计算
        self.height = 0
        self.height += self.marginTop
        self.height += self.titleHeight
        self.height += self.profileHeight
        self.height += self.textHeight
        if self.retweetHeight > 0 {
            self.height += self.retweetHeight
        } else if (self.picHeight > 0) {
            self.height += self.picHeight
        } else if (self.cardHeight > 0) {
            self.height += self.cardHeight
        }
        if self.tagHeight > 0 {
            self.height += self.tagHeight
        } else {
            if self.picHeight > 0 || self.cardHeight > 0 {
                self.height += kWBCellPadding
            }
        }
        self.height += self.toolbarHeight
        self.height += self.marginBottom
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
    
    /// 微博正文
    func layoutText() {
        self.textHeight = 0
        self.textLayout = nil
        
        let text: NSMutableAttributedString? = self.textWithStatus(self.status, isRetweet: false, fontSize: kWBCellTextFontSize, textColor: kWBCellTextNormalColor)
        
        if text == nil || text?.length == 0 { return }
        
        let modifier: WBTextLinePositionModifier! = WBTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: kWBCellTextFontSize)
        modifier.paddingTop = Float(kWBCellPaddingText)
        modifier.paddingBottm = Float(kWBCellPaddingText)
        
        let container: YYTextContainer! = YYTextContainer()
        container.size = CGSizeMake(kWBCellContentWidth,CGFloat(HUGE))
        container.linePositionModifier = modifier
        
        self.textLayout = YYTextLayout(container: container, text: text)
        if self.textLayout == nil { return }
        
        self.textHeight = CGFloat(modifier.heightForLineCount(Int((self.textLayout?.rowCount)!))!)
    }
    
    /// 微博标签
    func layoutTag() {
        self.tagType = .WBStatusTagTypeNone
        self.tagHeight = 0
        
        let tag:WBTag? = self.status.tagStruct.first
        if tag == nil || tag!.tagName?.length == 0 { return }
        
        let text: NSMutableAttributedString = NSMutableAttributedString(string: tag!.tagName!)
        
        if tag!.tagType == 1{
            self.tagType = .WBStatusTagTypePlace
            self.tagHeight = 40
            text.yy_color = UIColor(white: 0.217, alpha: 1.000)
        } else {
            self.tagType = .WBStatusTagTypeNormal
            self.tagHeight = 32
            if tag!.urlTypePic != nil {
                let pic: NSAttributedString = self.attachment(kWBCellCardDescFontSize, imageURL: tag!.urlTypePic!.absoluteString, shrink: true)
                text.insertAttributedString(pic, atIndex: 0)
            }
            
            // 高亮状态背景
            let highlightBorder: YYTextBorder = YYTextBorder()
            highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
            highlightBorder.cornerRadius = 2
            highlightBorder.fillColor = kWBCellTextHighlightColor
            text.yy_setColor(kWBCellTextHighlightColor, range: NSMakeRange(0, text.length))
            
            // 高亮状态
            let highlight: YYTextHighlight = YYTextHighlight()
            highlight.setBackgroundBorder(highlightBorder)
            
            // 数据信息
            highlight.userInfo = [kWBLinkTagName : tag!]
            text.yy_setTextHighlight(highlight, range: NSMakeRange(0, text.length))
        }
        
        text.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
        
        let container: YYTextContainer! = YYTextContainer(size: CGSizeMake(9999, 9999))
        self.tagTextLayout = YYTextLayout(container: container, text: text)
        if self.tagTextLayout == nil {
            self.tagType = .WBStatusTagTypeNone
            self.tagHeight = 0
        }
    }
    
    /// 微博工具栏 
    func layoutToolBar() {
        let font: UIFont! = UIFont.systemFontOfSize(kWBCellToolbarFontSize)
        let container: YYTextContainer = YYTextContainer(size: CGSizeMake(kScreenWidth(), kWBCellToolbarHeight))
        container.maximumNumberOfRows = 1
        
        let repostText: NSMutableAttributedString = NSMutableAttributedString(string: self.status.repostsCount <= 0 ? "转发" : WBStatusHelper().shortedNumberDesc(Int(self.status.repostsCount)))
        repostText.yy_font = font
        repostText.yy_color = kWBCellToolbarTitleColor
        self.toolbarRepostTextLayout = YYTextLayout(container: container, text: repostText)
        self.toolbarRepostTextWidth = CGFloatPixelRound(self.toolbarRepostTextLayout!.textBoundingRect.size.width)
        
        let commentText: NSMutableAttributedString = NSMutableAttributedString(string: self.status.commentsCount <= 0 ? "评论" : WBStatusHelper().shortedNumberDesc(Int(self.status.commentsCount)))
        commentText.yy_font = font
        commentText.yy_color = kWBCellToolbarTitleColor
        self.toolbarCommentTextLayout = YYTextLayout(container: container, text: commentText)
        self.toolbarCommentTextWidth = CGFloatPixelRound(self.toolbarCommentTextLayout!.textBoundingRect.size.width)
        
        let likeText: NSMutableAttributedString = NSMutableAttributedString(string: self.status.attitudesCount <= 0 ? "赞" : WBStatusHelper().shortedNumberDesc(Int(self.status.attitudesCount)))
        likeText.yy_font = font
        likeText.yy_color = kWBCellToolbarTitleColor
        self.toolbarLikeTextLayout = YYTextLayout(container: container, text: likeText)
        self.toolbarLikeTextWidth = CGFloatPixelRound(self.toolbarLikeTextLayout!.textBoundingRect.size.width)
    }

    /// 转发微博
    func layoutRetweet() {
        self.retweetHeight = 0
        self.layoutRetweetedText()
        self.layoutRetweetPics()
        
        if self.retweetPicHeight == 0 {
            self.layoutRetweetCard()
        }
        
        self.retweetHeight = self.retweetTextHeight
        if self.retweetPicHeight > 0 {  // 两者只能存在一个
            self.retweetHeight += self.retweetHeight
            self.retweetHeight += kWBCellPadding // padding
        } else if self.retweetCardHeight > 0 {
            self.retweetHeight += self.retweetCardHeight
            self.retweetHeight += kWBCellPadding // padding
        }
    }
    
    /// 转发微博中正文
    func layoutRetweetedText() {
        self.retweetHeight = 0
        self.retweetTextLayout = nil
        let text: NSMutableAttributedString? = self.textWithStatus(self.status.retweetedStatus, isRetweet: true, fontSize: kWBCellTextFontRetweetSize, textColor: kWBCellTextSubTitleColor)
        
        if text == nil || text!.length == 0 { return }
        
        let modifier: WBTextLinePositionModifier! = WBTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: kWBCellTextFontRetweetSize)
        modifier.paddingTop = Float(kWBCellPaddingText)
        modifier.paddingBottm = Float(kWBCellPaddingText)
        
        let container: YYTextContainer = YYTextContainer()
        container.size = CGSizeMake(kWBCellContentWidth, CGFloat(HUGE))
        container.linePositionModifier = modifier
        
        self.retweetTextLayout = YYTextLayout(container: container, text: text)
        if self.retweetTextLayout == nil { return }
        self.retweetTextHeight = CGFloat(modifier.heightForLineCount(self.retweetTextLayout?.lines.count)!)
    }
    
    /// 微博卡片
    func layoutCard() {
        self.layoutCardWithStatus(self.status, isRetweet: false)
    }
    
    /// 转发微博卡片
    func layoutRetweetCard() {
        self.layoutCardWithStatus(self.status.retweetedStatus, isRetweet: true)
    }
    
    /// 根据微博中的卡片进行转化
    func layoutCardWithStatus(status: WBStatus?, isRetweet: Bool) {
        if status == nil { return }
        if isRetweet == true {
            self.retweetCardType = WBStatusCardType.WBStatusCardTypeNone
            self.retweetCardHeight = 0
            self.retweetCardTextLayout = nil
            self.retweetCardTextRect = CGRectZero
        } else {
            self.cardType = WBStatusCardType.WBStatusCardTypeNone
            self.cardHeight = 0
            self.cardTextLayout = nil
            self.cardTextRect = CGRectZero
        }
        
        let pageInfo: WBPageInfo? = status!.pageInfo
        if pageInfo == nil { return }
        
        var cardType: WBStatusCardType! = WBStatusCardType.WBStatusCardTypeNone
        var cardHeight: CGFloat! = 0
        var cardTextLayout: YYTextLayout?
        var textRect: CGRect! = CGRectZero
        
        if pageInfo!.type == 11 && pageInfo!.objectType == "video" {    // 视频卡片 
            if pageInfo!.pagePic != nil {
                cardType = WBStatusCardType.WBStatusCardTypeVideo
                cardHeight = (2 * kWBCellContentWidth - kWBCellPaddingPic) / 3
            }
        } else {
            let hasImage: Bool! = (pageInfo!.pagePic != nil)    // 左侧图
            let hasBadge: Bool! = (pageInfo!.typeIcon != nil)   // 图的类型图标
            let button:WBButtonLink? = pageInfo!.buttons?.first
            let hasButton: Bool! = button?.pic != nil && button?.name != nil
            
            /*
            卡片数据
            badge(一般为左上角小图标)   : 25 * 25
            image(一般为左方图片)      : 方形（70 * 70); 矩形(100 * 70)
            btn(一般为右侧按钮)        : 60 * 70
            lineHeight(文字高度)      : 20
            padding(控件间距)         : 10
            */
            
            textRect.size.height = 70
            if hasImage == true {
                if hasBadge == true {
                    textRect.origin.x = 100
                } else {
                    textRect.origin.x = 70
                }
            } else {
                if hasBadge == true {
                    textRect.origin.x = 42
                }
            }
            
            textRect.origin.x += 10 // padding
            textRect.size.width = kWBCellContentWidth - textRect.origin.x
            if hasButton == true { textRect.size.width -= 60 }
            textRect.size.width -= 10 // padding
            
            /*  一般卡片样式(badge在image的左上角)
            ----------------------------
            |        pageTitle         |
            | image  pageDesc   btns   |
            |        tips              |
            ----------------------------
            */
            
            let text: NSMutableAttributedString = NSMutableAttributedString()

            if pageInfo!.pageTitle.length > 0 {         // 标题
                let title: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!.pageTitle)
                title.yy_font = UIFont.systemFontOfSize(kWBCellCardTitleFontSize)
                title.yy_color = kWBCellNameNormalColor
                text.appendAttributedString(title)
            }
            
            if pageInfo!.pageDesc?.length > 0 {          // 卡片描述
                if text.length > 0 { text.yy_appendString("\n") }
                let desc: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!
                    .pageDesc!)
                desc.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
                desc.yy_color = kWBCellNameNormalColor
                text.appendAttributedString(desc)
            } else if pageInfo!.content2?.length > 0 {
                if text.length > 0 { text.yy_appendString("\n") }
                let desc: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!.pageDesc!)
                desc.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
                desc.yy_color = kWBCellNameNormalColor
                text.appendAttributedString(desc)
            } else if pageInfo!.content3?.length > 0 {
                if text.length > 0 { text.yy_appendString("\n") }
                let desc: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!.pageDesc!)
                desc.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
                desc.yy_color = kWBCellNameNormalColor
                text.appendAttributedString(desc)
            } else if pageInfo!.content4?.length > 0 {
                if text.length > 0 { text.yy_appendString("\n") }
                let desc: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!.pageDesc!)
                desc.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
                desc.yy_color = kWBCellNameNormalColor
                text.appendAttributedString(desc)
            }
            
            if pageInfo!.tips?.length > 0 {         // 卡片提示
                if text.length > 0 { text.yy_appendString("\n") }
                let tips: NSMutableAttributedString = NSMutableAttributedString(string: pageInfo!.tips!)
                tips.yy_font = UIFont.systemFontOfSize(kWBCellCardDescFontSize)
                tips.yy_color = kWBCellTextSubTitleColor
                text.appendAttributedString(tips)
            }
            
            if text.length > 0 {
                text.yy_maximumLineHeight = 20
                text.yy_minimumLineHeight = 20
                text.yy_lineBreakMode = .ByTruncatingTail   //  ---->  xxx...
                
                let container: YYTextContainer = YYTextContainer(size: textRect.size)
                container.maximumNumberOfRows = 3   // 最大为一般样式的三行
                cardTextLayout = YYTextLayout(container: container, text: text)
            }
            
            if cardTextLayout != nil {
                cardType = .WBStatusCardTypeNormal
                cardHeight = 70     // 最高为图片的高度
            }
        }
        
        if isRetweet == true {
            self.retweetCardType = cardType
            self.retweetCardHeight = cardHeight
            self.retweetCardTextLayout = cardTextLayout
            self.retweetCardTextRect = textRect
        } else {
            self.cardType = cardType
            self.cardHeight = cardHeight
            self.cardTextLayout = cardTextLayout
            self.cardTextRect = textRect
        }
    }
    
    /// 微博图片
    func layoutPics() {
        self.layoutPicsWithStauts(self.status, isRetweet: false)
    }
    
    /// 转发微博图片
    func layoutRetweetPics() {
        self.layoutPicsWithStauts(self.status.retweetedStatus, isRetweet: true)
    }
    
    /// 根据微博中图片进行转化
    func layoutPicsWithStauts(status: WBStatus?, isRetweet: Bool) {
        if status == nil { return }
        if isRetweet == true {
            self.retweetPicSize = CGSizeZero
            self.retweetPicHeight = 0
        } else {
            self.picSize = CGSizeZero
            self.picHeight = 0
        }
        if status?.pics.count == 0 { return }
        
        var picSize: CGSize = CGSizeZero
        var picHeight: CGFloat = 0
        
        var len1_3: CGFloat = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic     // 有大于1张图片的时候图片的宽度
        len1_3 = CGFloatPixelRound(len1_3)
        
        switch (status!.pics.count) {
        case 1:
            let pic: WBPicture! = status?.pics.first
            let bmiddle: WBPictureMetadata = pic.bmiddle
            if pic.keepSize == true || bmiddle.width < 1 || bmiddle.height < 1 {            // 单图 为正方形的时候
                var maxLen: CGFloat = kWBCellContentWidth / 2.0
                maxLen = CGFloatPixelRound(maxLen)
                picSize = CGSizeMake(maxLen, maxLen)
                picHeight = maxLen
            } else {
                let maxlen: CGFloat = len1_3 * 2 + kWBCellPaddingPic
                if bmiddle.width < bmiddle.height {
                    picSize.width = CGFloat(bmiddle.width) / CGFloat(bmiddle.height) * maxlen
                    picSize.height = maxlen
                } else {
                    picSize.width = maxlen
                    picSize.height = CGFloat(bmiddle.height) / CGFloat(bmiddle.width) * maxlen
                }
                picSize = CGSizePixelRound(picSize)
                picHeight = picSize.height
            }
            break
        case 2,3:
            picSize = CGSizeMake(len1_3, len1_3)
            picHeight = len1_3
            break
        case 4,5,6:
            picSize = CGSizeMake(len1_3, len1_3)
            picHeight = len1_3 * 2 + kWBCellPaddingPic
            break
        default:    // 7,8,9
            picSize = CGSizeMake(len1_3, len1_3)
            picHeight = len1_3 * 3 + kWBCellPaddingPic
            break
        }
        
        if isRetweet == true {
            self.retweetPicSize = picSize
            self.retweetPicHeight = picHeight
        } else {
            self.picSize = picSize
            self.picHeight = picHeight
        }
    }
    
    /// 根据微博正文进行转化
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
            let imagePath: NSString? = WBStatusHelper().emoticonDic[emoString] as? NSString
            let image: UIImage? = WBStatusHelper().imageWithPath(imagePath)
            if image == nil { continue }
            
            let emoText: NSAttributedString = NSAttributedString.yy_attachmentStringWithEmojiImage(image, fontSize: fontSize)
            
            text.replaceCharactersInRange(range, withAttributedString: emoText)
            emoClipLength += range.length - 1
        }
        return text
    }
    
    /// 文本中的图片转换(根据图片URL)
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
    
    /// 文本中的图片转换(根据图片)
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

// 文本中的图片(需要网络下载)
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

/// 文本的转发(例如字体，上下留白)
class WBTextLinePositionModifier: NSObject, YYTextLinePositionModifier {
    var font: UIFont?
    var paddingTop: Float? = 0
    var paddingBottm: Float? = 0
    var lineHeightMultiple: Float? = 0
    
    override init () {
        let kSystemVersion: Float! = Float(UIDevice.currentDevice().systemVersion)
        if kSystemVersion >= 9 {
            self.lineHeightMultiple = 1.34
        } else {
            self.lineHeightMultiple = 1.3125
        }
    }
    
    func heightForLineCount(lineCount: Int?) -> Float? {
        if lineCount == 0 { return 0 }
        let ascent: CGFloat! = self.font!.pointSize * 0.86
        let decent: CGFloat! = self.font!.pointSize * 0.14
        let lineHeight: CGFloat! = self.font!.pointSize * CGFloat(self.lineHeightMultiple!)
        return self.paddingTop! + self.paddingBottm! + Float(ascent + decent + CGFloat(CGFloat(lineCount! - 1) * lineHeight))
    }
    
    @objc func modifyLines(lines: [AnyObject]!, fromText text: NSAttributedString!, inContainer container: YYTextContainer!) {
        
        let ascent: CGFloat? = self.font?.ascender
        let lineHeight: CGFloat = self.font!.pointSize * CGFloat(self.lineHeightMultiple!)
        
        for line: YYTextLine in lines as! [YYTextLine] {
            var position: CGPoint = line.position
            position.y = CGFloat(self.paddingTop!) + ascent! + CGFloat(line.row) * lineHeight
            line.position = position
        }
    }
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let one: WBTextLinePositionModifier = WBTextLinePositionModifier()
        one.font = self.font
        one.paddingTop = self.paddingTop
        one.paddingBottm = self.paddingBottm
        one.lineHeightMultiple = self.lineHeightMultiple
        return one
    }
}


