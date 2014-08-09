//
//  SignUpViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/30/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var firstNameText : UITextField! = nil
    @IBOutlet var lastNameText : UITextField! = nil
    @IBOutlet var emailText : UITextField! = nil
    @IBOutlet var passwordText : UITextField! = nil
    @IBOutlet var confirmPasswordText : UITextField! = nil
    @IBOutlet var signUpButton : UIButton! = nil
    @IBOutlet var titleLabel : UILabel! = nil
    
    var wel:WelcomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.secureTextEntry = true
        confirmPasswordText.secureTextEntry = true
        emailText.keyboardType = UIKeyboardType.EmailAddress
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func stringIsValidEmail(email:String) -> Bool{
        var emailRegex = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    @IBAction func signUpButtonClicked(sender : AnyObject) {
        
        if !stringIsValidEmail(emailText.text){
            titleLabel.text = "Enter a valid Email"

            return
        }
        if(confirmPasswordText.text != passwordText.text){
            titleLabel.text = "Passwords do not match"

            return
        }
        
        titleLabel.text = "Signing you up..."
        passwordText.enabled = false
        firstNameText.enabled = false
        emailText.enabled = false
        confirmPasswordText.enabled = false
        lastNameText.enabled = false
        signUpButton.enabled = false
        

        var fname = firstNameText.text
        var lname = lastNameText.text
        var email = emailText.text

        var password = passwordText.text
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/signup.php?Email=\(email)&pass=\(password)&fname=\(fname)&lname=\(lname)".stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding))

        println(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var s = NSString(data: data, encoding: NSUTF8StringEncoding)
            var str:String = s
            println(str)
            if(str == "good"){
                println("g")

                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    self.wel!.emailTextView.text = email
                    self.wel!.passwordText.text = password
                    self.navigationController.popViewControllerAnimated(true)
                });
            }
            else{
                println("b")

                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    self.titleLabel.text = str
                    self.passwordText.enabled = true
                    self.firstNameText.enabled = true
                    self.emailText.enabled = true
                    self.confirmPasswordText.enabled = true
                    self.lastNameText.enabled = true
                   self.signUpButton.enabled = true
                });
            }
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is WelcomeViewController){
            print("yeah")
        }
   
    }
    
}