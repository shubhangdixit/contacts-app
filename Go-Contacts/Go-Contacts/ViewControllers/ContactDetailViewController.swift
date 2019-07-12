//
//  ContactDetailViewController.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol EditContactProtocol : class {
    func contactDidUpdate(withUpdatedValue contact : Contact)
}

class ContactDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, EditContactProtocol {
    
    var contact : Contact?
    
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width/2
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction))
        self.navigationItem.rightBarButtonItem = editButton
        dropGradient()
        loadContactDetails()
    }
    
    func loadContactDetails() {
        if let detailContact = contact {
            fillContactDetails(forContact: detailContact)
            ContactManager.shared.fetchDetails(forContact: detailContact, success: {[weak self] updatedContact in
                self?.contact = updatedContact
                DispatchQueue.main.async {
                    self?.fillContactDetails(forContact: updatedContact)
                }
            }) {[weak self] error in
                let message = error != nil ? error.debugDescription : "Unable to fetch contact details, please check your internet conection"
                self?.showAlertMsg(title: "Error", message: message)
                print(error ?? "Something went wrong")
            }
        }
    }
    
    func dropGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = detailsView.bounds
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor(red: 216/255, green: 246/255, blue: 240/255, alpha: 1).cgColor,
            UIColor(red: 216/255, green: 246/255, blue: 240/255, alpha: 1).cgColor
        ]
        detailsView.backgroundColor = .clear
        detailsView.layer.insertSublayer(gradient, at: 0)
    }
    
    func fillContactDetails(forContact detailContact: Contact) {
        if let url = detailContact.profilePicUrl {
            profilePhotoImageView.loadImageUsingCache(withUrl: url)
        }
        var contactName = (detailContact.firstName ?? "") + " "
        if let lastname = detailContact.lastName {
            contactName += lastname
        }
        contactNameLabel.text = contactName
        if detailContact.favorite == true {
            favouriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
        }
        emailLabel.text = detailContact.email
        mobileNumberLabel.text = detailContact.phoneNumber
    }
    
    // Mark: Nav Bar Buttons
    
    @objc func editButtonAction() {
        if let viewController : EditContactViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController {
            viewController.isEditingContact = true
            viewController.contact = self.contact
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: Button actions
    
    @IBAction func messageButtonAction(_ sender: Any) {
        if let messageContact = contact, (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "hi " + (self.contactNameLabel.text ?? "")
            controller.recipients = [messageContact.phoneNumber] as? [String]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            self.showAlertMsg(title: "", message: "Could'nt connect to Message app")
        }
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        guard let phoneNumber = contact?.phoneNumber else { return }
        if let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            self.showAlertMsg(title: "", message: "Could'nt connect to Dialer app")
        }
    }
    
    @IBAction func emailButtonAction(_ sender: Any) {
        if let mailContact = contact, MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let body = "<p>hi " + (self.contactNameLabel.text ?? "") + "</p>"
            mail.setToRecipients([mailContact.email ?? ""])
            mail.setMessageBody(body, isHTML: true)
            present(mail, animated: true)
        } else {
            showAlertMsg(title: "", message: "Could'nt connect to Mail app")
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
    }
    
    //MARK: EditContactProtocol
    
    func contactDidUpdate(withUpdatedValue contact: Contact) {
        self.contact = contact
        fillContactDetails(forContact: contact)
    }
    
    //MARK: message UI delegate functions
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

