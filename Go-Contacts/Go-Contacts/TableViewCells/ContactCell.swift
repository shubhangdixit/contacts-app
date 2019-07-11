//
//  ContactCell.swift
//  Go-Contacts
//
//  Created by Shubhang Dixit on 11/07/19.
//  Copyright © 2019 Shubhang Dixit. All rights reserved.
//

import Foundation
import UIKit

class ContactCell: UITableViewCell {
    
    var contact : Contact?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // making profile picture rounded
        favoriteImageView.isHidden = true
        profilePicImageView.layer.masksToBounds = true
        profilePicImageView.layer.cornerRadius = 20
    }
    
    func configureCell() {
        var contactName = (contact?.firstName ?? "") + " "
        if let lastname = contact?.lastName, contactName.count < 30 {
            contactName += lastname
        }
        nameLabel.text = contactName
        if let favourite = contact?.favorite, favourite == true {
            favoriteImageView.isHidden = false
        }
        profilePicImageView.image = UIImage(named: "placeholder_photo")
        if let url = contact?.profilePicUrl { profilePicImageView.loadImageUsingCache(withUrl: url) }
    }
}

