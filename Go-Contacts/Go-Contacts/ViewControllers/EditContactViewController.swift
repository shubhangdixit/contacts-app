//
//  EditContactViewController.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 12/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class EditContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var contact : Contact?
    var isEditingContact : Bool?
    weak var delegate: EditContactProtocol?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width/2
        dropGradient()
        setupNavBarButton()
        imagePicker.delegate = self
        if isEditingContact ?? false { fillContactDetails() }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height * 1.26)
    }
    
    func setupNavBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.leftBarButtonItem = cancelButton
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
        self.view.bringSubviewToFront(detailsView)
    }
    
    func fillContactDetails() {
        if let detailContact = contact {
            if let url = detailContact.profilePicUrl {
                profilePhotoImageView.loadImageUsingCache(withUrl: url)
            }
            firstNameTextfield.text = detailContact.firstName
            lastNameTextfield.text = detailContact.lastName
            emailTextfield.text = detailContact.email
            phoneNumberTextfield.text = detailContact.phoneNumber
        }
    }
    
    func getImageURL() -> String {
        let dummyURL = (firstNameTextfield.text ?? "") + "/" + (lastNameTextfield.text ?? "")
        return "/testURL/" + dummyURL
    }
    
    @objc func doneAction() {
        if isValidEmail(emailStr: emailTextfield.text ?? "") {
            if isEditingContact ?? false {
                saveContactChanges()
            } else {
                saveNewContact()
            }
        } else {
            self.showAlertMsg(title: "Invalid Email", message: "")
        }
    }
    
    func saveNewContact() {
        ContactManager.shared.saveContact(withFirstName: firstNameTextfield.text ?? "", lastName: lastNameTextfield.text ?? "", email: emailTextfield.text ?? "", phoneNumber: phoneNumberTextfield.text ?? "", imageURL: getImageURL(), success: { [weak self] in
            DispatchQueue.main.async {
                self?.cancelAction()
            }
        }) {[weak self] error in
            self?.showAlertMsg(title: "Error", message: error.debugDescription)
        }
    }
    
    func saveContactChanges() {
        if checkForChanges() {
            if let updatedContact = self.contact {
                let alphabetGroup = updatedContact.getContactCharacterGroup()
                updatedContact.firstName = firstNameTextfield.text
                updatedContact.lastName = lastNameTextfield.text
                updatedContact.email = emailTextfield.text
                updatedContact.phoneNumber = phoneNumberTextfield.text
                ContactManager.shared.saveChanges(forContact: updatedContact, alphabetGroup: alphabetGroup, success: {[weak self] in
                    DispatchQueue.main.async {
                        self?.delegate?.contactDidUpdate(withUpdatedValue: updatedContact)
                        self?.cancelAction()
                    }
                }) {[weak self] error in
                    self?.showAlertMsg(title: "Error", message: error.debugDescription)
                }
            }
        }
    }
    
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Button actions
    
    @IBAction func setImageButtonAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Image picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhotoImageView.contentMode = .scaleAspectFit
            profilePhotoImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: checks
    
    func isValidEmail(emailStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func checkForChanges() -> Bool {
        if firstNameTextfield.text != contact?.firstName {
            return true
        } else if lastNameTextfield.text != contact?.lastName {
            return true
        } else if emailTextfield.text != contact?.email {
            return true
        } else if phoneNumberTextfield.text != contact?.phoneNumber {
            return true
        }
        return false
    }
}

