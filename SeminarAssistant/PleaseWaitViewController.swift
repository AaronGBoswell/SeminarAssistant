//
//  PleaseWaitViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/25/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

class PleaseWaitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,BeaconNotificationDelegate {
    
    @IBOutlet var searchTitle : UILabel = nil
    @IBOutlet var activityMoniter : UIActivityIndicatorView = nil
    @IBOutlet var seminarTable : UITableView = nil
    
    var email:String = "aaron@lakejoe.com"
    var currRegion:NSDictionary? = nil
    
    var searchSeminarArray:NSDictionary[] = []
    var nearBySeminars:NSDictionary[] = []


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if(identifier.compare("LeaveSeminar") == 0){
            return false
        }
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if(segue.destinationViewController is InSeminarViewController){
            var destVC  = segue.destinationViewController as InSeminarViewController
            var mDic:NSMutableDictionary = currRegion!.mutableCopy() as NSMutableDictionary
            mDic.setValue(email, forKey:"Email")
            destVC.regDic = mDic
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var ident = "nearbySeminar";
        var cell = seminarTable.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
        }
        var title = nearBySeminars[indexPath.row].valueForKey("Title") as String
        cell.textLabel.text = title
        return cell
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        var x = 0
        nearBySeminars = []
        for dic in searchSeminarArray{
            if dic.valueForKey("count") as Int > 0{
                nearBySeminars.append(dic)
                x++
            }
        }
        println(nearBySeminars)
        return x
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        selectSeminar(nearBySeminars[indexPath.row])
    }
    
    
    
    
    func selectSeminar(selSem:NSDictionary){
        
        activityMoniter.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityMoniter.color = UIColor.darkGrayColor()
        searchTitle.text = "Checking you in, please wait..."
        currRegion = selSem
        var seminarID:String = selSem.valueForKey("ID") as String;
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/authenticate.php?SeminarID=\(seminarID)&Email=\(email)");
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("CheckIn", sender: self)
                });
        }
        task.resume()
        
        
    }

    
    func didEnterSeminar(seminar:NSDictionary, seminarArray:NSDictionary[]){
       searchTitle.text = "Please select nearby seminar"

        searchSeminarArray = seminarArray
        seminarTable.reloadData()
    }
    func didExitSeminar(seminar:NSDictionary,seminarArray:NSDictionary[]){
        searchTitle.text = "Searching for nearby seminars"
        searchSeminarArray = seminarArray
        seminarTable.reloadData()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}