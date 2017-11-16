//
//  OnFirstViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class OnFirstViewController: UIViewController, UITextFieldDelegate {
    var CON_KEY = "contacts_array"

    // defining textfields
    @IBOutlet weak var firstname_1: UITextField!
    @IBOutlet weak var lastname_1: UITextField!
    @IBOutlet weak var phone_1: UITextField!
    
    @IBOutlet weak var firstname_2: UITextField!
    @IBOutlet weak var lastname_2: UITextField!
    @IBOutlet weak var phone_2: UITextField!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // allowing this controller to retrieve information from the textfields
        self.firstname_1.delegate = self
        self.lastname_1.delegate = self
        self.phone_1.delegate = self
        
        self.firstname_2.delegate = self
        self.lastname_2.delegate = self
        self.phone_2.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){ /*this is a void function*/
         // This will dismiss our keyboard on tap
        firstname_1.resignFirstResponder()
        lastname_1.resignFirstResponder()
        phone_1.resignFirstResponder()
        firstname_2.resignFirstResponder()
        lastname_2.resignFirstResponder()
        phone_2.resignFirstResponder()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func submit(_ sender: Any) {
        var new_id = 0
        var tempContacts = [Contact]()
        if firstname_1.text == "" || lastname_1.text == "" || phone_1.text == "" {
            // show alert
            showAlert(error: "You didn't fill everything out!")
        }else {
            if let data = defaults.data(forKey: CON_KEY), let myContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
                if myContacts != [] {
                    new_id = (myContacts.last?.id)! + 1
                    tempContacts = myContacts
                }
            }
            let newContact = Contact(firstname : firstname_1.text!, lastname : lastname_1.text!, phone : Int(phone_1.text!)!, id : new_id)
            if tempContacts.count == 0 {
                tempContacts = [newContact]
                // assigns athlete value initially since count = 0
                let encoded = NSKeyedArchiver.archivedData(withRootObject: tempContacts)
                defaults.set(encoded, forKey: CON_KEY)
            }else {
                tempContacts.append(newContact)
                // reassigns athletes value
                defaults.removeObject(forKey: CON_KEY)
                let encoded = NSKeyedArchiver.archivedData(withRootObject: tempContacts)
                defaults.set(encoded, forKey: CON_KEY)
                
            }
            // dismisses view
            dismiss(animated: true, completion: nil)
            // let description and phone number be optional
        }

        dismiss(animated: true, completion: nil)
        
    }
    
    // shows appropriate alert
    func showAlert(error : String) {
        // creates alert controller with a title, message, and style
        let alertController = UIAlertController(title: "Error!", message:
            error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        // required to show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
}
