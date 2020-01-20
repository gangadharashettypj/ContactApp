//
//  AddContactController.swift
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

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

}

class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var emailLabel: UITextField!
    
    var imagePicker = UIImagePickerController()
    var contactopertaiondelegate: ContactOperationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contactImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        let name: String = nameLabel.text!
        if name == "" {
            self.view.makeToast("Please enter a valid name")
            return
        }
        
        if !name.matches("^[a-zA-Z]+(.)*") {
            self.view.makeToast("Please enter a valid name, name must start with alphabets")
            return
        }
        
        if getContactsNames().contains(name) {
            self.view.makeToast("Contact with a name '\(name)' alread exist")
            return
        }
        
        let phone: String = phoneLabel.text!
        if phone == "" || phone.count < 10 || phone.count > 10 {
            self.view.makeToast("Phone number must be of length 10")
            return
        }
        
        let email: NSString = emailLabel.text! as NSString
        if email == "" || !emailLabel.text!.isValidEmail() {
            self.view.makeToast("Please enter a valid email")
            return
        }
        
        let data: Data = (contactImage.image!.pngData())!
        
        storeContact(name: name, phone: phone, email: email, data: data)
        
    }
    @IBAction func chooseImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onAdded() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func storeContact(name: String, phone: String, email: NSString, data: Data) {
        let contact = CNMutableContact()
        
        contact.givenName = name.trimmingCharacters(in: .whitespaces)
        contact.imageData = data
        contact.emailAddresses = [CNLabeledValue(label:CNLabelWork, value:email)]
         
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:phone))]
         
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
        
        self.view.makeToast("Contact added sucessfully")
        perform(#selector(onAdded), with: nil, afterDelay: 1)
        contactopertaiondelegate?.onAdded()
    }
    
}


