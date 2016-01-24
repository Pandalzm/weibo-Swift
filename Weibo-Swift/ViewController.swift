//
//  ViewController.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/21.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func goWeibo(sender: AnyObject) {
        self.navigationController?.pushViewController(WBTimeLineViewController(), animated: true)
    }
}

