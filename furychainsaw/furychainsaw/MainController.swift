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
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if HKHealthStore.isHealthDataAvailable() {
            let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            let readTypes = Set([quantityType])
            
            healthStore.requestAuthorization(toShare: Set(), read: readTypes) { (success, error) -> Void in
                if success == false {
                    print("Display not allowed")
                }
            }
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if error != nil {
                    print("HK error")
                    return
                }
                
                if let result = tmpResult {
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.InBed.rawValue) ? "InBed" : "Asleep"
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        }
                    }
                }
            }
            
            healthStore.executeQuery(query)
            
            // let quantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 72.0)
            // let quantitySample = HKQuantitySample(type: quantityType!, quantity: quantity, start: someDateTime!, end: Date())
            
            // print(quantitySample)
            
        }
        self.name_field.delegate = self
        
    }
    
    @IBAction func submit(_ sender: Any) {
        if name_field.text == "" {
            print("didn't finish filling stuff out")
        }else {
            print("you filled everything out!")
        }
    }


}

