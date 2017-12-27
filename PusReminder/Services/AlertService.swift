//
//  AlertService.swift
//  PusReminder
//
//  Created by Khaled Rahman Ayon on 18/12/2017.
//  Copyright © 2017 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    static func actinSheet(in vc: UIViewController, title: String, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
