//
//  FetchContacts.swift
//  ContactsApp
//
//  Created by Gangadharan on 17/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

let contactStore = CNContactStore()

func getContactsContainer() -> [CNContainer] {
    var allContainers: [CNContainer] = []
    let contactStore = CNContactStore()
    do {
        allContainers = try contactStore.containers(matching: nil)
    } catch {
        print("Error fetching containers")
    }
    return allContainers
}

func getCOntactsINContainer(fetchPredicate: NSPredicate , keysToFetch: [CNKeyDescriptor]) -> [CNContact] {
    
    do{
        return try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch )
    } catch {
        print("Error fetching containers")
    }
    return []
}

func getContactWithName(name: String) -> CNMutableContact?{
    
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey] as [Any]

    for container in getContactsContainer() {
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

        let containerResults = getCOntactsINContainer(fetchPredicate: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        for contact in containerResults {
            if contact.givenName == name {
                return contact.mutableCopy() as? CNMutableContact
            }
        }
    }
    return nil
}

func getContacts() -> [ContactModel]{

    var contacts: [ContactModel] = []
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey] as [Any]
    
    for container in getContactsContainer() {
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

        let containerResults = getCOntactsINContainer(fetchPredicate: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        for contact in containerResults {
            var email: String = ""
            if contact.emailAddresses.count > 0 {
                email = contact.emailAddresses[0].value as String
            }
            if let data = contact.imageData {
                contacts.append(ContactModel(name: contact.givenName, phone: contact.phoneNumbers[0].value.stringValue, image: UIImage(data: data)!, email: email))
            }else {
                contacts.append(ContactModel(name: contact.givenName, phone: contact.phoneNumbers[0].value.stringValue, image: UIImage(named: "person")!, email: email))
            }
        }
    }
    
    return contacts
}

func getContactsNames() -> [String]{

    var names: [String] = []
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName)] as [Any]

    for container in getContactsContainer() {
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
        let containerResults = getCOntactsINContainer(fetchPredicate: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        for contact in containerResults {
            names.append(contact.givenName)
        }
    }
    return names
}
