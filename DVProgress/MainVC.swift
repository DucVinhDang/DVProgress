//
//  MainVC.swift
//  DVProgress
//
//  Created by Đặng Vinh on 12/2/15.
//  Copyright © 2015 Đặng Vinh. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var progress: DVProgress?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCircleRotating(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.CircleRotating, messenge: "Hello, this is a progress view", animate: true)
    }
    
    @IBAction func handleCircleLoading(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.CircleLoading, messenge: "Hello, this is a progress view", animate: true)
    }
    
    @IBAction func handleBarLoading(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.BarLoading, messenge: "Hello, this is a progress view", animate: true)
    }
    
    @IBAction func handleTextOnly(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.TextOnly, messenge: "Hello, this is a progress view", animate: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
