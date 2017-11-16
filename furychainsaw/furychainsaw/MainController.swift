//
//  ViewController.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import UIKit
import HealthKit

class MainController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name_field: UITextField!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if HKHealthStore.isHealthDataAvailable() {
//            let healthStore = HKHealthStore()

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let someDateTime = formatter.date(from: "2016/10/08 22:31")
            
            let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
            
            let quantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 72.0)
            let quantitySample = HKQuantitySample(type: quantityType!, quantity: quantity, start: someDateTime!, end: Date())
            
            print(quantitySample)
            
        }
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

