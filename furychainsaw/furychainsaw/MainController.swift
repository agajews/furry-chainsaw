//
//  ViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITextFieldDelegate {
    @IBAction func mockSadDay(_ sender: Any) {
        data.mockSadDay()
    }
    @IBOutlet weak var mocksadday: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mocksadday.layer.cornerRadius = 4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // if this is true, then don't popup view
        if let _ = UserDefaults.standard.value(forKey: "fffirst") {
            // data.fetchData()
        }else {
            // manages the onboarding screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "of")
            UserDefaults.standard.setValue("hasLaunched", forKey: "fffirst")
            self.present(controller, animated: true, completion: nil)
        }
    }

}

