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
import Kingfisher

// cell控件点击协议
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
    var titleView: WBStatusTitleView!        // 标题栏
    var profileView: WBStatusProfileView!    // 用户资料
    var textLabel: YYLabel!                  // 文本
    var picView:[WBPictureView]! = []        // 图片 Array
    var retweetBackgroundView: UIView!       // 转发容器
    var retweetTextLabel: YYLabel!           // 转发文本
    var cardView: WBStatusCardView!          // 卡片
    var tagView: WBStatusTagView!            // 标签
    var toolbarView: WBStatusToolBarView!    // 工具栏
    var vipBackgroundView: UIImageView!      // vip自定义背景
    var menuButton: UIButton!                // 菜单按钮
    var cell: WBStatusCell!
    private var _layout: WBStatusLayout!
    
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
        self.titleView.hidden = true
        self.contentView.addSubview(self.titleView)    // 标题栏
        
        self.profileView = WBStatusProfileView()
        self.contentView.addSubview(self.profileView)    // 个人
        
        self.vipBackgroundView = UIImageView()
        self.vipBackgroundView.size = CGSizeMake(kScreenWidth(), 14)
        self.vipBackgroundView.top = -2
        self.vipBackgroundView.right = self.right + 30
        self.vipBackgroundView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(self.vipBackgroundView)     // vip背景
        
        self.menuButton = UIButton(type: .Custom)
        self.menuButton.size = CGSizeMake(30, 30)
        self.menuButton.setImage(WBStatusHelper().imageNamed("timeline_icon_more"), forState: .Normal)
        self.menuButton.setImage(WBStatusHelper().imageNamed("timeline_icon_more_highlighted"), forState: .Highlighted)
        self.menuButton.centerX = self.width - 20
        self.menuButton.centerY = 18
        self.contentView.addSubview(self.menuButton)        // 菜单按钮
        
        self.retweetBackgroundView = UIView()
        self.retweetBackgroundView.backgroundColor = kWBCellInnerViewColor
        self.retweetBackgroundView.width = kScreenWidth()
        self.contentView.addSubview(self.retweetBackgroundView)     // 转发背景
        
        self.textLabel = YYLabel()
        self.textLabel.left = kWBCellPadding
        self.textLabel.width = kWBCellContentWidth
        self.textLabel.textVerticalAlignment = .Top
        self.textLabel.displaysAsynchronously = true
        self.textLabel.ignoreCommonProperties = true
        self.textLabel.fadeOnAsynchronouslyDisplay = false
        self.textLabel.fadeOnHighlight = false
        self.textLabel.highlightTapAction = {containerView, text, range, rect in
        
        }
        self.contentView.addSubview(self.textLabel)         // 正文文本
        
        self.retweetTextLabel = YYLabel()
        self.retweetTextLabel.left = kWBCellPadding
        self.retweetTextLabel.width = kWBCellContentWidth
        self.retweetTextLabel.textVerticalAlignment = .Top
        self.retweetTextLabel.displaysAsynchronously = true
        self.retweetTextLabel.ignoreCommonProperties = true
        self.retweetTextLabel.fadeOnAsynchronouslyDisplay = false
        self.retweetTextLabel.fadeOnHighlight = false
        self.retweetTextLabel.highlightTapAction = {containerView, text, range, rect in
            
        }
        self.contentView.addSubview(self.retweetTextLabel)  // 转发正文文本
        
        var picViews:[WBPictureView] = []
        for _ in 0..<9 {
            let imageView: WBPictureView! = WBPictureView()
            imageView.size = CGSizeMake(100, 100)
            imageView.hidden = true
            imageView.clipsToBounds = true
            imageView.backgroundColor = kWBCellHighlightColor
            imageView.exclusiveTouch = true
            
            let badge: UIImageView = UIImageView()
            badge.userInteractionEnabled = false
            badge.contentMode = .ScaleAspectFit
            badge.size = CGSizeMake(56 / 2, 36 / 2)
            badge.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin]
            badge.right = imageView.width
            badge.bottom = imageView.height
            badge.hidden = true
            imageView.addSubview(badge)
            
            picViews.append(imageView)
            self.contentView.addSubview(imageView)      // 微博图片
        }
        
        self.picView = picViews
        
        
        self.cardView = WBStatusCardView()
        self.cardView.hidden = true
        self.contentView.addSubview(self.cardView)
        
        self.tagView = WBStatusTagView()
        self.tagView.left = kWBCellPadding
        self.tagView.hidden = true
        self.contentView.addSubview(self.tagView)
        
        self.toolbarView = WBStatusToolBarView()
        self.contentView.addSubview(self.toolbarView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var layout: WBStatusLayout {
        get {
            return _layout
        }
        set {
            _layout = newValue
            self.height = newValue.height
            self.contentView.top = newValue.marginTop
            self.contentView.height = newValue.height - newValue.marginTop - newValue.marginBottom
            
            // 标题栏
            var top: CGFloat = 0
            if newValue.titleHeight > 0 {
                self.titleView.hidden = false
                self.titleView.height = newValue.titleHeight
                self.titleView.titleLabel.textLayout = newValue.titleTextLayout
                top = newValue.titleHeight
            } else {
                self.titleView.hidden = true
            }
            
            // 用户资料

            self.profileView.avatarView.kf_setImageWithURL(newValue.status.user!.avatarLarge, placeholderImage: nil)
            self.profileView.nameLabel.textLayout = newValue.nameTextLayout
            self.profileView.sourceLabel.textLayout = newValue.sourceTextLayout
            self.profileView.verify = newValue.status.user!.userVerifyType
            self.profileView.height = newValue.profileHeight
            self.profileView.top = top
            top += newValue.profileHeight
            
            // vip背景
            if newValue.status.picBg.length > 0 {
                let picBg: NSURL! = WBStatusHelper().defaultURLForImageURLStr(newValue.status.picBg)
                self.vipBackgroundView.kf_setImageWithURL(picBg, placeholderImage: nil)
            }
            
            // 正文文本
            self.textLabel.top = top
            self.textLabel.height = newValue.textHeight
            self.textLabel.textLayout = newValue.textLayout
            top += newValue.textHeight
            
            self.retweetBackgroundView.hidden = true
            self.retweetTextLabel.hidden = true
            self.cardView.hidden = true
            
            if newValue.picHeight == 0 && newValue.retweetPicHeight == 0 {
                self.hideImageViews()
            }
            
            // 优先级: 转发 > 图片 > 卡片
            if newValue.retweetHeight > 0 {
                self.retweetBackgroundView.top = top
                self.retweetBackgroundView.height = newValue.retweetHeight
                self.retweetBackgroundView.hidden = false
                
                self.retweetTextLabel.top = top
                self.retweetTextLabel.height = newValue.retweetTextHeight
                self.retweetTextLabel.textLayout = newValue.retweetTextLayout
                self.retweetTextLabel.hidden = false
                
                if newValue.retweetPicHeight > 0 {
                    self.setImageViewWithTop(self.retweetTextLabel.bottom, isRetweet: true)
                } else {
                    self.hideImageViews()
                    if newValue.retweetCardHeight > 0 {
                        self.cardView.top = self.retweetTextLabel.bottom
                        self.cardView.hidden = false
                        self.cardView.setWithLayout(newValue, isRetweet: true)
                    }
                }
            } else if newValue.picHeight > 0 {
                self.setImageViewWithTop(top, isRetweet: false)
            } else if newValue.cardHeight > 0 {
                self.cardView.top = top
                self.cardView.hidden = false
                self.cardView.setWithLayout(newValue, isRetweet: false)
            }
            
            self.toolbarView.bottom = self.contentView.height
            self.toolbarView.setWithLayout(layout)
        }
    }
    
    func hideImageViews() {
        for picture: WBPictureView in self.picView {
            picture.hidden = true
        }
    }
    
    /// 根据top坐标设置imageview
    func setImageViewWithTop(imageTop: CGFloat, isRetweet: Bool) {
        let picSize: CGSize! = isRetweet ? self.layout.retweetPicSize : self.layout.picSize
        let pics: [WBPicture] = isRetweet ? self.layout.status.retweetedStatus!.pics : self.layout.status.pics
        let picsCount: Int = pics.count
        
        for i in 0..<9 {
            let imageView = self.picView[i]
            if i >= picsCount {
                imageView.hidden = true
            } else {
                var origin: CGPoint! = CGPointMake(0, 0)
                switch (picsCount) {
                case 1:
                    origin.x = kWBCellPadding
                    origin.y = imageTop
                    break
                case 4:
                    origin.x = kWBCellPadding + CGFloat(i % 2) * (picSize.width + kWBCellPaddingPic)
                    origin.y = imageTop + CGFloat(i / 2) * (picSize.height + kWBCellPaddingPic)
                    break
                default:
                    origin.x = kWBCellPadding + CGFloat(i % 3) * (picSize.width + kWBCellPaddingPic)
                    origin.y = imageTop + CGFloat(i / 3) * (picSize.height + kWBCellPaddingPic)
                    break
                }
                imageView.frame = CGRectMake(origin.x, origin.y, picSize.width, picSize.width)
                imageView.hidden = false
                let pic:WBPicture! = pics[i]
                
                let badge: UIView! = imageView.subviews.first
                switch(pic.largest!.badgeType) {
                case .WBPictureBadgeTypeNone:
                    if badge.layer.contents != nil {
                        badge.layer.contents = nil
                        badge.hidden = true
                    }
                    break
                case .WBPictureBadgeTypeLong:
                    badge.layer.contents = WBStatusHelper().imageNamed("timeline_image_longimage")?.CGImage
                    badge.hidden = false
                    break
                case .WBPictureBadgeTypeGIF:
                    badge.layer.contents = WBStatusHelper().imageNamed("timeline_image_gif")?.CGImage
                    badge.hidden = false
                    break
                }
                
                let width = CGFloat(pic.bmiddle.width)
                let height = CGFloat(pic.bmiddle.height)
                let scale = height / width / (imageView.height / imageView.width)   // 比例( > 1 为 长图, < 1 为宽图)
                if scale < 0.99 {   // 宽图
                    imageView.contentMode = .ScaleAspectFill
                    imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1)
                } else {        // 长图
                    imageView.contentMode = .ScaleToFill
                    imageView.layer.contentsRect = CGRectMake(0, 0, 1,(width / height))
                }
                imageView.kf_setImageWithURL(pic.large.url!, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(0.3))])
            }
        }
    }
}

/// 标题栏
class WBStatusTitleView: UIView {
    var titleLabel: YYLabel!
    var arrowButton: UIButton!
    var cell: WBStatusCell?
    
    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.width == 0 && newframe.size.height == 0 {
            newframe.size.width = kScreenWidth()
            newframe.size.height = kWBCellTitleHeight
        }
        super.init(frame: newframe)
        self.exclusiveTouch = true
        self.titleLabel = YYLabel()
        self.titleLabel.size = CGSizeMake(kScreenWidth() - 100, self.height)
        self.titleLabel.left = kWBCellPadding
        self.titleLabel.displaysAsynchronously = true
        self.titleLabel.ignoreCommonProperties = true
        self.titleLabel.fadeOnAsynchronouslyDisplay = false
        self.titleLabel.fadeOnHighlight = false
        self.addSubview(self.titleLabel)
        
        let line: CALayer! = CALayer()
        line.size = CGSizeMake(self.width, CGFloatFromPixel(1))
        line.bottom = self.height
        line.backgroundColor = kWBCellLineColor.CGColor
        self.layer.addSublayer(line)            // 底部线条
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

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
    var cell: WBStatusCell?
    
    var verify: WBUserVerifyType {
        get {
            return self.verify
        }
        set {
            switch (newValue) {
            case .WBUserVerifyTypeStandard:
                self.avatarBadgeView.hidden = false
                self.avatarBadgeView.image = WBStatusHelper().imageNamed("avatar_vip")
                break
            case .WBUserVerifyTypeClub:
                self.avatarBadgeView.hidden = false
                self.avatarBadgeView.image = WBStatusHelper().imageNamed("avatar_grassroot")
                break
            default:
                self.avatarBadgeView.hidden = true
                break
            }
        }
    }

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
        self.avatarBadgeView.center = CGPointMake(self.avatarView.right , self.avatarView.bottom )
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
    
    var imageView: UIImageView?
    var badgeImageView: UIImageView?
    var label: YYLabel?
    var button: UIButton?
    var cell: WBStatusCell?
    var _isRetweet: Bool!
    
    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.width == 0 && newframe.size.height == 0 {
            newframe.size.width = kScreenWidth()
            newframe.origin.x = kWBCellPadding
        }
        super.init(frame: newframe)
        
        self.imageView = UIImageView()
        self.imageView?.clipsToBounds = true
        self.imageView?.contentMode = .ScaleAspectFill
        
        self.badgeImageView = UIImageView()
        self.badgeImageView?.clipsToBounds = true
        self.badgeImageView?.contentMode = .ScaleAspectFit
        
        self.label = YYLabel()
        self.label?.textVerticalAlignment = .Center
        self.label?.numberOfLines = 3
        self.label?.ignoreCommonProperties = true
        self.label?.displaysAsynchronously = true
        self.label?.fadeOnAsynchronouslyDisplay = false
        self.label?.fadeOnHighlight = false
        
        self.button = UIButton(type: .Custom)
        
        self.addSubview(self.imageView!)
        self.addSubview(self.badgeImageView!)
        self.addSubview(self.label!)
        self.addSubview(self.button!)
        
        self.backgroundColor = kWBCellInnerViewColor
        self.layer.borderWidth = CGFloatFromPixel(1)
        self.layer.borderColor = UIColor(white: 0, alpha: 0.07).CGColor
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout: WBStatusLayout, isRetweet: Bool) {
        let pageInfo: WBPageInfo? = isRetweet ? layout.status.retweetedStatus?.pageInfo : layout.status.pageInfo
        if pageInfo == nil { return }
        self.height = isRetweet ? layout.retweetCardHeight : layout.cardHeight
        _isRetweet = isRetweet
        
        switch (isRetweet ? layout.retweetCardType : layout.cardType) {
        case .WBStatusCardTypeNone : break
        case .WBStatusCardTypeNormal :
            self.width = kWBCellContentWidth
            if pageInfo?.typeIcon != nil {
                self.badgeImageView?.hidden = false
                self.badgeImageView?.frame = CGRectMake(0, 0, 25, 25)
                self.badgeImageView?.kf_setImageWithURL((pageInfo?.typeIcon)!)
            } else {
                self.badgeImageView?.hidden = true
            }
            if pageInfo?.pagePic != nil {
                self.imageView?.hidden = false
                if pageInfo?.typeIcon != nil {      // 有类型小图标的时候，图会长一点
                    self.imageView?.frame = CGRectMake(0, 0, 100, 70)
                } else {
                    self.imageView?.frame = CGRectMake(0, 0, 70, 70)
                }
                self.imageView?.kf_setImageWithURL((pageInfo?.pagePic)!)
            } else {
                self.imageView?.hidden = true
            }
            self.label?.hidden = false
            self.label?.frame = (isRetweet ? layout.retweetCardTextRect : layout.cardTextRect)!
            self.label?.textLayout = isRetweet ? layout.retweetCardTextLayout : layout.cardTextLayout
            break
        case .WBStatusCardTypeVideo :
            self.width = self.height
            self.badgeImageView?.hidden = true
            self.label?.hidden = true
            self.imageView?.frame = self.bounds
            self.imageView?.kf_setImageWithURL((pageInfo?.pagePic)!)
            self.button?.hidden = false
            self.button?.frame = self.bounds
            self.button?.setImage(WBStatusHelper().imageNamed("multimedia_videocard_play"), forState: .Normal)
            break
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}

/// 下方标签
class WBStatusTagView: UIView {
    var cell: WBStatusCell?

}

/// 工具栏
class WBStatusToolBarView: UIView {
    var repostButton: UIButton!
    var commontButton: UIButton!
    var likeButton: UIButton!
    
    var repostImageView: UIImageView!
    var commentImageView: UIImageView!
    var likeImageView: UIImageView!
    
    var repostLabel: YYLabel!
    var commentLabel: YYLabel!
    var likeLabel: YYLabel!
    
    var leftLine: CAGradientLayer!
    var rightLine: CAGradientLayer!
    var topLine: CALayer!
    var bottomLine: CALayer!
    
    var cell: WBStatusCell?
    
    override init(frame: CGRect) {
        var newframe = frame
        if newframe.size.width == 0 && newframe.size.height == 0 {
            newframe.size.width = kScreenWidth()
            newframe.size.height = kWBCellToolbarHeight
        }
        super.init(frame: newframe)
        self.exclusiveTouch = true
        
        self.repostButton = UIButton(type: .Custom)
        self.repostButton.exclusiveTouch = true
        self.repostButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.repostButton.setBackgroundImage(UIImage().imageWithColor(kWBCellHighlightColor), forState: .Highlighted)
        
        self.commontButton = UIButton(type: .Custom)
        self.commontButton.exclusiveTouch = true
        self.commontButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.commontButton.left = CGFloatPixelRound(self.width / 3)
        self.commontButton.setBackgroundImage(UIImage().imageWithColor(kWBCellHighlightColor), forState: .Highlighted)
        
        self.likeButton = UIButton(type: .Custom)
        self.likeButton.exclusiveTouch = true
        self.likeButton.left = CGFloatPixelRound(self.width / 3 * 2)
        self.likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.likeButton.setBackgroundImage(UIImage().imageWithColor(kWBCellHighlightColor), forState: .Highlighted)
        
        self.repostImageView = UIImageView(image: WBStatusHelper().imageNamed("timeline_icon_retweet"))
        self.repostImageView.centerY = self.height / 2
        self.repostButton.addSubview(self.repostImageView)
        
        self.commentImageView = UIImageView(image: WBStatusHelper().imageNamed("timeline_icon_comment"))
        self.commentImageView.centerY = self.height / 2
        self.commontButton.addSubview(self.commentImageView)
        
        self.likeImageView = UIImageView(image: WBStatusHelper().imageNamed("timeline_icon_unlike"))
        self.likeImageView.centerY = self.height / 2
        self.likeButton.addSubview(self.likeImageView)
        
        self.repostLabel = YYLabel()
        self.repostLabel.userInteractionEnabled = false
        self.repostLabel.height = self.height
        self.repostLabel.textVerticalAlignment = .Center
        self.repostLabel.displaysAsynchronously = true
        self.repostLabel.ignoreCommonProperties = true
        self.repostLabel.fadeOnHighlight = false
        self.repostLabel.fadeOnAsynchronouslyDisplay = false
        self.repostButton.addSubview(self.repostLabel)
        
        self.commentLabel = YYLabel()
        self.commentLabel.userInteractionEnabled = false
        self.commentLabel.height = self.height
        self.commentLabel.textVerticalAlignment = .Center
        self.commentLabel.displaysAsynchronously = true
        self.commentLabel.ignoreCommonProperties = true
        self.commentLabel.fadeOnHighlight = false
        self.commentLabel.fadeOnAsynchronouslyDisplay = false
        self.commontButton.addSubview(self.commentLabel)
        
        self.likeLabel = YYLabel()
        self.likeLabel.userInteractionEnabled = false
        self.likeLabel.height = self.height
        self.likeLabel.textVerticalAlignment = .Center
        self.likeLabel.displaysAsynchronously = true
        self.likeLabel.ignoreCommonProperties = true
        self.likeLabel.fadeOnHighlight = false
        self.likeLabel.fadeOnAsynchronouslyDisplay = false
        self.likeButton.addSubview(self.likeLabel)
        
        let dark: UIColor! = UIColor(white: 0, alpha: 0.2)
        let clear: UIColor! = UIColor(white: 0, alpha: 0)
        let colors = [clear.CGColor, dark.CGColor, clear.CGColor]
        let locations = [0.2, 0.5, 0.8]
        
        self.leftLine = CAGradientLayer()
        self.leftLine.colors = colors
        self.leftLine.locations = locations
        self.leftLine.startPoint = CGPointMake(0, 0)
        self.leftLine.endPoint = CGPointMake(0, 1)
        self.leftLine.size = CGSizeMake(CGFloatFromPixel(1), self.height)
        self.leftLine.left = self.commontButton.left
        
        self.rightLine = CAGradientLayer()
        self.rightLine.colors = colors
        self.rightLine.locations = locations
        self.rightLine.startPoint = CGPointMake(0, 0)
        self.rightLine.endPoint = CGPointMake(0, 1)
        self.rightLine.size = CGSizeMake(CGFloatFromPixel(1), self.height)
        self.rightLine.left = self.commontButton.right
        
        self.topLine = CALayer()
        self.topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1))
        self.topLine.backgroundColor = kWBCellLineColor.CGColor
        
        self.bottomLine = CALayer()
        self.bottomLine.size = self.topLine.size
        self.bottomLine.bottom = self.height
        self.bottomLine.backgroundColor = UIColor(hexString: "e8e8e8")?.CGColor
        
        self.addSubview(self.repostButton)
        self.addSubview(self.commontButton)
        self.addSubview(self.likeButton)
        self.layer.addSublayer(self.leftLine)
        self.layer.addSublayer(self.rightLine)
        self.layer.addSublayer(self.topLine)
        self.layer.addSublayer(self.bottomLine)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout: WBStatusLayout) {
        self.repostLabel.width = layout.toolbarRepostTextWidth
        self.commentLabel.width = layout.toolbarRepostTextWidth
        self.likeLabel.width = layout.toolbarRepostTextWidth
        
        self.repostLabel.textLayout = layout.toolbarRepostTextLayout
        self.commentLabel.textLayout = layout.toolbarRepostTextLayout
        self.likeLabel.textLayout = layout.toolbarRepostTextLayout
        
        self.adjustImage(self.repostImageView, label: self.repostLabel, button: self.repostButton)
        self.adjustImage(self.commentImageView, label: self.commentLabel, button: self.commontButton)
        self.adjustImage(self.likeImageView, label: self.likeLabel, button: self.likeButton)
        
        self.likeImageView.image = layout.status.attitudesStatus > 0 ? self.likeImage : self.unlikeImage
    }
    
    var likeImage: UIImage! {
        get{
            struct Static {
                static var img: UIImage = UIImage()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.img = WBStatusHelper().imageNamed("timeline_icon_like")!
            }
            return Static.img
        }
    }
    
    var unlikeImage: UIImage! {
        get{
            struct Static {
                static var img: UIImage = UIImage()
                static var onceToken: dispatch_once_t = 0
            }
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.img = WBStatusHelper().imageNamed("timeline_icon_unlike")!
            }
            return Static.img
        }
    }
    
    private func adjustImage(image: UIImageView, label: YYLabel, button: UIButton) {
        let imageWidth = image.bounds.size.width
        let labelWith = label.width
        let paddingMid:CGFloat = 5
        let paddingSide = (button.width - imageWidth - labelWith - paddingMid) / CGFloat(2)
        image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2)
        label.right = CGFloatPixelRound(button.width - paddingSide)
    }
  
}


