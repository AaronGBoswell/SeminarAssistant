//
//  ViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/25/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var emailTextView : UITextField = nil
    @IBOutlet var emailLabel : UILabel = nil
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if(identifier.compare("LeaveSeminar") == 0){
            return false
        }
        else if(stringIsValidEmail(emailTextView.text)){
            return true
        }
        else{
            emailLabel.text = "Please enter a valid email address"
            return false
        }
    }
    func stringIsValidEmail(email:String) -> Bool{
        var emailRegex = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is PleaseWaitViewController){
            var destVC  = segue.destinationViewController as PleaseWaitViewController
            destVC.email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).pwvc = destVC
            (UIApplication.sharedApplication().delegate as AppDelegate).email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).startFetches()
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC

        }
        if(segue.destinationViewController is AccountViewController){
            var destVC  = segue.destinationViewController as AccountViewController
            destVC.email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).startFetches()
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            
        }
    }

}

