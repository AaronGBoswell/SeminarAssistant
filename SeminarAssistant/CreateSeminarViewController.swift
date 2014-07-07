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

    @IBOutlet var newSeminarLabel : UILabel = nil
    @IBOutlet var uuidText : UITextField = nil
    @IBOutlet var urlText : UITextField = nil
    @IBOutlet var titleText : UITextField = nil
    @IBOutlet var disText : UITextView = nil
    
    @IBOutlet var doneButton : UIBarButtonItem = nil
    var clickedSeminar : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disText.editable = true

        // Do any additional setup after loading the view, typically from a nib.
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
        
        var email =  (UIApplication.sharedApplication().delegate as AppDelegate).email
        println(email)
        var ur = "http://www.seminarassistant.com/appinterac/addseminar.php?Email=\(email)&URL=\(urltxt)&UUID=\(uuid)&Title=\(title)&DIS=\(dis)"
        ur = ur.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        var url = NSURL(string: ur)
        println(ur)


        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var s = NSString(data: data, encoding: NSUTF8StringEncoding)
            var str:String = s
            //finish line below
            var responseDic:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary[]
            
            
           // var jsonArray:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: //nil) as NSDictionary[]
            
            
            for obj in responseDic{
                var dic = obj as NSDictionary
            }
    
            println(responseDic)
            if(str.compare("") != 0){
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
            navigationItem.backBarButtonItem = nil
        }
        
        
    }
    
}