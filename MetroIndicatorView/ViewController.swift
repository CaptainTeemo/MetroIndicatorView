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
        
        StatusBar.setLoading(true, loadAnimated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

