//
//  WBModel.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/21.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WBUserVerifyType {
    ///< 没有认证
    case WBUserVerifyTypeNone
    ///< 个人认证,黄V
    case WBUserVerifyTypeStandard
    ///< 官方认证,蓝V
    case WBUserVerifyTypeOrganization
    ///< 达人认证,红色星星
    case WBUserVerifyTypeClub
}


enum WBPictureBadgeType {
    case WBPictureBadgeTypeNone     ///< 正常
    case WBPictureBadgeTypeLong     ///< 长图
    case WBPictureBadgeTypeGIF      ///< GIF图片

}

class WBPageInfo {
    var pageTitle: String   ///< 页面标题,  e.g."#为周杰伦正名#"
    var pageID: String
    var pageDesc: String    ///< 页面描述
    var tips: String    ///< "259人关注"
    var pagePic: NSURL
    
    init? (json: JSON) {
        self.pageTitle = json["page_title"].stringValue
        self.pageID = json["page_id"].stringValue
        self.pageDesc = json["page_desc"].stringValue
        self.tips = json["tips"].stringValue
        self.pagePic = NSURL(string: json["page_pic"].stringValue)!
        if json == nil {return nil}
    }
}

class WBTag {
    init? (json: JSON) {
        
    }
}

class WBTopic {
    var topiceTitle: String
    var topicURL: String
    init? (json: JSON) {
        self.topiceTitle = json["topic_title"].stringValue
        self.topicURL = json["topic_url"].stringValue
        if json == nil {return nil}
    }
}

class WBStatusTitle {
    var baseColor: Int32
    var text: String
    var iconURL: String
    init? (json: JSON) {
        self.baseColor = json["base_color"].int32Value
        self.text = json["text"].stringValue
        self.iconURL = json["icon_url"].stringValue
        if json == nil {return nil}
    }
}

/**
 *  The WB URL
 */
class WBURL {
    
    var urlTitle: String        // 标题
    var urlType: Int32          // 0:url 36:地址 39:视频／图片
    var urlTypeURL: String      // 链接类型中的图片URL 
    var shortURL: String
    var originURL: String
    var pageID: String
    var picIds: Array<JSON>
    var pics: [WBPicture?] = []
    init? (json: JSON) {
        self.urlTitle = json["url_title"].stringValue
        self.urlType = json["url_type"].int32Value
        self.shortURL = json["short_url"].stringValue
        self.originURL = json["ori_url"].stringValue
        self.urlTypeURL = json["url_type_pic"].stringValue
        self.pageID = json["page_id"].stringValue
        self.picIds = json["pic_ids"].arrayValue
        for picId in self.picIds {
            self.pics.append(WBPicture(json: json["pic_infos"].dictionaryValue[picId.stringValue]!))
        }
        if json == nil {return nil}
    }
}

/**
 *  The WB User
 */
class WBUser {
    
    var userID: UInt64!
    var idStr: String!
    
    var name: String?
    var screenName: String?
    var remark: String?
    
    var profileImageURL: NSURL!      /// avatar 50*50
    var avatarLarge : NSURL!         /// avatar 180*180
    var avatarHD: NSURL!             /// avatar origin
    
    var urank: Int32    /// weibo level
    var mbrank: Int32   /// weibo vip level . 0 is none
    
    var verified: Bool      /// 大V认证
    var verifiedType: Int32     /// 认证类型
    var verifiedLevel: Int32        /// 认证等级
    var userVerifyType: WBUserVerifyType = WBUserVerifyType.WBUserVerifyTypeNone    /// 认证类型(enum)
    
    init? (json: JSON) {
        self.userID = json["id"].uInt64Value
        self.idStr = String(self.userID)
        self.name = json["name"].stringValue
        self.screenName = json["screen_name"].stringValue
        self.remark = json["remark"].stringValue
        self.profileImageURL = NSURL(string: json["profile_image_url"].stringValue)!
        self.avatarLarge = NSURL(string: json["avatar_large"].stringValue)!
        self.avatarHD = NSURL(string: json["avatar_hd"].stringValue)!
        self.verified = json["verified"].boolValue
        self.verifiedType = json["verified_type"].int32Value
        self.verifiedLevel = json["verified_level"].int32Value
        self.urank = json["urank"].int32Value
        self.mbrank = json["mbrank"].int32Value
        
        if self.verified == true {
            self.userVerifyType = WBUserVerifyType.WBUserVerifyTypeStandard // 个人认证
        } else if self.verifiedType == 220 {
            self.userVerifyType = WBUserVerifyType.WBUserVerifyTypeClub // 达人认证
        } else if self.verifiedType == -1 && self.verifiedLevel == 3 {
            self.userVerifyType = WBUserVerifyType.WBUserVerifyTypeOrganization     // 官方认证
        } else {
            self.userVerifyType = WBUserVerifyType.WBUserVerifyTypeNone
        }
        if json == nil {return nil}
    }
}


/**
 *  The WB single picture
 */
class WBPicture {
    
    var objectID: String
    var keepSize: Bool  ///< 0 is origin ,1 is fixed to square
    var bmiddle: WBPictureMetadata
    var large: WBPictureMetadata
    init? (json: JSON) {
        self.objectID = json["object_id"].stringValue
        self.keepSize = json["keep_size"].boolValue
        self.bmiddle = WBPictureMetadata(json: json["bmiddle"])!
        self.large = WBPictureMetadata(json: json["large"])!
        if json == nil {return nil}
    }
}

/**
 *  The single picture's meta data
 */
class WBPictureMetadata {
    var url: NSURL
    var width: Int32
    var height: Int32
    var type: String    ///< "WEBP" "JPEG" "GIF"
    var cutType: Int32
    var badgeType: WBPictureBadgeType = WBPictureBadgeType.WBPictureBadgeTypeNone
    init? (json: JSON) {
        self.url = NSURL(string: json["url"].stringValue)!
        self.width = json["width"].int32Value
        self.height = json["height"].int32Value
        self.type = json["type"].stringValue
        self.cutType = json["cut_type"].int32Value
        if self.type == "GIF" {
            self.badgeType = WBPictureBadgeType.WBPictureBadgeTypeGIF
        } else {
            if self.width > 0 && self.height / self.width > 3 {
                self.badgeType = WBPictureBadgeType.WBPictureBadgeTypeLong
            }
        }
        if json == nil {return nil}
    }
}

/**
 *  The WB Status
 */
class WBStatus {
    
    var statusID: UInt64!    ///< id(number)
    var idStr: String!   ///< id (String)
    var createdAt: NSDate!   /// e.g. "Wed Sep 09 10:12:55 +0800 2015"
    
    var user: WBUser?
    var userType: Int32
    
    
    // the vip background, need to transform "os7"
    // origin:  "http://img.t.sinajs.cn/t6/skin/public/feed_cover/vip_009_y.png?version=2015080302"
    // recent:  "http://img.t.sinajs.cn/t6/skin/public/feed_cover/vip_009_os7.png?version=2015080302"
    var picBg: String
    var text: String    ///< text data
    
    var retweetedStatus: WBStatus?
    
    var picIds: Array<JSON>
    var pics: [WBPicture] = []
    var urlStruct: [WBURL] = []     ///< the urls in the weibo
    var topicStruct: [WBTopic] = []
    var tagStruct: [WBTag?] = []
    var pageInfo: WBPageInfo?
    var title: WBStatusTitle?  // 顶部标题栏
    
    var favorited: Bool     ///< whether collect
    var repostsCount: Int32
    var commentsCount: Int32
    var attitudesCount: Int32
    var attitudesStatus: Int32  ///< whether attitude. 0 is none
    
    var source: String!  ///< come from XXX
    var sourceType: Int32
    var sourceAllowClick: Int32 ///< whether allow click with source. 0 is not allow
    
    init?(json: JSON) {
        
        self.text = json["text"].stringValue
        self.statusID = json["id"].uInt64Value
        self.idStr = json["idstr"].stringValue
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        self.createdAt = formatter.dateFromString(json["created_at"].stringValue)
        
        self.user = WBUser(json: json["user"])
        self.userType = json["userType"].int32Value
        self.picBg = json["pic_bg"].stringValue
        
        if let _ = json["retweeted_status"].dictionary {
            self.retweetedStatus = WBStatus(json: json["retweeted_status"])
        }
        
        
        self.picIds = json["pic_ids"].arrayValue
        for picId in self.picIds {
            self.pics.append(WBPicture(json: json["pic_infos"].dictionaryValue[picId.stringValue]!)!)
        }
        
        let urls = json["url_struct"].arrayValue
        for i in 0..<urls.count {
            self.urlStruct.append(WBURL(json: urls[i])!)
        }
        
        let topics = json["topic_struct"].arrayValue
        for i in 0..<topics.count {
            self.topicStruct.append(WBTopic(json: topics[i])!)
        }
        
        let tags = json["tag_struct"].arrayValue
        for i in 0..<tags.count {
            self.tagStruct = [WBTag(json: tags[i])!]
        }
        
        self.pageInfo = WBPageInfo(json: json["page_info"])
        self.title = WBStatusTitle(json: json["title"])
        
        self.favorited = json["favorited"].boolValue
        self.repostsCount = json["reposts_count"].int32Value
        self.commentsCount = json["comments_Count"].int32Value
        self.attitudesCount = json["attitudes_Count"].int32Value
        self.attitudesStatus = json["attitudes_Status"].int32Value
        
        self.source = json["source"].stringValue
        self.sourceType = json["source_type"].int32Value
        self.sourceAllowClick = json["source_allowclick"].int32Value
        
        if json == nil {return nil}
    }
}

enum WBEmoticonType {
    case WBEmoticonTypeImage    // 微博自定义表情
    case WBEmoticonTypeEmoji    // Emoji表情
}

class WBEmoticon {
    
    var chs: String?    // e.g. [吃惊]
    var cht: String?    // e.g. [吃驚]
    var gif: String?    // e.g. .gif
    var png: String?    // e.g. .png
    var code: String?   // e.g. 0x1f60d
    var type: WBEmoticonType?
    init? (json: JSON) {
        self.chs = json["chs"].stringValue
        self.cht = json["cht"].stringValue
        self.gif = json["gif"].stringValue
        self.png = json["png"].stringValue
        if json["type"].int32Value == 0 {
            self.type = WBEmoticonType.WBEmoticonTypeImage
        } else {
            self.type = WBEmoticonType.WBEmoticonTypeEmoji
        }

        
        
        if json == nil { return nil }
    
    }
    
}

class WBEmoticonGroup {
    var groupID: String?
    var version: Int32?
    var nameCN: String?     // e.g. 浪小花
    var nameEN: String?
    var nameTW: String?
    var displayOnly: Int32?
    var groupType: Int32?
    var emoticons: [WBEmoticon]? = []
    
    
    init? (data: NSData) {
        let json = JSON(data: data)
        self.groupID = json["id"].stringValue
        self.version = json["version"].int32Value
        self.nameCN = json["group_name_cn"].stringValue
        self.nameEN = json["group_name_en"].stringValue
        self.nameTW = json["group_name_tw"].stringValue
        self.displayOnly = json["display_only"].int32Value
        self.groupType = json["group_type"].int32Value
        let emoticons = json["emoticons"].arrayValue
        for i in 0..<emoticons.count {
            self.emoticons?.append(WBEmoticon(json: emoticons[i])!)
        }
        if json == nil { return nil }
    }
}


/**
 *  Once the API requested data
 */
class WBTimelineItem {
    
    var statusItems: [WBStatus] = []
    
    init? (data: NSData){
        let json = JSON(data: data)
        if json == nil {return nil}
        let statuses = json["statuses"].arrayValue
        for i in 0..<statuses.count {
            let statusItem = WBStatus(json: statuses[i])
            statusItems.append(statusItem!)
        }
    }

}