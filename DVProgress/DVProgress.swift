//
//  DVProgress.swift
//  DVProgress
//
//  Created by Đặng Vinh on 12/2/15.
//  Copyright © 2015 Đặng Vinh. All rights reserved.
//

import UIKit

class DVProgress: UIViewController {
    
    // MARK: - VARIABLES
    
    enum DVProgressStyle {
        case CircleRotating, CircleLoading, BarLoading, TextOnly
    }
    
    weak var containerView: UIView!
    weak var animationView: AnimationView?
    weak var messengeTextView: UITextView?
    weak var target: UIView!
    weak var shadowView: UIView?
    
    private let deviceWidth = UIScreen.mainScreen().bounds.width
    private let deviceHeight = UIScreen.mainScreen().bounds.height
    private var containerViewWidth: CGFloat = 140
    private var containerViewHeight: CGFloat = 140
    private var animationViewWidth: CGFloat = 80
    private var animationViewHeight: CGFloat = 80
    private let containerViewPadding: CGFloat = 10
    private var distanceBetweenAnimationViewAndMessengeTextView: CGFloat = 0
    
    private var progressStyle: DVProgressStyle = .CircleRotating
    private var messenge: String = ""
    
    private var animate = true
    private let showDuration = 0.3
    private let hideDuration = 0.2
    
    private var animationTimer: NSTimer?
    private let crDuration: NSTimeInterval = 0.1
    private let clDuration: NSTimeInterval = 1/30
    
    // MARK: - VIEW METHODS
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        createShadowView()
    }
    
    // MARK: - INIT METHODS
    
    init(showInView: UIView, style: DVProgressStyle, messenge: String?, animate: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = showInView
        self.progressStyle = style
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        
        createContainerView()
        createAnimationView()
        createMessengeTextView()
        
        switch (self.progressStyle) {
        case .CircleRotating:
            handleCircleRotating()
        case .CircleLoading:
            handleCircleLoading()
        case .BarLoading:
            handleBarLoading()
        case .TextOnly:
            handleTextOnly()
        }
        
        show()
    }

    private func handleCircleRotating() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.CircleRotating
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(crDuration, target: self, selector: Selector("updateCircleRotating"), userInfo: nil, repeats: true)
    }
    
    private func handleCircleLoading() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.CircleLoading
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(clDuration, target: self, selector: Selector("updateCircleLoading"), userInfo: nil, repeats: true)
    }
    
    private func handleBarLoading() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.BarLoading
    }
    
    private func handleTextOnly() {
        
    }
    
    // MARK: - UPDATES ANIMATION FOR ANIMATION VIEW
    
    func updateCircleRotating() {
        animationView?.setNeedsDisplay()
    }
    
    func updateCircleLoading() {
        animationView?.setNeedsDisplay()
    }
    
    // MARK: - SETUPS/CREATES VIEW METHODS
    
    private func setupView() {
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    }
    
    private func createContainerView() {
        let cView = UIView(frame: CGRect(x: 0, y: 0, width: containerViewWidth, height: containerViewHeight))
        cView.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        cView.backgroundColor = UIColor.blackColor()
        cView.alpha = 0.5
        cView.clipsToBounds = true
        cView.layer.cornerRadius = 10.0
        cView.translatesAutoresizingMaskIntoConstraints = true
        cView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        view.addSubview(cView)
        containerView = cView
    }
    
    private func createAnimationView() {
        if progressStyle != .TextOnly {
            if progressStyle == .BarLoading {
                animationViewWidth = 100
                animationViewHeight = 20
            }
            let aView = AnimationView(frame: CGRect(x: (containerViewWidth - animationViewWidth)/2, y: containerViewPadding, width: animationViewWidth, height: animationViewHeight))
            containerView.addSubview(aView)
            animationView = aView
        } else {
            animationViewWidth = 0
            animationViewHeight = 0
            distanceBetweenAnimationViewAndMessengeTextView = 0
        }

    }
    
    private func createMessengeTextView() {
        if(messenge == "") {
            containerView.frame.size.height = (containerViewPadding*2) + animationViewHeight
            return
        }
        
        let fixedWidth: CGFloat = containerViewWidth - (2*containerViewPadding)
        let mTextView = UITextView(frame: CGRect(x: containerViewPadding, y: containerViewPadding + animationViewHeight + distanceBetweenAnimationViewAndMessengeTextView , width: fixedWidth, height: 0))
        mTextView.backgroundColor = UIColor.clearColor()
        mTextView.font = UIFont(name: "Helvetica", size: 12)
        mTextView.textColor = UIColor.whiteColor()
        mTextView.editable = false
        mTextView.scrollEnabled = false
        mTextView.textAlignment = .Center
        
        containerView.addSubview(mTextView)
        messengeTextView = mTextView
        
        updateFrameByNewMessenge()
    }
    
    private func createShadowView() {
        let sView = UIView(frame: view.frame)
        sView.backgroundColor = UIColor.blackColor()
        sView.layer.zPosition = -5
        sView.translatesAutoresizingMaskIntoConstraints = true
        sView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        view.addSubview(sView)
        shadowView = sView
    }
    
    // MARK: - REMOVES VIEW METHODS
    
    private func stopAnimation() {
        if(animationTimer != nil) {
            animationTimer?.invalidate()
            animationTimer = nil
        }
    }
    
    private func removeAllViews() {
        animationView?.removeFromSuperview()
        animationView = nil
        
        messengeTextView?.removeFromSuperview()
        messengeTextView = nil
        
        containerView.removeFromSuperview()
        containerView = nil

        shadowView?.removeFromSuperview()
        shadowView = nil
        
        view.removeFromSuperview()
        view = nil
    }
    
    // MARK: - SHOWS/HIDES VIEW METHODS
    
    private func show() {
        if(target == nil) { return }
        target.addSubview(self.view)
        
        shadowView?.alpha = 0
        containerView.alpha = 0
        
        if self.animate {
            UIView.animateWithDuration(showDuration, animations: {
                self.shadowView?.alpha = 0.8
                self.containerView.alpha = 1
                }, completion: { finished in
        
            })
        } else {
            self.shadowView?.alpha = 0.8
            self.containerView.alpha = 1
        }
    }
    
    private func hide() {
        if self.animate {
            UIView.animateWithDuration(hideDuration, animations: {
                self.shadowView?.alpha = 0
                self.containerView.alpha = 0
                }, completion: { finished in
                    self.removeAllViews()
            })
        } else {
            self.shadowView?.alpha = 0
            self.containerView.alpha = 0
            self.stopAnimation()
            self.removeAllViews()
        }
    }
    
    // MARK: - SUPPORTING METHODS
    
    private func updateFrameByNewMessenge() {
        messengeTextView!.text = messenge
        let newSize = messengeTextView!.sizeThatFits(CGSize(width: messengeTextView!.frame.width, height: deviceHeight))
        messengeTextView!.frame.size.height = newSize.height
        
        let valueChangeHeight = (CGRectGetMaxY(messengeTextView!.frame) + containerViewPadding) - containerViewHeight
        updateContainerViewHeightByValue(valueChangeHeight)
    }
    
    private func updateContainerViewHeightByValue(value: CGFloat) {
        if (containerView != nil) {
            containerView.frame.size.height += value
            containerView.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        }
    }
    
    // MARK: - INTERACTS WITH PARENT VIEW CONTROLLER
    
    func hide(animate animate: Bool) {
        self.animate = animate
        hide()
    }
    
    ////////////////////////////
    // MARK: - UIVIEW CLASSES
    ////////////////////////////
    
    class AnimationView: UIView {
        
        enum AnimationStyle {
            case CircleRotating, CircleLoading, BarLoading
        }
        
        // MARK: - VARIABLES
        
        // CIRCLE ROTATING
        
        let crMarkerWidth: CGFloat = 5.0
        let crMarkerHeight: CGFloat = 12.0
        let crMarkerColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        let crMarkerColorHighlighted = UIColor.whiteColor()
        let crMarkerNumber = 12
        var crCurrentTurn = 0
        
        // CIRCLE LOADING
        
        let clOutlineWidth: CGFloat = 12.0
        let subClOutLineWidth: CGFloat = 3.0
        let clOutlineFirstRoundColor = UIColor.whiteColor()
        let clOutlineSecondRoundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        let clFps = 60
        var clIsFirstRound = true
        var clCurrentTurn = 0
        
        // BAR LOADING
        
        var style: AnimationStyle? {
            didSet(value) {
                setNeedsDisplay()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clearColor()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func drawRect(rect: CGRect) {
            super.drawRect(rect)
            if(style == nil) { return }
            
            switch style! {
            case .CircleRotating:
                handleCircleRotating(rect)
                break
            case .CircleLoading:
                handleCircleLoading(rect)
                break
            case .BarLoading:
                handleBarLoading(rect)
                break
            }
        }
        
        func handleCircleRotating(rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            
            CGContextSaveGState(context)
            let markerPath = UIBezierPath(roundedRect: CGRect(x: -crMarkerWidth/2, y: 0, width: crMarkerWidth, height: crMarkerHeight), cornerRadius: 6.0)
            
            CGContextTranslateCTM(context, rect.width/2, rect.height/2)
            
            let arcPerMarker = CGFloat((2 * M_PI)/Double(crMarkerNumber))
            
            crCurrentTurn += 1
            if crCurrentTurn > crMarkerNumber { crCurrentTurn = 1 }
            
            for i in 1...crMarkerNumber {
                CGContextSaveGState(context)
                let angle = arcPerMarker * CGFloat(i) - CGFloat(M_PI) - arcPerMarker
                
                CGContextRotateCTM(context, angle)
                CGContextTranslateCTM(context, 0, rect.height/2 - crMarkerHeight - 10)
                
                if(i == crCurrentTurn) { crMarkerColorHighlighted.setFill() }
                else { crMarkerColor.setFill() }
                
                markerPath.fill()
                CGContextRestoreGState(context)
            }
            markerPath.closePath()
            CGContextRestoreGState(context)
        }
        
        func handleCircleLoading(rect: CGRect) {
            
            if(clIsFirstRound) { clOutlineFirstRoundColor.setStroke() }
            else { clOutlineSecondRoundColor.setStroke() }
            
            let arcPerMarker = CGFloat((2 * M_PI)/Double(clFps))
            let pathCenter = CGPoint(x: rect.width/2, y: rect.height/2)
            let radius = min(rect.width/2, rect.height/2) - clOutlineWidth/2 - 5
            let subRadius = radius - 12
            
            clCurrentTurn += 1
            if clCurrentTurn > clFps {
                clCurrentTurn = 1
                clIsFirstRound = !clIsFirstRound
            }
            
            let outlinePath = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(-M_PI/2) + (arcPerMarker*CGFloat(clCurrentTurn)), clockwise: true)
            outlinePath.lineWidth = clOutlineWidth
            outlinePath.stroke()
            outlinePath.closePath()
            
            let subOutlinePath = UIBezierPath(arcCenter: pathCenter, radius: subRadius, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(-M_PI/2) + (arcPerMarker*CGFloat(clCurrentTurn)), clockwise: true)
            subOutlinePath.lineWidth = subClOutLineWidth
            subOutlinePath.stroke()
            subOutlinePath.closePath()
        }
        
        func handleBarLoading(rect: CGRect) {
            
        }
        
    }
    

}
