//
//  WBTimeLineViewController.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/21.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import UIKit

class WBTimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.000, alpha: 0.919)
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        self.view.addSubview(self.tableView)
        
        self.navigationController?.view.userInteractionEnabled = false
        let indicator = UIActivityIndicatorView()
        indicator.size = CGSizeMake(80, 80)
        indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2)
        indicator.backgroundColor = UIColor(white: 0.000, alpha: 0.670)
        indicator.clipsToBounds = true
        indicator.layer.cornerRadius = 6
        indicator.startAnimating()
        self.view.addSubview(indicator)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            var layouts :[WBStatusLayout] = []
            for i in 0..<8 {
                let data = NSData().dataNamed("weibo_\(i).json")
                let item = WBTimelineItem(data: data)
                for status in (item?.statusItems)! {
                    let layout = WBStatusLayout(status: status)
                    layout!.layout()
                    layouts.append(layout!)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.title = "Weibo (loaded:\(layouts.count))"
                indicator.removeFromSuperview()
                self.navigationController?.view.userInteractionEnabled = true
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = WBCell()
        
        return cell
    }

}
