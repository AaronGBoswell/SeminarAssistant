//
//  BeaconNotificationDelegate.swift
//  SeminarAssistant
//
//  Created by Aaron Boswell on 6/28/14.
//  Copyright (c) 2014 Aaron Boswell. All rights reserved.
//

import Foundation
import UIKit
protocol BeaconNotificationDelegate {
    func didEnterSeminar(seminar:NSDictionary, seminarArray:NSDictionary[]);
    func didExitSeminar(seminar:NSDictionary,seminarArray:NSDictionary[]);
    func didUpdateSeminarList(seminarArray:NSDictionary[]);


}