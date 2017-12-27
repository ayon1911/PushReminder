//
//  ViewController.swift
//  PusReminder
//
//  Created by Khaled Rahman Ayon on 18/12/2017.
//  Copyright © 2017 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserNotificationService.instance.authorize()
        CLService.instance.authorize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterRegion), name: NSNotification.Name("enterLocaionRegion"), object: nil)
        
        //internalNotification.handelAction
        NotificationCenter.default.addObserver(self, selector: #selector(handelAction(_:)), name: NSNotification.Name("internalnotification.handelAction"), object: nil)
    }
    
    @objc func didEnterRegion() {
        UserNotificationService.instance.locationRequest()
    }
    
    @objc func handelAction(_ sender: Notification) {
        guard let action = sender.object as? NotificationActionID else { return }
        switch action {
        case .timer:
            print("Timer logic was triggered ")
            view.backgroundColor = UIColor.blue
        case .date:
            print("Date logic was triggered ")
            view.backgroundColor = UIColor.brown
        case .location:
            print("Location logic was triggered ")
                view.backgroundColor = UIColor.cyan
        }
    }
    

    @IBAction func onTimerBtnPressed() {
        print("Timer button was pressed")
        AlertService.actinSheet(in: self, title: "5 Seconds") {
            UserNotificationService.instance.timerRequest(with: 5)
        }
    }
    
    @IBAction func onDateBtnPressed() {
       print("Date button was pressed")
        AlertService.actinSheet(in: self, title: "Any time") {
            var components = DateComponents()
            components.second = 0
            UserNotificationService.instance.dateRequest(with: components)
        }
    }
    
    @IBAction func onLocationBtnPressed() {
        print("Location button was pressed")
        AlertService.actinSheet(in: self, title: "Location") {
            CLService.instance.updateLocation()
        }
    }

}

