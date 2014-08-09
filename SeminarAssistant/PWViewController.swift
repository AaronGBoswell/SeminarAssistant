//
//  PWViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 8/1/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

class PleaseWaitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,BeaconNotificationDelegate {
    
    @IBOutlet var searchTitle : UILabel! = nil
    @IBOutlet var activityMoniter : UIActivityIndicatorView! = nil
    @IBOutlet var seminarTable : UITableView! = nil
    
    @IBOutlet var underLabel : UILabel! = nil
    
    var displayedSeminar:InspectSeminarViewController? = nil
    var email:String = ""
    var currRegion:NSDictionary? = nil
    var spoof:[NSDictionary] = []{
    didSet{
        if(displayedSeminar != nil){
            println(displayedSeminar!.id)
            var id = displayedSeminar!.id
            for dic in searchSeminarArray{
                if((dic.valueForKey("ID") as String) == id){
                    if(dic.valueForKey("count") as Int > 0){
                        displayedSeminar!.inRange()
                    }
                    else{
                        displayedSeminar!.outRange()
                    }
                }
            }
        }
        var x = 0
        for dic in searchSeminarArray{
            if dic.valueForKey("count") as Int > 0{
                x++
            }
        }
        var ulText = ""
        var titleText = "No seminars are nearby"
        if(x == 0){
            
        }else if (x == 1){
            ulText = "Tap the seminar to check in."
            titleText = "You are in range of 1 seminar"
            
        }else{
            ulText = "Tap a seminar to check in."
            titleText = "You are in range of \(x) seminar"
        }
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
            self.searchTitle.text = titleText
            self.underLabel.text = ulText
            });
    }
    }
    
    var searchSeminarArray:[NSDictionary]{
    get{
        return spoof
    }
    set{
        spoof = newValue
        //            spoof = sort(newValue, { (d1: NSDictionary, d2: NSDictionary) -> Bool in
        //                if(d1.valueForKey("count") as Int > d2.valueForKey("count") as Int ){
        //                    return true
        //                }
        //                else if((d1.valueForKey("count") as Int) < (d2.valueForKey("count") as Int) ){
        //                    return false
        //                }
        //                return (d1.valueForKey("Title") as String) < (d2.valueForKey("Title") as String)
        //                })
    }
    }
    
    
    
    var nearBySeminars:[NSDictionary] = []
    
    
    override func viewDidLoad() {
        activityMoniter.hidesWhenStopped = true
        super.viewDidLoad()
        println(email)
        self.underLabel.text = ""
        
    }
    override func viewDidAppear(animated: Bool){
        println(email)
        seminarTable.reloadData()
        (UIApplication.sharedApplication().delegate as AppDelegate).regionFetch(nil)
        self.activityMoniter.startAnimating()
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if(identifier == "LeaveSeminar"){
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
        if(segue.destinationViewController is InspectSeminarViewController){
            var destVC  = segue.destinationViewController as InspectSeminarViewController
            var mDic:NSMutableDictionary = currRegion!.mutableCopy() as NSMutableDictionary
            mDic.setValue(email, forKey:"Email")
            destVC.seminar = mDic
            (UIApplication.sharedApplication().delegate as AppDelegate).nextVC = destVC
            displayedSeminar = destVC
            
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var ident = "nearbySeminar";
        var cell = seminarTable.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
        }
        var title = searchSeminarArray[indexPath.row].valueForKey("Title") as String
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
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
        selectSeminar(searchSeminarArray[indexPath.row])
    }
    
    
    
    
    func selectSeminar(selSem:NSDictionary){
        currRegion = selSem
        self.performSegueWithIdentifier("inspectSem", sender: self)
    }
    
    
    func didEnterSeminar(seminar:NSDictionary, seminarArray:[NSDictionary]){
        searchTitle.text = "Please select nearby seminar"
        
        searchSeminarArray = seminarArray
        seminarTable.reloadData()
    }
    func didExitSeminar(seminar:NSDictionary,seminarArray:[NSDictionary]){
        searchTitle.text = "Searching for nearby seminars"
        searchSeminarArray = seminarArray
        seminarTable.reloadData()
        
    }
    func didUpdateSeminarList(seminarArray:[NSDictionary]){
        
        searchSeminarArray = seminarArray
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
            self.activityMoniter.stopAnimating()
            self.seminarTable.reloadData()
            });
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}