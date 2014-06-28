//
//  AccountViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell and Henry Boswell on 6/27/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//  SeminarCell

import Foundation
import UIKit

class AccountViewController: UITableViewController {
    
    var email:String = "henry@lakejoe.com"
    var seminars:NSDictionary[] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
      getSeminars()
        
        
    }
    
    
    func  getSeminars(){
    print("ran")
        
    var url = NSURL(string: "http://www.seminarassistant.com/appinterac/returntitles.php?Email=\(email)");
    let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
      
        var jsonArray:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary[]

        
        for obj in jsonArray{
            var dic = obj as NSDictionary
            var title:String = dic.valueForKey("Title") as String
            print("Adding: ")
            
            print((dic.valueForKey("Title")))

        }
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
            self.seminars = jsonArray
            self.tableView.reloadData()
            
            
            
        });
    
        
        
    }
    task.resume()
    
        
    
       
    }

    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        /*
        var ident = "nearbySeminar";
        var cell = seminarTable.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
        }
        var title = searchSeminarArray[indexPath.row].valueForKey("Title") as String
        cell.textLabel.text = title
        return cell
        
        */
        return nil
        
    }
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        /*
        var x = 0
        //nearBySeminars = []
        for dic in searchSeminarArray{
            if dic.valueForKey("count") as Int > 0{
                nearBySeminars.append(dic)
                x++
            }
        }
        println(x)
        return x

*/
        return 0
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        //selectSeminar(nearBySeminars[indexPath.row])
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

