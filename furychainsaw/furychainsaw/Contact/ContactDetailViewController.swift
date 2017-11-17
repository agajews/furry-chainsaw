//
//  ContactDetailViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    var sentFullName : String = ""
    var sentPhone : Int = 0
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var fullName: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        // sets labels to corresponding cell values
        fullName.text = sentFullName
        phone.text = String(sentPhone)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
