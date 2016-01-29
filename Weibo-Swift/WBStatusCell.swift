//
//  WBCell.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/21.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import UIKit
import YYText
import YYImage

protocol WBStatusCellDelegate: class {
    
}

class WBStatusCell: UITableViewCell {
    
    var statusView: WBStatusView!
    weak var delegate: WBStatusCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        self.statusView = WBStatusView()
        self.statusView.cell = self
        self.statusView.titleView?.cell = self
        self.statusView.profileView?.cell = self
        self.statusView.cardView?.cell = self
        self.statusView.toolbarView?.cell = self
        self.statusView.tagView?.cell = self
        self.contentView.addSubview(self.statusView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: WBStatusLayout) {
        self.height = layout.height
        self.contentView.height = layout.height
        self.statusView.layout = layout
    }
}

class WBStatusView: UIView {
    var contentView: UIView!                 // 容器
    var titleView: WBStatusTitleView?        // 标题栏
    var profileView: WBStatusProfileView?    // 用户资料
    var textLabel: YYLabel?                  // 文本
    var picView:[UIImageView]?               // 图片 Array
    var retweetBackgroundView: UIView?       // 转发容器
    var retweetTextLabel: YYLabel?           // 转发文本
    var cardView: WBStatusCardView?          // 卡片
    var tagView: WBStatusTagView?            // 标签
    var toolbarView: WBStatusToolBarView?    // 工具栏
    var vipBackgroundView: UIImageView?      // vip自定义背景
    var menuButton: UIButton?                // 菜单按钮
    var cell: WBStatusCell?
    
    var layout: WBStatusLayout {
        get {
            return self.layout
        }
        set(layout) {
            self.layout = layout
            self.height = layout.height
            self.contentView.top = layout.marginTop
            self.contentView.height = layout.height - layout.marginTop - layout.marginBottom
            
            self.profileView!.avatarView.
        
        }
    
    }
   
    
    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.width == 0 && newframe.size.height == 0 {
            newframe.size.width = kScreenWidth()
            newframe.size.height = 1
        }
        super.init(frame: newframe)
        
        self.backgroundColor = UIColor.clearColor()
        self.exclusiveTouch = true
        
        self.contentView = UIView()
        self.contentView.width = kScreenWidth()
        self.contentView.height = 1
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        struct Static {
            static var topLineBG: UIImage? = UIImage()
            static var bottomLineBG: UIImage? = UIImage()
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.topLineBG = UIImage().imageWithSize(CGSizeMake(1, 3), drawBlock: { (context) -> Void in
                CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
                CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, UIColor(white: 0, alpha: 0.08).CGColor)
                CGContextAddRect(context, CGRectMake(-2, 3, 4, 4))
                CGContextFillPath(context)
            })
            Static.bottomLineBG = UIImage().imageWithSize(CGSizeMake(1,3), drawBlock: { (context) -> Void in
                CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
                CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.4, UIColor(white: 0, alpha: 0.08).CGColor)
                CGContextAddRect(context, CGRectMake(-2, -2, 4, 2))
                CGContextFillPath(context)
            })
        }
        
        let topLine: UIImageView = UIImageView(image: Static.topLineBG)
        topLine.width = self.contentView.width
        topLine.bottom = 0
        topLine.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        self.contentView.addSubview(topLine)
        
        let bottomLine: UIImageView = UIImageView(image: Static.bottomLineBG)
        bottomLine.width = self.contentView.width
        bottomLine.top = self.contentView.height
        bottomLine.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        self.contentView.addSubview(bottomLine)
        
        self.addSubview(self.contentView)
        
        self.titleView = WBStatusTitleView()
        self.titleView!.hidden = true
        self.contentView.addSubview(self.titleView!)    // 标题栏
        
        self.profileView = WBStatusProfileView()
        self.contentView.addSubview(self.titleView!)    // 个人
        
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 标题栏
class WBStatusTitleView: UIView {
    var cell: WBStatusCell?
    

}

/// 用户资料
class WBStatusProfileView: UIView {
   
    var avatarView: UIImageView!            // 头像
    var avatarBadgeView: UIImageView!       // 头像右下角徽章
    var nameLabel: YYLabel!                 // 名字
    var sourceLabel: YYLabel!               // 来源
    var backgroundImageView: UIImageView?   // vip自定义背景
    var arrowButton: UIButton?              // 菜单按钮
    var followButton: UIButton?             // 关注按钮
    var verify: WBUserVerifyType?           // 用户类型
    var cell: WBStatusCell?

    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.width == 0 && newframe.size.height == 0 {
            newframe.size.width = kScreenWidth()
            newframe.size.height = kWBCellProfileHeight
        }
        super.init(frame: newframe)
        self.exclusiveTouch = true
        
        self.avatarView = UIImageView()
        self.avatarView.size = CGSizeMake(40, 40)
        self.avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding + 3)
        self.avatarView.contentMode = .ScaleAspectFill
        self.addSubview(self.avatarView)   // 头像
        
        let avatarBorder: CALayer! = CALayer()
        avatarBorder.frame = self.avatarView.bounds
        avatarBorder.borderWidth = CGFloatFromPixel(1)
        avatarBorder.borderColor = UIColor(white: 0, alpha: 0.09).CGColor
        avatarBorder.cornerRadius = self.avatarView.height / 2
        // 把这个layout渲染为一个bitmap,并缓存这个layer，下次使用就不会去再渲染了。如果直接将imageView设置成圆角，在滚动tableView的时候，会明显卡顿
        avatarBorder.shouldRasterize = true
        avatarBorder.rasterizationScale = PandaScreenScale()
        self.avatarView.layer.addSublayer(avatarBorder)        // 头像图层,作用是把头像设置为圆角
        
        self.avatarBadgeView = UIImageView()
        self.avatarBadgeView.size = CGSizeMake(14, 14)
        self.avatarBadgeView.center = CGPointMake(self.avatarView.right - 6, self.avatarView.bottom - 6)
        self.contentMode = .ScaleAspectFill
        self.addSubview(self.avatarBadgeView)       // 头像右下角徽章
        
        self.nameLabel = YYLabel()
        self.nameLabel.size = CGSizeMake(kWBCellNameWidth, 24)
        self.nameLabel.left = self.avatarView.right + kWBCellNamePaddingLeft
        self.nameLabel.centerY = 27
        self.nameLabel.displaysAsynchronously = true        // 异步渲染
        self.nameLabel.ignoreCommonProperties = true
        self.nameLabel.fadeOnAsynchronouslyDisplay = false
        self.nameLabel.fadeOnHighlight = false
        self.nameLabel.lineBreakMode = .ByClipping
        self.nameLabel.textVerticalAlignment = .Center
        self.addSubview(self.nameLabel)     // 名字
        
        self.sourceLabel = YYLabel()
        self.sourceLabel.frame = self.nameLabel.frame
        self.sourceLabel.centerY = 47
        self.sourceLabel.displaysAsynchronously = true
        self.sourceLabel.ignoreCommonProperties = true
        self.sourceLabel.fadeOnAsynchronouslyDisplay = false
        self.sourceLabel.fadeOnHighlight = false
        self.sourceLabel.highlightTapAction = { containerView, text, range, rect in
        }
        self.addSubview(self.sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 卡片
class WBStatusCardView: UIView {
    var cell: WBStatusCell?
}

/// 下方标签
class WBStatusTagView: UIView {
    var cell: WBStatusCell?

}

/// 工具栏
class WBStatusToolBarView: UIView {
    var cell: WBStatusCell?
}


