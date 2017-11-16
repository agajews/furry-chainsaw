//
//  ViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name_field: UITextField!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.name_field.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        if name_field.text == "" {
            print("didn't finish filling stuff out")
        }else {
            print("you filled everything out!")
        }
    }


}

