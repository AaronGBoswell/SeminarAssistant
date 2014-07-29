//
//  TimeLocationViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 7/29/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit

class TimeLocationViewController: UIViewController  {
    
    
    var seminarInfo = NSDictionary()
    
    @IBOutlet var locationTF : UITextField = nil
    @IBOutlet var datePicker : UIDatePicker = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: "dismisss")
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        dismisss()
    }
    func dismisss(){
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var destVC : AnyObject! = segue.destinationViewController
        if(destVC is UUIDContentViewController){
            println(seminarInfo)

            seminarInfo.setValue(locationTF.text as String, forKey: "Location")
            seminarInfo.setValue(datePicker.date, forKey: "dateTime")
            
            var dvc = destVC as UUIDContentViewController
            dvc.seminarInfo = seminarInfo
            println(seminarInfo)

        }
        var bbbi = UIBarButtonItem()
        bbbi.title = "Back"
        navigationItem.backBarButtonItem = bbbi
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}