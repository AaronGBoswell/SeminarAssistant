//
//  InSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/25/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit





class InSeminarViewController: UIViewController  {
    
    @IBOutlet var titleLabel : UILabel! = nil
    @IBOutlet var descriptionLabel : UILabel! = nil
   
    @IBOutlet var web : UIWebView!
    var regDic:NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(regDic)
        
        navigationItem.title = "Welcome to " + (regDic.valueForKey("Title") as String)
        print(regDic.valueForKey("URL") as String)
        
        var url = NSURL(string: regDic.valueForKey("URL") as String)
        print(url)
        var request = NSURLRequest(URL: url)
        
        web.loadRequest(request)
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}