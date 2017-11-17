//
//  Data.swift
//  furychainsaw
//
//  Created by Alex Gajewski on 11/16/17.
//  Copyright © 2017 Ashwin Aggarwal. All rights reserved.
//

import Foundation
import ToneAnalyzerV3
import Alamofire

let username = "ea1084fe-510b-4010-bbd0-7ef2a085e119"
let password = "WzYSjsR18jgZ"

let version = "2017-5-16" // use today's date for the most recent version
let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)

let failure = { (error: Error) in
    print("Failed")
    print(error)
}

let twilioAccount = "AC93621d61ba0285d60b27d00febfc1b77"
let twilioToken = "2e988b61145768c30b7da1b6edadea2b"
let twilioPhone = "+12243343599"
let mockPhone = "+13126364192"
let mockBody = "Test Text"

let twilioUrl = "https://api.twilio.com/2010-04-01/Accounts/\(twilioAccount)/Messages.json"


class Data: NSObject {
    func requestScore(text: String, cb: @escaping (Double) -> Void) {
        toneAnalyzer.getTone(ofText: text, failure: failure) { tones in
            var sadness: Double = 0
            let emotions = tones.documentTone.filter{(category: ToneCategory) in category.categoryID == "emotion_tone"}
            if emotions.count > 0 {
                let sadness_tones = emotions[0].tones.filter{(tone: ToneScore) in tone.id == "sadness"}
                if sadness_tones.count > 0 {
                    sadness = sadness_tones[0].score
                } else {
                    print("No sadness")
                }
            } else {
                print("No emotions")
            }
            cb(sadness)
        }
    }
    
    func sendText(to: String, body: String) {
        Alamofire.request(twilioUrl, method: .post, parameters: ["To": to, "From": twilioPhone, "Body": body])
            .authenticate(user: twilioAccount, password: twilioToken)
            .responseString{response in
                print(response)
        }
    }
    
    func fetchData() {
        print("Fetching data")
        requestScore(text: "I'm feeling pretty sad right now", cb: {sadness in
            print(sadness)
        })
    }
    
    var timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {timer in
        print("fetching now")
    })
}

let data = Data()
