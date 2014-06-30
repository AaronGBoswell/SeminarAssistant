//
//  CreateSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Henry Boswell on 6/30/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation

import UIKit

class CreateSeminarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButtonClicked(sender : AnyObject) {
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/login.php?Email=)");
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var s = NSString(data: data, encoding: NSUTF8StringEncoding)
            var str:String = s
            println(str)
            if(str.compare("good") == 0){
                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("accountData", sender: self)
                    });
            }
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    var destVC  = segue.destinationViewController as AccountViewController

    }
}