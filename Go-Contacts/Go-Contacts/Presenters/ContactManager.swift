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
    var contactDataDidChange = false
    
    func fetchContactsList(success: @escaping () -> Void, failure: @escaping (Error?)-> Void) {
        NetworkManager.shared.getContactsList(success: {[weak self] data in
            do {
                if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                    for contactData in parsedData {
                        self?.addNewContactToDataStructure(withData: contactData)
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
    
    func fetchDetails(forContact contact: Contact, success: @escaping (Contact) -> Void, failure: @escaping (Error?)-> Void) {
        guard let contactID = contact.contactId else {
            failure(nil)
            return
        }
        let detailContact = contact
        NetworkManager.shared.getContactDetail(forID: contactID, success: { data in
            do {
                if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                    detailContact.updateDetails(withDictionary: parsedData)
                    success(detailContact)
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
    
    func saveContact(withFirstName firstName: String, lastName :String, email: String, phoneNumber : String, imageURL: String, success: @escaping () -> Void, failure: @escaping (Error?)-> Void) {
        let contactDictionary = Contact.getDictionaryForContact(withFirstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, imageURL: imageURL)
        NetworkManager.shared.postNewContact(withData: contactDictionary, success: {[weak self] data in
            do {
                if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                    self?.addNewContactToDataStructure(withData: parsedData)
                    self?.contactDataDidChange = true
                    success()
                } else {
                    failure(nil)
                }
            } catch let error as NSError {
                failure(error)
            }
            success()
        }) { error in
            failure(error)
        }
    }
    
    func saveChanges(forContact contact : Contact, alphabetGroup: Character, success: @escaping () -> Void, failure: @escaping (Error?)-> Void) {
        let contactDictionary = contact.getDictionary()
        if let id = contact.contactId {
            NetworkManager.shared.updateContact(forID: id, withData: contactDictionary, success: {[weak self] data in
                do {
                    if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                        self?.removeContact(oldContact: contact, alphabetGroup: alphabetGroup)
                        self?.addNewContactToDataStructure(withData: parsedData)
                        success()
                    } else {
                        failure(nil)
                    }
                } catch let error as NSError {
                    failure(error)
                }
                success()
            }) { error in
                failure(error)
            }
        }
    }
    
    func addNewContactToDataStructure(withData contactData:[String:Any]) {
        let newContact = Contact.init(withDictionary: contactData)
        if (self.contacts[newContact.getContactCharacterGroup()]) != nil {
            self.contacts[newContact.getContactCharacterGroup()]?.append(newContact)
        } else {
            let tempArray : [Contact] = [Contact.init(withDictionary: contactData)]
            self.contacts[newContact.getContactCharacterGroup()] = tempArray
        }
    }
    
    func removeContact(oldContact: Contact, alphabetGroup : Character) {
        if let contactsArray = self.contacts[alphabetGroup] {
            var contactIndex = 0
            for (index, element) in contactsArray.enumerated() {
                if element.contactId == oldContact.contactId {
                    contactIndex = index
                }
            }
            self.contacts[alphabetGroup]?.remove(at: contactIndex)
            self.contactDataDidChange = true
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
