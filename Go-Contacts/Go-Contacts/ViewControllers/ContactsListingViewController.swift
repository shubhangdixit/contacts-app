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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        ContactManager.shared.fetchContactsList(success: {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }) {[weak self] error in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
            label.center = self?.view.center ?? CGPoint(x: 0, y: 0)
            label.textAlignment = NSTextAlignment.center
            label.text = error.debugDescription
            self?.view.addSubview(label)
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
}
