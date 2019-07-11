//
//  Contact.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation

class Contact: NSObject {
    
    var firstName : String?
    var lastName : String?
    var contactId : Int?
    var favorite : Bool = false
    var email : String?
    var phoneNumber : String?
    var profilePicUrl : String?
    
    let contactsJsonKeys = ContactsJsonKeys()
    
    init(withDictionary dictionary : [String: Any]) {
        firstName = dictionary[contactsJsonKeys.firstNameKey] as? String
        lastName = dictionary[contactsJsonKeys.lastNameKey] as? String
        contactId = dictionary[contactsJsonKeys.contactIDKey] as? Int
        favorite = dictionary[contactsJsonKeys.favoriteContactKey] as? Bool ?? false
        profilePicUrl = dictionary[contactsJsonKeys.profilePicURLKey] as? String
    }
    
}
