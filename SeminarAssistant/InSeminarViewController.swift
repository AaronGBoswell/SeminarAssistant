//
//  InSeminarViewController.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/25/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
class InSeminarViewController: UIViewController {
    @IBOutlet var uuidLabel : UILabel = nil
    @IBOutlet var titleLabel : UILabel = nil
    @IBOutlet var descriptionLabel : UILabel = nil
    @IBOutlet var urlLabel : UILabel = nil
    var regDic:NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(regDic)
        uuidLabel.text = regDic.valueForKey("UUID") as String
        titleLabel.text = regDic.valueForKey("Title") as String
        descriptionLabel.text = regDic.valueForKey("DIS") as String
        urlLabel.text = regDic.valueForKey("URL") as String

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}