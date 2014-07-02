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
    var clickedSeminar:NSDictionary = NSDictionary()
    var email:String = ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            var seminarID:String = clickedSeminar.valueForKey("ID") as String;
            destVC.email = email
            destVC.ID = seminarID
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

