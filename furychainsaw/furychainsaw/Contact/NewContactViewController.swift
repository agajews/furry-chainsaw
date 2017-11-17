//
//  NewContactViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController, UITextFieldDelegate {

    var CON_KEY = "contacts_array"
    let defaults = UserDefaults.standard

    @IBOutlet weak var firstnameField: UITextField!
    
    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstnameField.delegate = self
        self.lastnameField.delegate = self
        self.phoneField.delegate = self
    }
    
    func dismissKeyboard(){ /*this is a void function*/
        // dismisses keyboards
        firstnameField.resignFirstResponder()
        lastnameField.resignFirstResponder()
        phoneField.resignFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContact(_ sender: Any) {
        var tempContacts = [Contact]()
        var new_id : Int = 0
        if firstnameField.text == "" || lastnameField.text == "" || phoneField.text == "" {
            // show alert
            showAlert(error: "You didn't fill everything out!")
        }else {
            if let data = defaults.data(forKey: CON_KEY), let myContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
                if myContacts != [] {
                    new_id = (myContacts.last?.id)! + 1
                    tempContacts = myContacts
                }
            }
            let newContact = Contact(firstname : firstnameField.text!, lastname : lastnameField.text!, phone : Int(phoneField.text!)!, id : new_id)
            if tempContacts.count == 0 {
                tempContacts = [newContact]
                // assigns athlete value initially since count = 0
                let encoded = NSKeyedArchiver.archivedData(withRootObject: tempContacts)
                defaults.set(encoded, forKey: CON_KEY)
            }else {
                tempContacts.append(newContact)
                // reassigns contact value
                defaults.removeObject(forKey: CON_KEY)
                let encoded = NSKeyedArchiver.archivedData(withRootObject: tempContacts)
                defaults.set(encoded, forKey: CON_KEY)
                
            }
            // dismisses view
            dismiss(animated: true, completion: nil)
        }
    }
    func showAlert(error : String) {
        // creates alert controller with a title, message, and style
        let alertController = UIAlertController(title: "Error!", message:
            error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        // required to show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
