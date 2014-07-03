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
    @IBOutlet var disText : UITextField = nil
    @IBOutlet var csvText : UITextField = nil
    @IBOutlet var doneButton : UIBarButtonItem = nil
    
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
    @IBAction func doneButtonClicked(sender : AnyObject) {
        uuidText.enabled = false
        urlText.enabled = false
        titleText.enabled = false
        disText.enabled = false
        csvText.enabled = false
        doneButton.enabled = false
        newSeminarLabel.text = "Creating..."
        println("creating")
        
        var uuid = uuidText.text
        var title = titleText.text
        var urltxt = urlText.text
        var dis = disText.text
        var csv = ""
        
        var email =  (UIApplication.sharedApplication().delegate as AppDelegate).email
        println(email)
        var ur = "http://www.seminarassistant.com/appinterac/addseminar.php?Email=\(email)&URL=\(urltxt)&UUID=\(uuid)&Title=\(title)&DIS=\(dis)&CSV=\(csv)"
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
                    self.navigationController.popViewControllerAnimated(true)
                    self.navigationController.popViewControllerAnimated(true)
                    for vc : AnyObject in self.navigationController.viewControllers{
                        if vc is AccountViewController{
                            var acViewController = vc as AccountViewController
                            acViewController.clickedSeminar = responseDic[0]
                            
                    
                            acViewController.performSegueWithIdentifier("seminarData", sender: self)
                        }
                    }
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
        
        
        
    }
    
}