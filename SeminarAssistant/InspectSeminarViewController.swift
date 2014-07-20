//
//  InspectSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 7/8/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
class InspectSeminarViewController: UIViewController {
    
    @IBOutlet var activityMoniter : UIActivityIndicatorView = nil
    @IBOutlet var locationLabel : UILabel = nil
    @IBOutlet var timeLabel : UILabel = nil
    @IBOutlet var descriptionView : UITextView = nil
    @IBOutlet var checkInButton : UIButton = nil
    var seminar:NSDictionary?
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInButton.enabled = false
        println(seminar!)
        navigationItem.title = seminar!.valueForKey("Title") as String
        println(seminar!.valueForKey("Title") as String)
        
        locationLabel.text = "Location: " + (seminar!.valueForKey("Location") as String)
        descriptionView.text = seminar!.valueForKey("DIS") as String
        
        
        id = seminar!.valueForKey("ID") as String
        var form = NSDateFormatter()
        form.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = form.dateFromString(seminar!.valueForKey("dateTime") as String)
        
        var f = NSDateFormatter()
        f.dateStyle = NSDateFormatterStyle.MediumStyle
        f.timeStyle = NSDateFormatterStyle.ShortStyle
        timeLabel.text = "Date/Time: " + f.stringFromDate(date)
        
        if(seminar!.valueForKey("count") as Int > 0){
            inRange()
        }
    }
    @IBAction func checkInButtonClicked(sender : AnyObject) {
        checkIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is PleaseWaitViewController){
            var destVC  = segue.destinationViewController as PleaseWaitViewController
            destVC.displayedSeminar = nil
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            
        }
        if(segue.destinationViewController is InSeminarViewController){
            var destVC  = segue.destinationViewController as InSeminarViewController
            destVC.regDic = seminar!
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            
        }
    }
    func inRange(){
        checkInButton.enabled = true

    }
    func outRange(){
        checkInButton.enabled = false

    }
    func checkIn(){
        self.activityMoniter.startAnimating()
        
        navigationItem.title = "Checking in, please wait..."
        var selSem = seminar!
        var seminarID:String = selSem.valueForKey("ID") as String;
        var email:String = selSem.valueForKey("Email") as String;

        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/authenticate.php?SeminarID=\(seminarID)&Email=\(email)");
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                
                self.performSegueWithIdentifier("CheckIn", sender: self)
                self.activityMoniter.stopAnimating()
                
                });
        }
        task.resume()
        
        
    }
    
    
}