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
import FacebookCore

let connection = GraphRequestConnection()

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

let fbUrl = "http://52.37.127.238/api/postfb/"
let hrvUrl = "http://52.37.127.238/api/posthrv/"
let tempUrl = "http://52.37.127.238/api/posttemp/"
let mockUrl = "http://52.37.127.238/api/mockday"

let mockHrv: [Double] = [72, 75, 69, 75, 77, 82, 90, 76, 66, 70, 80, 70, 63, 65, 79, 86, 80, 73, 78, 65, 83, 71, 71, 94, 91, 76, 67, 77, 72, 70, 54, 65, 78, 71, 72, 65, 76, 64, 99, 61, 69, 79, 79, 78, 72, 93, 83, 76, 87, 73, 69, 74, 82, 72, 60, 84, 86, 66, 66, 59, 37, 44, 53, 57, 54, 52, 36, 40, 38, 33]

let mockTemp = [ 98.22284143,  98.79929454,  98.45961613,  98.41712772,
                 97.96367459,  98.14818749,  98.55388506,  98.71323798,
                 98.37979458,  98.25825408,  98.28622595,  98.4782776 ,
                 98.3862218 ,  97.93057665,  99.03002896,  98.47166459,
                 98.31998228,  98.39205376,  98.43791651,  98.34441214,
                 98.12380799,  98.03576089,  97.99188554,  98.47178435,
                 98.26118668,  98.24537048,  98.60231422,  98.80872836,
                 98.53692568,  98.50718894,  98.96055143,  98.29038829,
                 98.44371808,  98.04005067,  98.934649  ,  98.64402952,
                 97.89363178,  98.49392864,  98.64444936,  98.6918899 ,
                 98.20145914,  98.45226952,  98.47456369,  98.51374756,
                 98.14188479,  98.74960947,  97.96353578,  98.5842481 ,
                 98.26937078,  98.2595298 ,  98.18083426,  98.86450125,
                 98.24658326,  98.10864777,  98.48711854,  98.56967772,
                 98.04253586,  97.9886871 ,  98.19585956,  98.13214437] + [ 99.09009849,  98.98328831,  99.32094841,  98.93543486,
                                                                            99.20567045,  99.37735157,  98.82549875,  99.57753664,
                                                                            98.84043425,  99.08131765]

var firstDay = 59
var secondDay = 69
var sentFirstHeart = false
var sentSecondHeart = false


class Data: NSObject {
    var lowVariability = false
    var newestDate: Date? = nil
    var targetCount = 0
    var allPosts: [(Date, Double)] = []
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
    
    func updatePosts() {
        if AccessToken.current != nil {
            struct MyProfileRequest: GraphRequestProtocol {
                struct Response: GraphResponseProtocol {
                    var messages: [(Date, String)] = []
                    init(rawResponse: Any?) {
                        let dict = rawResponse as! NSDictionary
                        let posts = dict["posts"] as! NSDictionary
                        let listOfPosts = posts["data"] as! NSArray
                        for post in listOfPosts {
                            let p = post as! NSDictionary
                            if let message = p["message"] {
                                let created_time = p["created_time"] as! String
                                let m = message as! String
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                let date = dateFormatter.date(from: created_time)!
                                messages.append((date, m))
                            }
                            
                        }
                    }
                }
                
                var graphPath = "/me"
                var parameters: [String : Any]? = ["fields": "id, name, posts.limit(500)"]
                var accessToken = AccessToken.current
                var httpMethod: GraphRequestHTTPMethod = .GET
                var apiVersion: GraphAPIVersion = .defaultVersion
            }
            
            
            let connection = GraphRequestConnection()
            let oldCount = targetCount
            print(oldCount)
            connection.add(MyProfileRequest()) { http, result in
                switch result {
                case .success(let response):
                    var newMessages = response.messages.filter{m in self.newestDate == nil || m.0 > self.newestDate!}
                    newMessages.sort(by: {(a, b) in a.0 < b.0})
                    if newMessages.count > 0 {
                        self.newestDate = newMessages[newMessages.count - 1].0
                    }
                    self.targetCount += newMessages.count
                    for (idx, post) in newMessages.enumerated() {
                        self.requestScore(text: post.1, cb: {score in
                            // self.allPosts.append((post.0, score))
                            print(self.targetCount)
                            print("Getting to \(fbUrl + "\(score)/\(idx + oldCount)")")
                            Alamofire.request(fbUrl + "\(score)/\(idx + oldCount)" , method: .get)
                        })
                    }
                    
                case .failed(let error):
                    print(error)
                }
                
            }
            connection.start()
        }
    }
    
    func mockSadDay() {
        if !sentSecondHeart {
            /* for (idx, hrv) in mockHrv[firstDay + 1...secondDay].enumerated() {
                Alamofire.request(hrvUrl + "\(hrv)/\(firstDay + 1 + idx)" , method: .get)
            }
            for (idx, temp) in mockTemp[firstDay + 1...secondDay].enumerated() {
                Alamofire.request(tempUrl + "\(temp)/\(firstDay + 1 + idx)" , method: .get)
            }*/
            Alamofire.request(mockUrl , method: .get)
            sendText(to: mockPhone, body: "X is depressed")
            sentSecondHeart = true
        }
    }
    
    func fetchData() {
        print("Setting up data fetching")
        
        /* for (idx, hrv) in mockHrv[0...firstDay].enumerated() {
            Alamofire.request(hrvUrl + "\(hrv)/\(idx)" , method: .get)
        }
        for (idx, temp) in mockTemp[0...firstDay].enumerated() {
            Alamofire.request(tempUrl + "\(temp)/\(idx)" , method: .get)
        } */
    
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {timer in
            print("fetching now")
            // let baseline = mockHrv[0...currentDay].reduce(0, +) / mockHeartvar.count
            // print(baseline)
            
            // self.updatePosts()
            if sentSecondHeart {
                Alamofire.request(mockUrl , method: .get)
            }
        })
    }
}

let data = Data()
