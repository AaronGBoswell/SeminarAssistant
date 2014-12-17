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

    var x:Int?

    @IBOutlet var newSeminarLabel : UILabel! = nil
    @IBOutlet var uuidText : UITextField! = nil
    @IBOutlet var urlText : UITextField! = nil
    @IBOutlet var titleText : UITextField! = nil
    @IBOutlet var disText : UITextView! = nil
    @IBOutlet var dateDecider : UIDatePicker!
    @IBOutlet var locationText : UITextField!
    
    @IBOutlet var doneButton : UIBarButtonItem! = nil
    var clickedSeminar : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disText.editable = true

        // Do any additional setup after loading the view, typically from a nib.
    
    
    
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
        myAlertView.message = "This is your iBeacon's unique identifier. If you find yourself without an iBeacon press the \"G\" to generate one. Your phone can later use this generated UUID to be an iBeacon itself. "
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
    @IBAction func titleInfo(sender : AnyObject) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = "Seminar Title"
        myAlertView.message = "This is the title of your seminar, it will be visible by all attendees as they recieve invites."
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()
    }
    @IBAction func locInfo(sender : AnyObject) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = "Location"
        myAlertView.message = "This is the location of your seminar, it will be visible by all atendees."
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()
    }
    @IBAction func disInfo(sender : AnyObject) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = "Description"
        myAlertView.message = "This is the description of your seminar, it makes up the body on an email that is autosent to all invitees"
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func genButtonClicked(sender : AnyObject) {
        var nsuuid = NSUUID()
        var id = nsuuid.UUIDString
        uuidText.text = id
    }
    func stringIsValidEmail(email:String) -> Bool{
        var emailRegex = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    @IBAction func doneButtonClicked(sender : AnyObject) {
        uuidText.enabled = false
        urlText.enabled = false
        titleText.enabled = false
        disText.editable = false
        doneButton.enabled = false
        newSeminarLabel.text = "Creating..."
        println("creating")
        
        var uuid = uuidText.text
        var title = titleText.text
        var urltxt = urlText.text
        var dis = disText.text
        var loc = locationText.text
        var date = dateDecider.date
        
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
            else{
                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    self.newSeminarLabel.text = str
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
    
}