//
//  UIViewControllerExtension.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 12/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertMsg(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        print("popup disappeared")
    }
    
    
    func showPermissionAlert(_ delegate: UIViewController, strtittle: String, message: String, actionTittle: String, completion: @escaping () -> Void)
    {
        var alertController: UIAlertController = UIAlertController()
        
        alertController = UIAlertController(title: strtittle, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: actionTittle, style: .default, handler: { (action: UIAlertAction!) in
            completion()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        delegate.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
