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
    
    static let contactsJsonKeys = ContactsJsonKeys()
    
    init(withDictionary dictionary : [String: Any]) {
        firstName = dictionary[Contact.contactsJsonKeys.firstNameKey] as? String
        firstName = firstName?.capitalized
        lastName = dictionary[Contact.contactsJsonKeys.lastNameKey] as? String
        lastName = lastName?.capitalized
        contactId = dictionary[Contact.contactsJsonKeys.contactIDKey] as? Int
        //favorite = dictionary[contactsJsonKeys.favoriteContactKey] as? Bool ?? false
        profilePicUrl = dictionary[Contact.contactsJsonKeys.profilePicURLKey] as? String
        if (contactId ?? 0) % 5 == 0 {
            favorite = true
        }
        phoneNumber = ""
        email = ""
    }
    
    func updateDetails(withDictionary dictionary : [String: Any]) {
        firstName = dictionary[Contact.contactsJsonKeys.firstNameKey] as? String
        firstName = firstName?.capitalized
        lastName = dictionary[Contact.contactsJsonKeys.lastNameKey] as? String
        lastName = lastName?.capitalized
        contactId = dictionary[Contact.contactsJsonKeys.contactIDKey] as? Int
        //favorite = dictionary[contactsJsonKeys.favoriteContactKey] as? Bool ?? false
        profilePicUrl = dictionary[Contact.contactsJsonKeys.profilePicURLKey] as? String
        if (contactId ?? 0) % 5 == 0 {
            favorite = true
        }
        phoneNumber = dictionary[Contact.contactsJsonKeys.phoneNumberKey] as? String
        email = dictionary[Contact.contactsJsonKeys.emailKey] as? String
    }
    
    func getContactCharacterGroup() -> Character {
        let name = (firstName ?? "No Name") + (lastName ?? "")
        let firstCharacter = name.first ?? "N"
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        if letters.contains(firstCharacter) {
            return firstCharacter
        } else {
            return "#"
        }
    }
    
    func getDictionary() -> [String : Any] {
        var contactDictionary : [String:Any] = [:]
        contactDictionary[Contact.contactsJsonKeys.firstNameKey] = firstName
        contactDictionary[Contact.contactsJsonKeys.lastNameKey] = lastName
        contactDictionary[Contact.contactsJsonKeys.emailKey] = email
        contactDictionary[Contact.contactsJsonKeys.phoneNumberKey] = phoneNumber
        return contactDictionary
    }
    
    class func getDictionaryForContact(withFirstName firstName: String, lastName :String, email: String, phoneNumber : String, imageURL: String) -> [String : Any] {
        var contactDictionary : [String:Any] = [:]
        contactDictionary[contactsJsonKeys.firstNameKey] = firstName
        contactDictionary[contactsJsonKeys.lastNameKey] = lastName
        contactDictionary[contactsJsonKeys.emailKey] = email
        contactDictionary[contactsJsonKeys.phoneNumberKey] = phoneNumber
        contactDictionary[contactsJsonKeys.favoriteContactKey] = 0
        contactDictionary[contactsJsonKeys.profilePicURLKey] = imageURL
        return contactDictionary
    }
}
