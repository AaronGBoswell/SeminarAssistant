//
//  SeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/27/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class SeminarViewController: UITableViewController {
    
    
    var email:String = "henry@lakejoe.com"
    var ID:String = "1"
    var clickedSeminar:NSDictionary = NSDictionary()
    var invites:NSDictionary[] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInvites()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func  getInvites(){
        print("ran")
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/returninvitees.php?ID=\(ID)");
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            
            var jsonArray:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary[]
            
            
            for obj in jsonArray{
                var dic = obj as NSDictionary
                var Email:String = dic.valueForKey("Email") as String
                var CheckedIn:String = dic.valueForKey("CheckedIn") as String
                print("Adding: ")
                
                print((dic.valueForKey("Email")))
                
            }
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                self.invites = jsonArray
                self.tableView.reloadData()
                
                
                
                });
            
            
            
        }
        task.resume()
        
        
        
        
    }
    
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        
        var ident = "inviteSeminar";
        var cell = self.tableView.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        var title = invites[indexPath.row].valueForKey("Email") as String
        cell.textLabel.text = title
        return cell
        
        
        
        
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        
        var x = 0
        
        x = invites.count
        println(x)
        return x
        
        
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        selectSeminar(invites[indexPath.row])
    }
    
    
    func selectSeminar(cs:NSDictionary){
        
        //activityMoniter.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        //activityMoniter.color = UIColor.darkGrayColor()
        //searchTitle.text = "Checking you in, please wait..."
        
        clickedSeminar = cs
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}