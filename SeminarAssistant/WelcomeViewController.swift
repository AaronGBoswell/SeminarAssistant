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
    @IBOutlet var loginButton : UIButton = nil
    @IBOutlet var submitButton : UIButton = nil
    @IBOutlet var passwordText : UITextField = nil
    @IBOutlet var adminButton : UIButton = nil
    @IBOutlet var signUpButton : UIButton = nil
    
    var adminMode = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.secureTextEntry = true
        emailTextView.keyboardType = UIKeyboardType.EmailAddress
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
        else if(identifier.compare("showSignUp") == 0){
            return true
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
    @IBAction func adminButtonClicked(sender : AnyObject) {

        adminButton.hidden = true
        signUpButton.hidden = false
        emailLabel.text = "Enter email and password"
        passwordText.hidden = false
        loginButton.hidden = false;
        submitButton.hidden = true;
        adminMode = 1;
    }
    
    @IBAction func loginButtonClicked(sender : AnyObject) {
        
        emailLabel.text = "Authenticating, please wait..."
        passwordText.enabled = false
        emailTextView.enabled = false
        loginButton.enabled = false
        var email = emailTextView.text
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/login.php?Email=\(email)&pass=\(passwordText.text)");
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
        if(segue.destinationViewController is UINavigationController){
            var destVC:AnyObject?  = (segue.destinationViewController as UINavigationController).viewControllers[0]
            if(destVC is AccountViewController){
                var dvc = destVC as AccountViewController
                dvc.email = emailTextView.text
                (UIApplication.sharedApplication().delegate as AppDelegate).email = emailTextView.text
                (UIApplication.sharedApplication().delegate as AppDelegate).startFetches()
                (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = dvc
                (UIApplication.sharedApplication().delegate as AppDelegate).bND = dvc
            }
        }
        if(segue.destinationViewController is PleaseWaitViewController){
            var destVC  = segue.destinationViewController as PleaseWaitViewController
            destVC.email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).bND = destVC
            (UIApplication.sharedApplication().delegate as AppDelegate).email = emailTextView.text
            (UIApplication.sharedApplication().delegate as AppDelegate).startFetches()
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC

        }
        if(segue.destinationViewController is SignUpViewController){
            var destVC  = segue.destinationViewController as SignUpViewController
            destVC.wel = self
        }
    }

}

