//
//  AccountViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell and Henry Boswell on 6/27/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//  SeminarCell

import Foundation
import UIKit

class AccountViewController: UIViewController,BeaconNotificationDelegate {
    
    var seminars:NSDictionary[] = []
    @IBOutlet var tableView : UITableView = nil
    @IBOutlet var accountSubTitleText : UILabel
    var clickedSeminar:NSDictionary = NSDictionary()
    var email:String = ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bbbi = UIBarButtonItem()
        bbbi.title = "Account"
        navigationItem.backBarButtonItem = bbbi
    }
    override func viewWillAppear(animated: Bool){
        println(email)
        getSeminars()
    }
    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        
        
        var deleteID = seminars[indexPath.row].valueForKey("ID") as String
        
        seminars.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/deleteseminar.php?ID=\(deleteID)")
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL((url), {(data, response, error) in
            println("task")
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                
                println("task")
                
                self.getSeminars()
                });
            })
        task.resume()
        println("resumed")
        println("deleted")
    }
    

    
    func  getSeminars(){
        print("ran")
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/returntitles.php?Email=\(email)");
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
      
            var jsonArray:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary[]

        
            for obj in jsonArray{
                var dic = obj as NSDictionary
                var title:String = dic.valueForKey("Title") as String
                var ID:String = dic.valueForKey("ID") as String
                print("Adding: ")
            
                println((dic.valueForKey("Title")))

            }
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                self.seminars = jsonArray
                self.tableView.reloadData()
            
            
            
            });
    
        
        
        }
        task.resume()
    
        
    
       
    }

    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        
        var ident = "SeminarCell";
        var cell = self.tableView.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        var title = seminars[indexPath.row].valueForKey("Title") as String
        cell.textLabel.text = title
        return cell
        
        
        
        
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        
        var x = 0
       
        x = seminars.count
        println(x)
        return x


    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        selectSeminar(seminars[indexPath.row])
    }
    
    
    func selectSeminar(cs:NSDictionary){
        
        //activityMoniter.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        //activityMoniter.color = UIColor.darkGrayColor()
        //searchTitle.text = "Checking you in, please wait..."
        
        clickedSeminar = cs
        self.performSegueWithIdentifier("seminarData", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.destinationViewController is SeminarViewController){
            var destVC  = segue.destinationViewController as SeminarViewController
            println(clickedSeminar)
            destVC.email = clickedSeminar.valueForKey("Owner") as String
            destVC.ID = clickedSeminar.valueForKey("ID") as String;
            destVC.titlePassed = clickedSeminar.valueForKey("Title") as String
            destVC.URL = clickedSeminar.valueForKey("URL") as String
            destVC.DIS = clickedSeminar.valueForKey("DIS") as String
            destVC.UUID = clickedSeminar.valueForKey("UUID") as String
            destVC.dateTime = clickedSeminar.valueForKey("dateTime") as String
            //destVC.Time = clickedSeminar.valueForKey("Time") as String
            destVC.Location = clickedSeminar.valueForKey("Location") as String
            var bbbi = UIBarButtonItem()
            bbbi.title = "Account"
            navigationItem.backBarButtonItem = bbbi
        } else if(segue.destinationViewController is PleaseWaitViewController){
            var destVC  = segue.destinationViewController as PleaseWaitViewController
            destVC.email = email
            (UIApplication.sharedApplication().delegate as AppDelegate).bND = destVC
            (UIApplication.sharedApplication().delegate as AppDelegate).email = email
            (UIApplication.sharedApplication().delegate as AppDelegate).startFetches()
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            var bbbi = UIBarButtonItem()
            bbbi.title = "Account"
            navigationItem.backBarButtonItem = bbbi

        }
        else{
            var bbbi = UIBarButtonItem()
            bbbi.title = "Cancel"
            navigationItem.backBarButtonItem = bbbi
        }

    }

    

    func didEnterSeminar(seminar:NSDictionary, seminarArray:NSDictionary[]){
    }
    func didExitSeminar(seminar:NSDictionary,seminarArray:NSDictionary[]){
    }
    func didUpdateSeminarList(seminarArray:NSDictionary[]){
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

