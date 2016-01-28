//
//  Dictionary+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/27.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// merge two dictionary
    mutating func addEntriesFromDictionary<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}