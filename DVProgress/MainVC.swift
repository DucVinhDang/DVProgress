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
    
    @IBAction func handleCircleRotation(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.CircleRotation, messenge: "Waiting for server", animate: true)
        delay(5, closure: {
            self.progress?.hide(animate: true)
        })
    }
    
    @IBAction func handleCircleProcessUnlimited(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.CircleProcessUnlimited, messenge: "Loading...", animate: true)
        delay(10, closure: {
            self.progress?.hide(animate: true)
        })
    }
    
    @IBAction func handleBarProcessByValue(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.BarProcessByValue, messenge: "Bar Loading", animate: true)
        delay(3, closure: {
            self.progress?.hide(animate: true)
        })
    }
    
    @IBAction func handleTextOnly(sender: AnyObject) {
        progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.TextOnly, messenge: "Hello, this is a progress view", animate: true)
        delay(3, closure: {
            self.progress?.hide(animate: true)
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
