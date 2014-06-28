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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is PleaseWaitViewController){
            var destVC  = segue.destinationViewController as PleaseWaitViewController
            (UIApplication.sharedApplication().delegate as AppDelegate).bND = destVC
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC

        }
    }
    
}