//
//  WBStatusLayout.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/23.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation
import YYText

enum WBStatusCardType {
    case WBStatusCardTypeNone
    case WBStatusCardTypeNormal
    case WBStatusCardTypeVideo
}

class WBStatusStatic {

}

/// 微博布局
class WBStatusLayout {
    // 宽度
    let kWBCellTitleHeight:CGFloat = 36     // 标题高度
    let kWBCellProfileHeight:CGFloat = 56   // 名片高度
    
    // 字体
    let kWBCellTitlebarFontSize:CGFloat = 14
    
    // 颜色
    let kWBCellToolbarTitleColor:UIColor = UIColor(hexString:"929292")!
    
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
        let user = self.status.user
        var nameStr: String = ""
        
    }
    
    /// 来源
    func layoutSourse() {
    
    
    }
    
    func layoutRetweet() {
    
    }
    
}