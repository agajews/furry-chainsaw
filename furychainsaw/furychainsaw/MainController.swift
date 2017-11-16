//
//  ViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITextFieldDelegate {

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        // if this is true, then don't popup view
        if let _ = UserDefaults.standard.value(forKey: "fffirst") {
        }else {
            // manages the onboarding screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "of")
            UserDefaults.standard.setValue("hasLaunched", forKey: "fffirst")
            self.present(controller, animated: true, completion: nil)
        }
    }



}

