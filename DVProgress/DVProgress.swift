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
        case CircleRotation, CircleProcessUnlimited, CircleProcessByValue, BarProcessByValue, TextOnly
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
    
    private var progressStyle: DVProgressStyle = .CircleRotation
    private var messenge: String = ""
    
    private var animate = true
    private var autoHideWhenDone = false
    private let showDuration = 0.3
    private let hideDuration = 0.2
    
    private var animationTimer: NSTimer?
    private let crDuration: NSTimeInterval = 0.1
    private let cpDuration: NSTimeInterval = 1/60
    
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
        
        setupAllComponents()
        show()
    }
    
    init(showCircleRotationInView targetView: UIView, messenge: String?, animate: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = targetView
        self.progressStyle = .CircleRotation
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        setupAllComponents()
        show()
    }
    
    init(showCircleProgressUnlimitedInView targetView: UIView, messenge: String?, animate: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = targetView
        self.progressStyle = .CircleProcessUnlimited
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        setupAllComponents()
        show()
    }
    
    init(showCircleProgressByValueInView targetView: UIView, messenge: String?, animate: Bool, autoHideWhenDone: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = targetView
        self.progressStyle = .CircleProcessByValue
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        self.autoHideWhenDone = autoHideWhenDone
        setupAllComponents()
        show()
    }
    
    init(showBarProgressByValueInView targetView: UIView, messenge: String?, animate: Bool, autoHideWhenDone: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = targetView
        self.progressStyle = .BarProcessByValue
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        self.autoHideWhenDone = autoHideWhenDone
        setupAllComponents()
        show()
    }
    
    init(showTextOnlyInView targetView: UIView, messenge: String?, animate: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.target = targetView
        self.progressStyle = .TextOnly
        if(messenge != "" || messenge != nil) { self.messenge = messenge! }
        self.animate = animate
        setupAllComponents()
        show()
    }
    
    private func setupAllComponents() {
        createContainerView()
        createAnimationView()
        createMessengeTextView()
        
        switch (self.progressStyle) {
        case .CircleRotation:
            handleCircleRotation()
            break
        case .CircleProcessUnlimited:
            handleCircleProcessUnlimited()
            break
        case .CircleProcessByValue:
            handleCircleProcessByValue()
            break
        case .BarProcessByValue:
            handleBarProcessByValue()
            break
        case .TextOnly:
            handleTextOnly()
            break
        }

    }
    
    /////

    private func handleCircleRotation() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.CircleRotation
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(crDuration, target: self, selector: Selector("updateCircleRotation"), userInfo: nil, repeats: true)
    }
    
    private func handleCircleProcessUnlimited() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.CircleProcessUnlimited
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(cpDuration, target: self, selector: Selector("updateCircleProcessUnlimited"), userInfo: nil, repeats: true)
    }
    
    private func handleCircleProcessByValue() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.CircleProcessByValue
    }
    
    private func handleBarProcessByValue() {
        animationView?.style = DVProgress.AnimationView.AnimationStyle.BarProcessByValue
    }
    
    private func handleTextOnly() {
        
    }
    
    // MARK: - UPDATES ANIMATION FOR ANIMATION VIEW
    
    func updateCircleRotation() {
        animationView?.setNeedsDisplay()
    }
    
    func updateCircleProcessUnlimited() {
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
        cView.layer.cornerRadius = 8.0
        cView.translatesAutoresizingMaskIntoConstraints = true
        cView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        view.addSubview(cView)
        containerView = cView
    }
    
    private func createAnimationView() {
        if progressStyle != .TextOnly {
            if progressStyle == .BarProcessByValue {
                containerViewWidth = 220
                containerView.frame.size.width = containerViewWidth
                animationViewWidth = containerViewWidth - 60
                animationViewHeight = 15
                containerView.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
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
        mTextView.font = UIFont(name: "Helvetica", size: 14)
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
                self.shadowView?.alpha = 0.7
                self.containerView.alpha = 1
                }, completion: { finished in
        
            })
        } else {
            self.shadowView?.alpha = 0.7
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
    
    func updateCircleProcessByValue(value: Int) {
        if(progressStyle != DVProgressStyle.CircleProcessByValue) { return }
        animationView?.updateCurrentValueForCircleProcess(value, completion: { finished in
            if(finished==true && self.autoHideWhenDone==true) {
                self.hide()
            }
        })
    }
    
    func updateBarProcessByValue(value: Int) {
        if(progressStyle != DVProgressStyle.BarProcessByValue) { return }
        animationView?.updateCurrentValueForBarProcess(value, completion:  { finished in
            if(finished && self.autoHideWhenDone) {
                self.hide()
            }
        })
    }
    
    ////////////////////////////
    // MARK: - UIVIEW CLASSES
    ////////////////////////////
    
    class AnimationView: UIView {
        
        enum AnimationStyle {
            case CircleRotation, CircleProcessUnlimited, CircleProcessByValue, BarProcessUnlimited, BarProcessByValue, TextOnly
        }
        
        var style: AnimationStyle? {
            didSet(value) {
                setNeedsDisplay()
            }
        }
        
        // MARK: - VARIABLES
        
        // CIRCLE ROTATION
        
        private let crMarkerWidth: CGFloat = 5.0
        private let crMarkerHeight: CGFloat = 12.0
        private let crMarkerColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        private let crMarkerColorHighlighted = UIColor.whiteColor()
        private let crMarkerNumber = 12
        private var crCurrentTurn = 0
        
        // CIRCLE PROCESS
        
        private let cpOutlineWidth: CGFloat = 12.0
        private let cpSubOutLineWidth: CGFloat = 3.0
        private let cpOutlineFirstRoundColor = UIColor.whiteColor()
        private let cpOutlineSecondRoundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        private let cpSecondOutlineFirstRoundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        private let cpSecondOutlineSecondRoundColor = UIColor.whiteColor()
        private let cpMaxValue: CGFloat = 100
        private let cpMinValue: CGFloat = 1
        private var cpCurrentValue: CGFloat = 1
        private var cpIsFirstRound = true
        
        // BAR PROCESS
        
        private let bpOutlineWidth: CGFloat = 1.0
        private let bpOutlineColor = UIColor.whiteColor()
        private let bpInlineColor = UIColor.whiteColor()
        private let bpMinValue: CGFloat = 0.0
        private let bpMaxValue: CGFloat = 100.0
        private var bpCurrentValue: CGFloat = 0.0
        
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
            case .CircleRotation:
                handleCircleRotation(rect)
                break
            case .CircleProcessUnlimited:
                handleCircleProcess(rect)
                break
            case .CircleProcessByValue:
                handleCircleProcess(rect)
            case .BarProcessByValue:
                handleBarProcessByValue(rect)
                break
            default:
                break
            }
            
        }
        
        // MARK: - HANDLE CIRCLE ROTATION
        
        private func handleCircleRotation(rect: CGRect) {
            if (style != DVProgress.AnimationView.AnimationStyle.CircleRotation) { return }
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
        
        // MARK: - HANDLE CIRCLE PROCESS
        
        private func handleCircleProcess(rect: CGRect) {
            if (style != DVProgress.AnimationView.AnimationStyle.CircleProcessUnlimited && style != DVProgress.AnimationView.AnimationStyle.CircleProcessByValue) { return }
            let arcPerMarker = CGFloat((2 * M_PI)/Double(cpMaxValue))
            let pathCenter = CGPoint(x: rect.width/2, y: rect.height/2)
            let radius = min(rect.width/2, rect.height/2) - cpOutlineWidth/2 - 10
            let subRadius = radius - 12
            
            if (style == DVProgress.AnimationView.AnimationStyle.CircleProcessUnlimited) {
                cpCurrentValue += 1
                if cpCurrentValue >= cpMaxValue {
                    cpCurrentValue = cpMinValue
                    cpIsFirstRound = !cpIsFirstRound
                }
            }
            
            let startAngle = CGFloat(-M_PI/2)
            let endAngle = CGFloat(-M_PI/2) + (arcPerMarker*CGFloat(cpCurrentValue))
            
            
            if(cpIsFirstRound) { cpOutlineFirstRoundColor.setStroke() }
            else { cpOutlineSecondRoundColor.setStroke() }
            
            let outlinePath = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            outlinePath.lineWidth = cpOutlineWidth
            outlinePath.stroke()
            outlinePath.closePath()
            
            let subOutlinePath = UIBezierPath(arcCenter: pathCenter, radius: subRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            subOutlinePath.lineWidth = cpSubOutLineWidth
            subOutlinePath.stroke()
            subOutlinePath.closePath()
            
            if(cpIsFirstRound) { cpSecondOutlineFirstRoundColor.setStroke() }
            else { cpSecondOutlineSecondRoundColor.setStroke() }
            
            if (cpCurrentValue < cpMaxValue) {
                let secondOutlinePath = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
                secondOutlinePath.lineWidth = cpOutlineWidth
                secondOutlinePath.stroke()
                secondOutlinePath.closePath()
            
                let secondSubOutlinePath = UIBezierPath(arcCenter: pathCenter, radius: subRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
                secondSubOutlinePath.lineWidth = cpSubOutLineWidth
                secondSubOutlinePath.stroke()
                secondSubOutlinePath.closePath()
            }
            
        }
        
        func updateCurrentValueForCircleProcess(value: Int, completion: (Bool)->()) {
            cpCurrentValue = CGFloat(value)
            if cpCurrentValue >= cpMaxValue { cpCurrentValue = cpMaxValue }
            setNeedsDisplay()
            if cpCurrentValue == cpMaxValue { completion(true) }
            else { completion(false) }
        }
        
        // MARK: - HANDLE BAR LOADING
        
        private func handleBarProcessByValue(rect: CGRect) {
            
            if (style != DVProgress.AnimationView.AnimationStyle.BarProcessByValue) { return }
            
            self.layer.borderWidth = bpOutlineWidth
            self.layer.borderColor = bpOutlineColor.CGColor
            self.layer.cornerRadius = 8.0
            
            var distanceToGo = (rect.width/bpMaxValue) * bpCurrentValue - (2*bpOutlineWidth)
            if distanceToGo < 0 { distanceToGo = 0 }
            
            let linePath = UIBezierPath(roundedRect: CGRect(x: bpOutlineWidth, y: bpOutlineWidth, width: distanceToGo, height: rect.height - (2*bpOutlineWidth)), cornerRadius: 5.0)
            bpInlineColor.setFill()
            linePath.fill()
            linePath.closePath()
            
        }
        
        func updateCurrentValueForBarProcess(value: Int, completion: (Bool)->()) {
            bpCurrentValue = CGFloat(value)
            if(bpCurrentValue >= bpMaxValue) { bpCurrentValue = bpMaxValue }
            setNeedsDisplay()
            if bpCurrentValue == bpMaxValue {
                completion(true)
            }
            else { completion(false) }
        }
    }
    

}
