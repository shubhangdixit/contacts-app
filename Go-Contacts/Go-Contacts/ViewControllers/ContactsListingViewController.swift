//
//  ContactsListingViewController.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit

class ContactsListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = " Contact "
        let addContactBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        self.navigationItem.rightBarButtonItem = addContactBarButton
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        loadContacts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ContactManager.shared.contactDataDidChange {
            tableView.reloadData()
            ContactManager.shared.contactDataDidChange = false
        }
    }
    
    func loadContacts() {
        ContactManager.shared.fetchContactsList(success: {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            
        }) {[weak self] error in
            self?.showAlertMsg(title: "Error", message: error.debugDescription)
        }
    }
    
    // MARK: Nav Bar Button Action
    
    @objc func addNewContact() {
        if let viewController : EditContactViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController {
            viewController.isEditingContact = false
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: table view functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ContactManager.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.shared.getAlphbetGroupContactCount(forIndex: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : HeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        cell.alphabetSectionLabel.text = String(ContactManager.shared.characterGroups[section])
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ContactCell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        if let contact = ContactManager.shared.getContact(withAlphanetIndex: indexPath.section, andContactIndex: indexPath.row) {
            cell.contact = contact
            cell.configureCell()
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let characterGroupsStringArray = ContactManager.shared.characterGroups.map { String($0) }
        return characterGroupsStringArray
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let sectionAphabet : Character = title.first ?? "#"
        return ContactManager.shared.characterGroups.firstIndex(of : sectionAphabet) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contact = ContactManager.shared.getContact(withAlphanetIndex: indexPath.section, andContactIndex: indexPath.row) {
            if let viewController : ContactDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
                viewController.contact = contact
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
