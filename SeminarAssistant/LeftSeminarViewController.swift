//
//  LeftSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/26/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class LeftSeminarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func leaveButtonClicked(sender : AnyObject) {
        for vc in navigationController!.viewControllers{
            if vc is PleaseWaitViewController{
                navigationController!.popToViewController(vc as UIViewController, animated: true)
            }
        }
    }
    
}