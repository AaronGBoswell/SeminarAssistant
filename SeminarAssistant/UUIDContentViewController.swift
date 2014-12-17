//
//  UUIDContentViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 7/29/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class UUIDContentViewController: UIViewController  {
    
    @IBOutlet var uuidText : UITextField! = nil
    @IBOutlet var contentURLText : UITextField! = nil
    @IBOutlet var doneButton : UIBarButtonItem! = nil
    @IBOutlet var genButton : UIButton! = nil
    @IBOutlet var infoButton : UIButton! = nil
    @IBOutlet var infoButton2 : UIButton! = nil
    
    var seminarInfo = NSDictionary()
    var clickedSeminar : NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: "dismisss")
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        dismisss()
    }
    func dismisss(){
        view.endEditing(true)
    }
    
    @IBAction func uuidInfo(sender : AnyObject) {
        
        var myAlertView = UIAlertView()
        
        myAlertView.title = "iBeacon UUID"
        myAlertView.message = "This is your iBeacon's unique identifier. If you find yourself without an iBeacon press the \"Generate\" to generate one. Your phone can later use this generated UUID to be an iBeacon itself. "
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()
    }
    @IBAction func urlInfo(sender : AnyObject) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = "Content URL"
        myAlertView.message = "This is where the information you wish to share with your attendees is stored. As they check in it will automatically be displayed to them within the app."
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()
    }

    @IBAction func genButtonClicked(sender : AnyObject) {
        var nsuuid = NSUUID()
        var id = nsuuid.UUIDString
        uuidText.text = id
    }
    
    
    @IBAction func doneButtonClicked(sender : AnyObject) {
        uuidText.enabled = false
        contentURLText.enabled = false
        doneButton.enabled = false
        genButton.enabled = false
        infoButton.enabled = false
        infoButton2.enabled = false
        navigationItem.title = "Creating..."

        println("creating")
        
        var uuid = uuidText.text as String
        var urltxt = contentURLText.text as String
        println(seminarInfo)
        var dis = seminarInfo.valueForKey("DIS") as String
        println(dis)
        var loc = seminarInfo.valueForKey("Location") as String
        println(loc)
        var date: AnyObject! = seminarInfo.valueForKey("dateTime")
        println(date)
        var title = seminarInfo.valueForKey("Title") as String
        println(title)
        
        var email =  (UIApplication.sharedApplication().delegate as AppDelegate).email
        println(email)
        var ur = "http://www.seminarassistant.com/appinterac/addseminar.php?Email=\(email)&URL=\(urltxt)&UUID=\(uuid)&Title=\(title)&DIS=\(dis)&LOC=\(loc)&DT=\(date) "
        ur = ur.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!
        var url = NSURL(string: ur)
        println(ur)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var s = NSString(data: data, encoding: NSUTF8StringEncoding)
            var str:String = s
            //finish line below
            var responseDic:[NSDictionary] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as [NSDictionary]
            
            
            
            for obj in responseDic{
                var dic = obj as NSDictionary
            }
            
            println(responseDic)
            if(str != ""){
                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    
                    self.clickedSeminar = responseDic[0]
                    self.performSegueWithIdentifier("creatingNewSeminar", sender: self)
                    
                    });
            }

        }
        task.resume()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is SeminarViewController){
            var destVC  = segue.destinationViewController as SeminarViewController
            println(clickedSeminar)
            destVC.email = clickedSeminar!.valueForKey("Owner") as String
            destVC.ID = clickedSeminar!.valueForKey("ID") as String;
            destVC.titlePassed = clickedSeminar!.valueForKey("Title") as String
            destVC.URL = clickedSeminar!.valueForKey("URL") as String
            destVC.DIS = clickedSeminar!.valueForKey("DIS") as String
            destVC.UUID = clickedSeminar!.valueForKey("UUID") as String
            destVC.dateTime = clickedSeminar!.valueForKey("dateTime") as String
            destVC.Location = clickedSeminar!.valueForKey("Location") as String
            navigationItem.backBarButtonItem = nil
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
