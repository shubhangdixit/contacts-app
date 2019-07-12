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
        performRequest(forUrl: url, requestType: "GET", jsonData: nil, success: { data in
            success(data)
        }) { error in
            failure(error)
        }
    }
    
    func getContactDetail(forID id : Int, success: @escaping successBlock, failure: @escaping failureBlock) {
        var url : String = "https://gojek-contacts-app.herokuapp.com/contacts/"
        url = url + String(id) + ".json"
        performRequest(forUrl: url, requestType: "GET", jsonData: nil, success: { data in
            success(data)
        }) { error in
            failure(error)
        }
    }
    
    func postNewContact(withData data : Dictionary<String, Any>, success: @escaping successBlock, failure: @escaping failureBlock) {
        let url : String = "https://gojek-contacts-app.herokuapp.com/contacts.json"
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        performRequest(forUrl: url, requestType: "POST", jsonData: jsonData, success: { data in
            success(data)
        }) { error in
            failure(error)
        }
    }
    
    func updateContact(forID id : Int, withData data : Dictionary<String, Any>, success: @escaping successBlock, failure: @escaping failureBlock) {
        var url : String = "https://gojek-contacts-app.herokuapp.com/contacts/"
        url = url + String(id) + ".json"
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        performRequest(forUrl: url, requestType: "PUT", jsonData: jsonData, success: { data in
            success(data)
        }) { error in
            failure(error)
        }
    }
    
    func performRequest(forUrl url : String, requestType : String, jsonData : Data?, success: @escaping successBlock, failure: @escaping failureBlock) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = requestType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if jsonData != nil {
            request.httpBody = jsonData
        }
        
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

