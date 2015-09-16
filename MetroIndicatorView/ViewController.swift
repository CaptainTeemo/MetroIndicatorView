//
//  ViewController.swift
//  MetroIndicatorView
//
//  Created by Captain Teemo on 9/16/15.
//  Copyright © 2015 Captain Teemo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        StatusBar.setLoading(true, loadAnimated: true)
        
        StatusBar.backgroundColor = UIColor.blackColor()

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
//            StatusBar.clearStatusAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

