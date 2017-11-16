//
//  Contact.swift
//  furychainsaw
//
//  Created by Ashwin Aggarwal on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import Foundation
import UIKit

class Contact : NSObject, NSCoding {
    var firstname : String
    var lastname : String
    var phone : Int
    var id : Int
    
    required init(firstname : String, lastname : String, phone : Int, id : Int){
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone
        self.id = id
    }
    
    required init(coder decoder: NSCoder){
        self.firstname = decoder.decodeObject(forKey: "firstname") as? String ?? ""
        self.lastname = decoder.decodeObject(forKey: "lastname") as? String ?? ""
        self.phone = decoder.decodeInteger(forKey: "phone")
        self.id = decoder.decodeInteger(forKey: "id")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(firstname, forKey: "firstname")
        coder.encode(lastname, forKey: "lastname")
        coder.encode(phone, forKey: "phone")
        coder.encode(id, forKey:"id")
    }
}
