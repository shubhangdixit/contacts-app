//
//  NetworkManager.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    typealias successBlock  = (Data?) -> Void
    typealias failureBlock = (Error?)-> Void
    
    
    func getContactsList(success: @escaping successBlock, failure: @escaping failureBlock) {
        let url : String = "https://gojek-contacts-app.herokuapp.com/contacts.json"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let apiError = error {
                failure(apiError)
            } else {
                if let result = data {
                    success(result)
                }
            }
        })
        task.resume()
    }
    
}

