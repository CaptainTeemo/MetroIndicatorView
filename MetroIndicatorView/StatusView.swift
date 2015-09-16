//
//  StatusView.swift
//  Teegramo
//
//  Created by Captain Teemo on 9/16/15.
//  Copyright © 2015 Captain Teemo. All rights reserved.
//

import UIKit

let fadeDuration: NSTimeInterval = 0.1

class StatusBar: NSObject {
    
    static var kStatusBarWindow = "StatusBarWindow"
    
    static var backgroundColor: UIColor = UIColor.clearColor() {
        willSet {
            if let mainWindow = UIApplication.sharedApplication().keyWindow {
                if let statusWidow = objc_getAssociatedObject(mainWindow, &StatusBar.kStatusBarWindow) as? StatusWindow {
                    statusWidow.statusView.setStatusBarColor(newValue)
                }
            }
        }
    }
    
    class func clearStatus() {
        StatusBar.clearStatusAnimated(false)
    }
    
    class func clearStatusAnimated(animated: Bool) {
        guard let mainWindow = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        if let statusWindow = objc_getAssociatedObject(mainWindow, &StatusBar.kStatusBarWindow) as? StatusWindow {
            if animated {
                UIView.animateWithDuration(fadeDuration, animations: { () -> Void in
                    statusWindow.alpha = 0
                    }, completion: { (finished: Bool) -> Void in
                        statusWindow.hidden = true
                })
            } else {
                statusWindow.hidden = true
            }
        }
    }
    
    class func setLoading(animated: Bool, loadAnimated: Bool) {
        guard let mainWindow = UIApplication.sharedApplication().delegate?.window else {
            return
        }
        var statusWindow = objc_getAssociatedObject(mainWindow, &StatusBar.kStatusBarWindow) as? StatusWindow
        if statusWindow == nil {
            statusWindow = StatusWindow(frame: CGRectZero)
            statusWindow!.alpha = 0
            statusWindow!.hidden = true
            
            objc_setAssociatedObject(mainWindow, &kStatusBarWindow, statusWindow!, .OBJC_ASSOCIATION_RETAIN)
        }
        
        statusWindow!.statusView.setStatusBarColor(StatusBar.backgroundColor)
        statusWindow!.statusView.setActivityAnimating(loadAnimated)
        
        if animated {
            UIView.animateWithDuration(fadeDuration, animations: { () -> Void in
                statusWindow!.hidden = false
                statusWindow!.alpha = 1
            })
        } else {
            statusWindow!.hidden = false
            statusWindow!.alpha = 1
        }
    }
}

class StatusView: UIView {
    
    var indicatorView: MetroIndicatorView!
    
    func initView() {
        
        self.backgroundColor = UIColor.clearColor()
        self.indicatorView = MetroIndicatorView(frame: CGRect(x: 0, y: 10, width: 350, height: 60))
        self.addSubview(self.indicatorView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        self.indicatorView.frame = self.bounds
    }
    
    func setStatusBarColor(color: UIColor) {
//        let windowAlpha: CGFloat = UIApplication.sharedApplication().statusBarStyle == .LightContent ? 0.5 : 1.0
//        self.backgroundColor = color.colorWithAlphaComponent(windowAlpha)
        self.backgroundColor = color
    }
    
    func setActivityAnimating(animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
    }
}

class StatusWindow: UIWindow {
    var statusView: StatusView!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initWindow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initWindow()
    }
    
    func initWindow() {
        
        let screenRect = UIScreen.mainScreen().bounds
        
        self.frame = screenRect
        self.backgroundColor = UIColor.clearColor()
        self.windowLevel = UIWindowLevelStatusBar
        self.userInteractionEnabled = false
        self.autoresizesSubviews = true
        
        let statusBarRect = UIApplication.sharedApplication().statusBarFrame
        
        self.statusView = StatusView(frame: statusBarRect)
        self.addSubview(self.statusView)
        
        
        self.didRotate(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRotate:", name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
    }
    
    func didRotate(notification: NSNotification?) {
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        self.transform = self.transformForOrientation(orientation)
        
        let screenRect = UIScreen.mainScreen().bounds
        let statusBarRect = UIApplication.sharedApplication().statusBarFrame
        if UIInterfaceOrientationIsPortrait(orientation) {
            self.bounds = CGRect(x: 0, y: 0, width: CGRectGetWidth(screenRect), height: CGRectGetHeight(screenRect))
            self.statusView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(statusBarRect), height: CGRectGetHeight(statusBarRect))
        } else {
            self.bounds = CGRect(x: 0, y: 0, width: CGRectGetHeight(screenRect), height: CGRectGetWidth(screenRect))
            self.statusView.frame = CGRect(x: 0, y: 0, width: CGRectGetHeight(statusBarRect), height: CGRectGetWidth(statusBarRect))
        }
        
        self.statusView.setNeedsLayout()
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180
    }
    
    func transformForOrientation(orientation: UIInterfaceOrientation) -> CGAffineTransform {
        switch orientation {
        case .LandscapeLeft:
            return CGAffineTransformMakeRotation(self.degreesToRadians(90))
        case .LandscapeRight:
            return CGAffineTransformMakeRotation(self.degreesToRadians(90))
        case .PortraitUpsideDown:
            return CGAffineTransformMakeRotation(self.degreesToRadians(180))
        default:
            return CGAffineTransformMakeRotation(self.degreesToRadians(0))
        }
    }
}
