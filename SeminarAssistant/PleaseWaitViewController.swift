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
    
    var email:String = ""
    var currRegion:NSDictionary? = nil
    
    var spoof:NSDictionary[] = []

    var searchSeminarArray:NSDictionary[]{
        get{
            return spoof
        }
        set{
            spoof = sort(newValue, { (d1: NSDictionary, d2: NSDictionary) -> Bool in
                if(d1.valueForKey("count") as Int > d2.valueForKey("count") as Int ){
                    return true
                }
                else if((d1.valueForKey("count") as Int) < (d2.valueForKey("count") as Int) ){
                    return false
                }
                return (d1.valueForKey("Title") as String) < (d2.valueForKey("Title") as String)
                })
        }
    }
        
        
    
    var nearBySeminars:NSDictionary[] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        println(email)
    }
    override func viewDidAppear(animated: Bool){
        println(email)
        seminarTable.reloadData()
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
        var title = searchSeminarArray[indexPath.row].valueForKey("Title") as String
        if(searchSeminarArray[indexPath.row].valueForKey("count") as Int == 0){
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator


        }
        
        cell.textLabel.text = title
        println("req")
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
        println(searchSeminarArray.count)
        return searchSeminarArray.count
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if(cell.selectionStyle == UITableViewCellSelectionStyle.None){
            return
        }
        selectSeminar(searchSeminarArray[indexPath.row])
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
    func didUpdateSeminarList(seminarArray:NSDictionary[]){
        searchSeminarArray = seminarArray
        seminarTable.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}