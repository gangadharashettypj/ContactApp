//
//  ContactViewCell.swift
//  ContactsApp
//
//  Created by Gangadharan on 20/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class ContactViewCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    var contactGestureDelegate: ContactGestureDelegate?
    
    var contactoperationdelegate:  ContactOperationDelegate?
    
    func initGesture(view: UIView ) {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(recognizer:)))
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(recognizer:)))
        rightSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        leftSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipeRecognizer)
        view.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    
    @objc func handleLeftSwipe(recognizer: UISwipeGestureRecognizer) {
        contactGestureDelegate?.onLeftSwiped()
    }
    
    @objc func handleRightSwipe(recognizer: UISwipeGestureRecognizer) {
        contactGestureDelegate?.onRIghtSwiped()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        let alert =  UIAlertController(title: "Delete", message: "do you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            if self.nameLabel.text != nil {
                self.deleteContact(name: self.nameLabel.text!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("Not deleted")
        }))
        
        contactoperationdelegate?.onDeleteTapped(alert: alert)
    }
    
    func deleteContact(name: String) {
        
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        if let contact = getContactWithName(name: name) {
            saveRequest.delete(contact)
            try! store.execute(saveRequest)
            contactoperationdelegate?.onDeleted()
        }
    }
    
    
    
}


