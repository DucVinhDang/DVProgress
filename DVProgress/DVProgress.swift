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
    weak var animationView: AnimationView!
    weak var messengeTextView: UITextView?
    weak var target: UIView!
    weak var shadowView: UIView?
    
    private let deviceWidth = UIScreen.mainScreen().bounds.width
    private let deviceHeight = UIScreen.mainScreen().bounds.height
    private var containerViewWidth: CGFloat = 160
    private var containerViewHeight: CGFloat = 160
    private var animationViewWidth: CGFloat = 80
    private var animationViewHeight: CGFloat = 80
    private let containerViewPadding: CGFloat = 10
    private var distanceBetweenAnimationViewAndMessengeTextView: CGFloat = 10
    
    private var progressStyle: DVProgressStyle = .CircleRotating
    private var messenge: String = ""
    
    private var animate = true
    
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
        
    }
    
    private func handleCircleLoading() {
        
    }
    
    private func handleBarLoading() {
        
    }
    
    private func handleTextOnly() {
        
    }
    
    // MARK: - SETUPS/CREATES/REMOVES VIEW METHODS
    
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
        view.addSubview(cView)
        containerView = cView
    }
    
    private func createAnimationView() {
        if progressStyle != .TextOnly {
            if progressStyle == .BarLoading { animationViewHeight = 40 }
            let aView = AnimationView(frame: CGRect(x: (containerViewWidth - animationViewWidth)/2, y: containerViewPadding, width: animationViewWidth, height: animationViewHeight))
            aView.backgroundColor = UIColor.yellowColor()
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
        mTextView.text = messenge
        
        let newSize = mTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        mTextView.frame.size.height = newSize.height
        
        containerView.addSubview(mTextView)
        messengeTextView = mTextView
        
        let valueChangeHeight = (CGRectGetMaxY(mTextView.frame) + containerViewPadding) - containerViewHeight
        updateContainerViewHeightByValue(valueChangeHeight)
        
    }
    
    private func createShadowView() {
        let sView = UIView(frame: view.frame)
        sView.backgroundColor = UIColor.blackColor()
        sView.layer.zPosition = -5
        view.addSubview(sView)
        shadowView = sView
    }
    
    // MARK: - SHOWS/HIDES VIEW METHODS
    
    private func show() {
        if(target == nil) { return }
        target.addSubview(self.view)
        
        shadowView?.alpha = 0
        containerView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            self.shadowView?.alpha = 0.8
            self.containerView.alpha = 1
            }, completion: { finished in
        
        })
    }
    
    private func hide() {
        
    }
    
    // MARK: - SUPPORTING METHODS
    
    private func updateContainerViewHeightByValue(value: CGFloat) {
        if (containerView != nil) { containerView.frame.size.height += value }
    }
    
    // MARK: - UIVIEW CLASSES
    
    class AnimationView: UIView {
        
        
        
        override func drawRect(rect: CGRect) {
            super.drawRect(rect)
            
            
        }
    }
    

}
