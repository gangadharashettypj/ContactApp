//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Gangadharan on 16/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import UIKit

class ContactModel {
    var name: String
    var phone: String
    var image: UIImage
    var email: String
    
    init(name: String, phone: String, image: UIImage, email: String) {
        self.name = name
        self.phone = phone
        self.image = image
        self.email = email
    }
    
}
