//
//  ViewContactViewController.swift
//  ContactsApp
//
//  Created by Gangadharan on 17/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import UIKit

class ViewContactViewController: UIViewController {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactMail: UILabel!
    
    var selectedContact: ContactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactName.text = selectedContact?.name
        contactPhone.text = selectedContact?.phone
        contactMail.text = selectedContact?.email
        contactImage.image = selectedContact?.image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        let editContactViewController: EditCOntactViewController = storyboard?.instantiateViewController(identifier: "EditContact") as! EditCOntactViewController
        editContactViewController.editContact = selectedContact
        if let navigator = navigationController {
            navigator.pushViewController(editContactViewController, animated: true)
        }
    }
}
