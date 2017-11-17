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

let fbUrl = "http://ec2-52-37-127-238.us-west-2.compute.amazonaws.com/api/postfb/"
let hrvUrl = "http://ec2-52-37-127-238.us-west-2.compute.amazonaws.com/api/posthrv/"

let mockHrv = [72, 75, 69, 75, 77, 82, 90, 76, 66, 70, 80, 70, 63, 65, 79, 86, 80, 73, 78, 65, 83, 71, 71, 94, 91, 76, 67, 77, 72, 70, 54, 65, 78, 71, 72, 65, 76, 64, 99, 61, 69, 79, 79, 78, 72, 93, 83, 76, 87, 73, 69, 74, 82, 72, 60, 84, 86, 66, 66, 59, 37, 44, 53, 57, 54, 52, 36, 40, 38, 33]

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
            let oldCount = allPosts.count
            print(oldCount)
            connection.add(MyProfileRequest()) { http, result in
                switch result {
                case .success(let response):
                    let newMessages = response.messages.filter{m in self.newestDate == nil || m.0 > self.newestDate!}
                    self.targetCount += newMessages.count
                    for post in newMessages {
                        self.requestScore(text: post.1, cb: {score in
                            self.allPosts.append((post.0, score))
                            if self.allPosts.count == self.targetCount {
                                self.allPosts.sort(by: {(a, b) in a.0 < b.0})
                                self.newestDate = self.allPosts[self.allPosts.count - 1].0
                                let newPosts = self.allPosts[oldCount...oldCount + newMessages.count - 1]
                                for (idx, newPost) in newPosts.enumerated() {
                                    Alamofire.request(fbUrl + "\(newPost.1)/\(idx)" , method: .post)
                                }
                            }
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
        for (idx, hrv) in mockHrv[firstDay + 1...secondDay].enumerated() {
            Alamofire.request(hrvUrl + "\(hrv)/\(idx)" , method: .post)
        }
        sendText(to: mockPhone, body: "X is depressed")
    }
    
    func fetchData() {
        print("Setting up data fetching")
        
        for (idx, hrv) in mockHrv[0...firstDay].enumerated() {
            Alamofire.request(hrvUrl + "\(hrv)/\(idx)" , method: .post)
        }
    
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {timer in
            print("fetching now")
            // let baseline = mockHrv[0...currentDay].reduce(0, +) / mockHeartvar.count
            // print(baseline)
            
            self.updatePosts()
        })
    }
}

let data = Data()
