//
//  File.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 7/29/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//
import Foundation
import UIKit





class TitleDescriptionViewController: UIViewController  {
    
    @IBOutlet var titleTF : UITextField! = nil
    @IBOutlet var descriptionTF : UITextField! = nil
    
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
        if(destVC is TimeLocationViewController){
            var info = NSMutableDictionary()
            var title = titleTF.text
            var desc = descriptionTF.text

            info.setValue(title as String, forKey: "Title")
            info.setValue(desc as String, forKey: "DIS")


            var dvc = destVC as TimeLocationViewController
            dvc.seminarInfo = info
            println(info)

            println(dvc.seminarInfo)
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