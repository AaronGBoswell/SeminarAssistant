//
//  CreateSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/30/14.
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
    
    func stringIsValidEmail(email:String) -> Bool{
        var emailRegex = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
//    @IBAction func signUpButtonClicked(sender : AnyObject) {
//        
//        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/signup.php?Email=\(email)&pass=\(password)&fname=\(fname)&lname=\(lname)");
//        println(url)
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            var s = NSString(data: data, encoding: NSUTF8StringEncoding)
//            var str:String = s
//            println(str)
//            if(str.compare("good") == 0){
//                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
//                    self.wel!.emailTextView.text = email
//                    self.wel!.passwordText.text = password
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    });
//            }
//            else{
//                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
//                    self.titleLabel.text = str
//                    });
//            }
//        }
//        task.resume()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
    }
    
}