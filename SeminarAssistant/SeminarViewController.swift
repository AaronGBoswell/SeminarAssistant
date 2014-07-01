//
//  SeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/27/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
import AddressBookUI

class SeminarViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {
    
    
    var email:String = "henry@lakejoe.com"
    var ID:String = "1"
    var clickedSeminar:NSDictionary = NSDictionary()
    @IBOutlet var tableView : UITableView = nil
    var invites:NSDictionary[] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInvites()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func addInvites(sender : AnyObject) {
        
        var picker = ABPeoplePickerNavigationController()
        
        picker.peoplePickerDelegate = self
        self.presentModalViewController(picker, animated: true)
    }
    
    
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker:ABPeoplePickerNavigationController!)
    {
        println( "here")
        self.dismissModalViewControllerAnimated(true)
        
    }
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,didSelectPerson person: ABRecordRef!) {
        println( "here")
        //displayPerson(person)
        
        
        var emailAddress = "no email address"
        
       // ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        var used = false;
        var un = ABRecordCopyValue(person, kABPersonEmailProperty)
        var emails : ABMultiValueRef? = un //Unmanaged<ABMultiValueRef>.fromOpaque(un.toOpaque()).takeUnretainedValue()
        if (emails)
        {
            if (ABMultiValueGetCount(emails) > 0)
            {
                var index = 0 as CFIndex

                emailAddress = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, index)) as String
                
                println(emailAddress)
                
                
                for obj in invites{
                    print("check: ")
                    var dic = obj as NSDictionary
                    var Email:String = dic.valueForKey("Email") as String
                   
                    if(Email == emailAddress)
                    {
                        print("used")
                        used = true
                        break
                    }
                    
                }
                print("unused ")

                
                if (used == false){
                    
                    
                    var url = NSURL(string: "http://www.seminarassistant.com/appinterac/addpeople.php?ID=\(ID)&Email=\(email)&CSV=\(emailAddress)")
                    print(url)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in

                        self.getInvites()
                    }
                    task.resume()
                    
                    
                }else{
                    used = false
                }
                
                
                
            }
            CFRelease(emails);
        }
        
        
        //
        
      
    }
    
    /*
    
    - (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
    {
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    self.resultLabel.text = [NSString stringWithFormat:@"Picked %@", contactName ? contactName : @"No Name"];
    }
 */
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecordRef!, property property: ABPropertyID, identifier identifier: ABMultiValueIdentifier) -> Bool{
        println( "here")
        return true
        
        
        
        
    }
    
    
    
    
    
    func displayPerson(person:ABRecordRef)
    {
        
       // NSString* name = (__bridge_transfer NSString*) ABRecordCopyValue(person,kABPersonFirstNameProperty);
        
        
        var un = ABRecordCopyValue(person, kABPersonEmailProperty)
        var email = Unmanaged<NSString>.fromOpaque(un.toOpaque()).takeUnretainedValue()
        
        
        println(email)
        /*
        self.firstName.text = name;

        NSString* phone = nil;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
        kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        } else {
        phone = @"[None]";
        }
        self.phoneNumber.text = phone;
        CFRelease(phoneNumbers);
        */
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
                
                println((dic.valueForKey("Email")))
                
            }
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                self.invites = jsonArray
                self.tableView.reloadData()
                
                
                
                });
            
            
            
        }
        task.resume()
        
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        
        var ident = "inviteCell";
        var cell = self.tableView.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
        }
        var title = invites[indexPath.row].valueForKey("Email") as String
        cell.textLabel.text = title
        return cell
        
        
        
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        
        var x = 0
        
        x = invites.count
        println(x)
        return x
        
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
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