//
//  MetroIndicatorView.swift
//  Teegramo
//
//  Created by Captain Teemo on 9/16/15.
//  Copyright © 2015 Captain Teemo. All rights reserved.
//

import UIKit
import QuartzCore

class Circle: UIView {
    
    var color = UIColor.whiteColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.color.set()
        CGContextFillEllipseInRect(context, self.frame)
        CGContextAddArc(context, self.frame.width / 3, self.frame.height / 3, self.frame.height / 3 - 1, 0, 2 * CGFloat(M_PI), 1)
        CGContextDrawPath(context, .Fill)
    }
}

class MetroIndicatorView: UIView {
    
    var isAnimating = false
    var circleCount = 0
    var maxCircleCount = 4
    var circleSize: CGFloat = 0
    var radius: CGFloat = 0
    var color = UIColor.whiteColor()
    var circleDelay: NSTimer!
    
    override var frame: CGRect {
        didSet {
            if self.isAnimating {
                self.stopAnimating()
                self.startAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func startAnimating() {
        if !self.isAnimating {
            self.isAnimating = true
            self.circleCount = 0
            self.radius = self.frame.width / 2
            if self.frame.width > self.frame.height {
                self.radius = self.frame.height / 2
            }
            
            self.circleSize = 10 * self.radius / 55
            self.circleDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "nextCircle", userInfo: nil, repeats: true)
        }
    }
    
    func nextCircle() {
        if self.circleCount < self.maxCircleCount {
            self.circleCount += 1
            let circle = Circle(frame: CGRect(x: (self.frame.width - self.circleSize) / 2 - 1, y: self.frame.height - self.circleSize - 1, width: self.circleSize + 2, height: self.circleSize + 2))
            circle.color = self.color
            circle.backgroundColor = UIColor.clearColor()
            self.addSubview(circle)
            
            let circlePath = CGPathCreateMutable()
            var transform = CGAffineTransformIdentity
            CGPathMoveToPoint(circlePath, nil, 0, 0)
            CGPathAddLineToPoint(circlePath, &transform, 350, 0)
            let circleAnimation = CAKeyframeAnimation(keyPath: "position")
            circleAnimation.duration = 2.5
            circleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.15, 0.6, 0.85, 0.4)
            circleAnimation.calculationMode = kCAAnimationPaced
            circleAnimation.path = circlePath
            circleAnimation.repeatCount = Float.infinity
            circle.layer.addAnimation(circleAnimation, forKey: "circleAnimation")
            
        } else {
            self.circleDelay.invalidate()
        }
    }
    
    func stopAnimating() {
        self.layer.removeAllAnimations()
        self.circleDelay.invalidate()
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.isAnimating = false
    }
}
