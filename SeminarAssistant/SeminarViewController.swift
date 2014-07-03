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
    
    
    @IBOutlet var UUIDLabel : UILabel
    @IBOutlet var dataLocLabel : UILabel
    @IBOutlet var textFieldDis : UITextView
    var email:String = "henry@lakejoe.com"
    var ID:String = "1"
    var titlePassed:String = "Invitees"
    var UUID:String = " "
    var URL:String = " "
    var DIS:String = " "
    var clickedSeminar:NSDictionary = NSDictionary()
    @IBOutlet var tableView : UITableView = nil
    var invites:NSDictionary[] = []
    var checkcount = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("get")
        println("got")
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        self.title = titlePassed
        //textFieldDis.text = DIS
        UUIDLabel.text = UUID
        dataLocLabel.text = URL
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool){
        getInvites()
    }
    @IBAction func doneButtonClicked(sender : AnyObject) {
        for vc in navigationController.viewControllers{
            if vc is AccountViewController{
                navigationController.popToViewController(vc as UIViewController, animated: true)
            }
        }
    }
    
    @IBAction func addInvites(sender : AnyObject) {
        
        var picker = ABPeoplePickerNavigationController()
        
        picker.peoplePickerDelegate = self
        self.presentViewController(picker, animated: true, completion: nil)
       // self.presentModalViewController(picker, animated: true, completion)
    }
    
    /*
    - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
    }
    */
    
    
    
    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool{
            return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        
       // indexPath.
        
        
        
        var deleteEmail = invites[indexPath.row].valueForKey("Email") as String
        var deleteID = invites[indexPath.row].valueForKey("ID") as String
        
        invites.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
        var url = NSURL(string: "http://www.seminarassistant.com/appinterac/deletepeople.php?ID=\(deleteID)&Email=\(deleteEmail)")
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL((url), {(data, response, error) in
            println("task")
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                self.tableView.reloadData()
                println("task")
                });
            })
        task.resume()
        println("resumed")
        println("deleted")
    }
    
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker:ABPeoplePickerNavigationController!)
    {
        println( "here")
        self.dismissModalViewControllerAnimated(true)
        
    }
    func peoplePickerNavigationController(peoplePicker:ABPeoplePickerNavigationController!,didSelectPerson didSelectPerson:ABRecordRef!,property property:ABPropertyID!,identifier identifier:ABMultiValueIdentifier!){
        println( "!!!!!!!!!!!!!!!!!!!!!!!")

    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,didSelectPerson person: ABRecordRef!) {
        println( "here")
        //displayPerson(person)
        
    
        var emailAddress = "no email address"
        
       // ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        var used = false;
        
        //var emails:ABMultiValueRef? = ABRecordCopyValue(person, kABPersonEmailProperty)
        
        var emails:ABMultiValueRef? = ABRecordCopyValue(person, kABPersonEmailProperty)

        println(ABMultiValueGetCount(emails))
        
        if (emails){
            if (ABMultiValueGetCount(emails) > 0){
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
                println("unused ")

                
                if (used == false){
                    
                    
                    var url = NSURL(string: "http://www.seminarassistant.com/appinterac/addpeople.php?ID=\(ID)&Email=\(email)&CSV=\(emailAddress)")
                    print(url)
                    let task = NSURLSession.sharedSession().dataTaskWithURL((url), {(data, response, error) in
                        println("task")
                        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                            
                            println("task")

                        });
                    })
                    task.resume()
                    println("resumed")
                }else{
                    used = false
                }

                
            }
            println("prerelease")

            //CFRelease(emails)
            
            println("released")

        }
       //CFRelease(emails)


        println("fullStop")

    }
    
    /*
    
    - (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
    {
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    self.resultLabel.text = [NSString stringWithFormat:@"Picked %@", contactName ? contactName : @"No Name"];
    }
 */
    

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
            
            var same = true
            for obj1 in jsonArray{
                var s = false
                for obj2 in self.invites{
                    if(obj1.isEqualToDictionary(obj2)){
                        s = true
                        break
                    }
                }
                if(s == false){
                    same = false
                }
                print("Adding: ")
                println((obj1.valueForKey("Email")))
                
            }
            for obj1 in self.invites{
                var s = false
                for obj2 in jsonArray{
                    if(obj1.isEqualToDictionary(obj2)){
                        s = true
                        break
                    }
                }
                if(s == false){
                    same = false
                }
                
            }
            
            if(same == false){
                dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                    self.invites = jsonArray
                    self.tableView.reloadData()
                });
            }
            else{
                print("same")
            }
           
            if(self.isViewLoaded()){
                if(self.view.window){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        self.getInvites()
                        self.checkcount++
                        println("getting\(self.checkcount)\n")

                    })
                }
            }
            
            
        }
        task.resume()
        println("getting\(self.checkcount)")

        
        
        
    }
    
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        
        var ident = "inviteCell";
        var cell = self.tableView.dequeueReusableCellWithIdentifier(ident) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ident)
        }
        var title = invites[indexPath.row].valueForKey("Email") as String
        var checked = invites[indexPath.row].valueForKey("CheckedIn") as String
        cell.textLabel.text = title
        cell.detailTextLabel.text = checked
        


        return cell
        
        
        
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        
        var x = 0
        
        x = invites.count
        println(x)
        return x
        
        
    }
    //func tableView(tableView:UIITableView!, canEditRowAtIndexPath indexPath::NSIndexPath!){
    //    return true
    //}
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