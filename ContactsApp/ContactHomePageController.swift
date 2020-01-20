//
//  ContactHomePageController.swift
//  ContactsApp
//
//  Created by Gangadharan on 16/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import Contacts
import ContactsUI

var contacts: [ContactModel] = []

protocol ContactOperationDelegate {
    func onAdded()
    func onDeleted()
    func onDeleteTapped(alert: UIAlertController)
    func onEdited()
}

protocol ContactGestureDelegate {
    func onTapped()
    func onLeftSwiped()
    func onRIghtSwiped()
}

class ContactHomePageCOntroller: UITableViewController, UISearchBarDelegate, ContactOperationDelegate, ContactGestureDelegate{

    @IBOutlet var mTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactViewCell
        cell.initGesture(view: view)
        cell.contactGestureDelegate = self
        let contact = contacts[indexPath.row]
        
        cell.contactoperationdelegate = self
        
        cell.nameLabel?.text = contact.name
        cell.phoneLabel?.text = contact.phone
        cell.contactImage?.image = contact.image
        
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.height / 2
        cell.contactImage.clipsToBounds = true
        
        return cell
    }
    
    func onLeftSwiped() {
        print("Left Swipe")
    }
    func onRIghtSwiped() {
        print("Right Swipe")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewContactViewController: ViewContactViewController = storyboard?.instantiateViewController(identifier: "ViewContact") as! ViewContactViewController
        viewContactViewController.selectedContact = contacts[indexPath.row]
        if let navigator = navigationController {
            navigator.pushViewController(viewContactViewController, animated: true)
        }
    }
    
    func onDeleted() {
        self.parent?.view.makeToast("Contact deleted successfully")
        refresh()
    }
    
    func onAdded() {
        self.parent?.view.makeToast("Contact added successfully")
        refresh()
    }
    
    func onDeleteTapped(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func onEdited() {
        self.parent?.view.makeToast("Contact updated successfully")
        refresh()
    }
    
    func refresh() {
        contacts.removeAll()
        contacts = getContacts()
        contacts.sort(by: {$0.name.lowercased() < $1.name.lowercased()})
        mTable.reloadData()
    }
    
    func onTapped() {
        print("Tapped")
    }
    
}

