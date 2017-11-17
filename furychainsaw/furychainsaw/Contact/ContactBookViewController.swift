//
//  ContactBookViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit
import AddressBook

class ContactBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // key for athletes array in NSKeyedArchiver
    var CON_KEY = "contacts_array"
    
    
    let defaults = UserDefaults.standard
    // has all contacts
    var contacts = [Contact]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        // print("test1")
        // get the names of all athletes
        if let data = defaults.data(forKey: CON_KEY), let myContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
            contacts = myContacts
            // print("test")
            // print(contacts.count)
        }
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns length of athletes array
        //print(contacts.count)
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactTableViewCell
        // fills each cell value
        cell.firstname.text = (contacts[indexPath.row].firstname.capitalized)
//        cell.name.text = (athletes[indexPath.row].name).capitalized
//        cell.grade.text = String(athletes[indexPath.row].grade)
//        cell.runnerImageView.image = UIImage(named: "runner.png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // makes the table editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // removes corresponding item in the array_of_links
            contacts.remove(at: indexPath.row)
            var tempContacts : [Contact] = []
            // process of retrieving stored values
            if let data = defaults.data(forKey: CON_KEY), let myContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
                tempContacts = myContacts
            }
            // removing the corresponding index
            tempContacts.remove(at: indexPath.row)
            // refreshes the userdefaults || repositions the array
            defaults.removeObject(forKey: CON_KEY)
            // encodes data
            let encoded = NSKeyedArchiver.archivedData(withRootObject: tempContacts)
            defaults.set(encoded, forKey: CON_KEY)
            // physically removes table in view
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // associated with a cell press
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetail",
            let destination = segue.destination as? ContactDetailViewController,
            let detailIndex = table.indexPathForSelectedRow?.row
        {
            if let data = defaults.data(forKey: CON_KEY), let myContacts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Contact] {
                contacts = myContacts
            }
            // sends destination values
            destination.sentFirstName = self.contacts[detailIndex].firstname
        }
    }

}
