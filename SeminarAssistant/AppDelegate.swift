//
//  AppDelegate.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/25/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate, NSURLSessionDownloadDelegate {
                            
    var window: UIWindow?
    var bND:BeaconNotificationDelegate? = nil
    var sesh:NSURLSession?
    var email:String = "aaron@lakejoe.com"
    
    var locationManager:CLLocationManager? = CLLocationManager();
    var inRange:Int = 0;
    var seminarArray:NSDictionary[] = []
    var currRegion:CLRegion? = nil
    
    var complet:((UIBackgroundFetchResult) -> Void)?
    var nextVC:UIViewController?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        //application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }
    func startFetches(){
        
        locationManager!.requestAlwaysAuthorization()
        locationManager!.delegate = self
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        if(!sesh){
            sesh = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("fetchRegions"), delegate: self, delegateQueue: nil)
        }

    }
    func endFetches(){
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
    }
    func application(application: UIApplication!,performFetchWithCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)!){
        regionFetch(completionHandler)

    }
    
    func regionFetch(completionHandler: ((UIBackgroundFetchResult) -> Void)!){
        
        var url = NSURL(string: "http://seminarassistant.com/appinterac/FechIDs.php?Email=\(email)");
        // println(url)
        if(sesh){
            let task = sesh!.downloadTaskWithURL(url)
            task.taskDescription = "fetchRegions"
            println("fetching")
            task.resume()
            complet = completionHandler
        }
        

        
        
    }
    func URLSession( session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!){
        if(locationManager){
            print("good")
        }
        else{
            print("bad")

        }
        let r = locationManager!.monitoredRegions
        if(r.count != 0){
            for region in r.allObjects as CLRegion[]{
                locationManager!.stopMonitoringForRegion(region as CLRegion)
            
            }
        }
        
        
        var data = NSData(contentsOfURL: location)
        
        var jsonArray:NSDictionary[] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary[]
        seminarArray = jsonArray
        
        for obj in jsonArray{
            var dic = obj as NSDictionary
            var uuid:String = dic.valueForKey("UUID") as String
            var title:String = dic.valueForKey("Title") as String
            print("Adding: ")
            
            print((dic.valueForKey("UUID")))
            
            newRegion(with: uuid, andid: title)
        }
        for var index = 0; index < seminarArray.count; ++index {
            var mDic:NSMutableDictionary = seminarArray[index].mutableCopy() as NSMutableDictionary
            mDic.setValue((0 as Int), forKey: "count")
            seminarArray[index] = mDic
        }
        if(bND){
            bND!.didUpdateSeminarList(seminarArray)
        }
        if(complet){
            complet!(UIBackgroundFetchResult.NewData);
        }
        
    }
    func newRegion(with uuid:String, andid title:String){
        var err: NSError?
        var regex = NSRegularExpression(pattern:"\\A[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\\Z" , options: NSRegularExpressionOptions.AnchorsMatchLines, error:&err )
        var x = regex.numberOfMatchesInString(uuid, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, uuid.utf16count))
        if(x == 0){
            println(" .. Failed, badd UUID: \(uuid)")
            return
        }
        var beaconRegion:CLBeaconRegion? = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier:title)
        beaconRegion!.notifyOnEntry = true;
        beaconRegion!.notifyOnExit = true;
        beaconRegion!.notifyEntryStateOnDisplay = true;
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        println(" Success")
        
        
        
        
    }
  
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!){
        var reg:NSDictionary?
        for dic in seminarArray{
            if((dic.valueForKey("Title")as String).compare(region.identifier) == 0 ){
                reg = dic
                break
            }
        }
        
        println("enter");
        let noty:UILocalNotification? = UILocalNotification()
        noty!.alertBody = "You are in range of the seminar"
        noty!.fireDate = NSDate.date()
        UIApplication.sharedApplication().scheduleLocalNotification(noty)
        if(bND){
            bND!.didEnterSeminar(reg!, seminarArray: seminarArray)
        }
        
    }
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!){
        var reg:NSDictionary?
        for dic in seminarArray{
            if((dic.valueForKey("Title")as String).compare(region.identifier) == 0 ){
                reg = dic
                break
            }
        }
        println("exit");
        let noty:UILocalNotification? = UILocalNotification()
        noty!.alertBody = "You left the seminar"
        noty!.fireDate = NSDate.date()
        UIApplication.sharedApplication().scheduleLocalNotification(noty)
        if(bND){
            bND!.didExitSeminar(reg!, seminarArray: seminarArray)
        }
        if(nextVC! is InSeminarViewController){
            nextVC!.performSegueWithIdentifier("LeaveSeminar", sender: nextVC!)
        }
    }
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: AnyObject[]!,inRegion region: CLBeaconRegion!){
        println("rangin\(beacons.count)")
        if(inRange<beacons.count){
            inRange = beacons.count
            locationManager(locationManager,didEnterRegion:region)
        }
        var reg:NSDictionary?
        for dic in seminarArray{
            if((dic.valueForKey("Title")as String).compare(region.identifier) == 0 ){
                reg = dic
                break
            }
        }
        if((reg!.valueForKey("count") as Int) < beacons.count){
            var inRange:Int = 0;
            reg!.setValue(beacons.count, forKey: "count")
            locationManager(locationManager,didEnterRegion:region)
        }
        if((reg!.valueForKey("count") as Int) > beacons.count){
            reg!.setValue(beacons.count, forKey: "count")
            locationManager(locationManager,didExitRegion:region)
            
        }
        
    }
    
    


}

