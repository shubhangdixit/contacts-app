//
//  ContactManager.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation

class ContactManager {
    static let shared = ContactManager()
    var contacts : [Contact] = []
    
    func fetchContactsList(success: @escaping () -> Void, failure: @escaping (Error?)-> Void) {
        NetworkManager.shared.getContactsList(success: {[weak self] data in
            do {
                if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                    for contactData in parsedData {
                        self?.contacts.append(Contact.init(withDictionary: contactData))                    }
                    success()
                } else {
                    failure(nil)
                }
            } catch let error as NSError {
                failure(error)
            }
        }) { error in
            failure(error)
        }
    }
}
