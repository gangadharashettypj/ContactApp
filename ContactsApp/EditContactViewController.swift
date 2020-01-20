//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Gangadharan on 17/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class EditCOntactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var editContact: ContactModel?
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var contactoperationdelegate: ContactOperationDelegate?
    
    @IBOutlet weak var contactname: UITextField!
    @IBOutlet weak var contactPhone: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        contactname.text = editContact?.name
        contactPhone.text = editContact?.phone
        contactEmail.text = editContact?.email
        contactImage.image = editContact?.image
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contactImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeImageTapped(_ sender: Any) {
            present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
        updateContact(name: contactname.text!, phone: contactPhone.text!, email: contactEmail.text! as NSString, data: (contactImage.image?.pngData())!)
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateContact(name: String, phone: String, email: NSString, data: Data) {
        let contact: CNMutableContact = getContactWithName(name: name)?.mutableCopy() as! CNMutableContact
        
        contact.givenName = name
        contact.imageData = data
        contact.emailAddresses = [CNLabeledValue(label:CNLabelWork, value:email)]
         
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:phone))]
         
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        saveRequest.update(contact)
        try! store.execute(saveRequest)
        
        contactoperationdelegate?.onEdited()
    }
}
