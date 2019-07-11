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
    var contacts : [Character : [Contact]] = [:]
    var characterGroups : [Character] = []
    
    func fetchContactsList(success: @escaping () -> Void, failure: @escaping (Error?)-> Void) {
        NetworkManager.shared.getContactsList(success: {[weak self] data in
            do {
                if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                    for contactData in parsedData {
                        let newContact = Contact.init(withDictionary: contactData)
                        if (self?.contacts[newContact.getContactCharacterGroup()]) != nil {
                            self?.contacts[newContact.getContactCharacterGroup()]?.append(newContact)
                        } else {
                            let tempArray : [Contact] = [Contact.init(withDictionary: contactData)]
                            self?.contacts[newContact.getContactCharacterGroup()] = tempArray
                        }
                    }
                    self?.initializeContactCharacterGroups()
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
    
    func initializeContactCharacterGroups() {
        let tempArrayOfKey = Array(contacts.keys)
        characterGroups = tempArrayOfKey.sorted { $0 < $1 }
    }
    
    func getAlphbetGroupContactCount(forIndex index: Int) -> Int {
        return self.contacts[characterGroups[index]]?.count ?? 0
    }
    
    func getContact(withAlphanetIndex index : Int, andContactIndex cIndex : Int ) -> Contact? {
        let contactsGroupKey : Character = characterGroups[index]
        if (contacts[contactsGroupKey]?.count ?? 0) > cIndex {
            return contacts[contactsGroupKey]?[cIndex]
        } else { return nil }
    }
}
