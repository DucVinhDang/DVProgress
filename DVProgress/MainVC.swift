//
//  MainVC.swift
//  DVProgress
//
//  Created by Đặng Vinh on 12/2/15.
//  Copyright © 2015 Đặng Vinh. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let progress = DVProgress(showInView: self.view, style: DVProgress.DVProgressStyle.CircleLoading, messenge: "Hello, this is a progress view", animate: true)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
