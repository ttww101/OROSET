//
//  TSGFirebaseManager.swift
//  Tesoro
//
//  Created by CuGi on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TSGFirebaseManager: NSObject {
    var ref: DatabaseReference!
    var isServer: Bool = false
    var isOnline: Bool = false
    var isWinnder: Bool = false
    var questions: [String] = []
    var userCount: Int = 0 {
        didSet {
//            if userCount == 2 {
//                self.isServer = false
//            }else {
//                self.isServer = true
//            }
            self.isOnline = true
            print(userCount)
        }
    }
    
    func initServer() {
        self.ref.child("game_states").updateChildValues(["start": false])
        if userCount >= 2 || userCount == 0{
            //server
            //init
            self.isServer = true
            self.ref.child("game_states").child("users").updateChildValues(["user_count": 1])
            self.gmaeOver()
            self.ref.child("game_states").child("users").child("server").updateChildValues(["is_online" : true, "score" : 0])
            self.ref.child("game_states").child("users").child("client").updateChildValues(["is_online" : false, "score" : 0])
            self.ref.child("game_states").updateChildValues(["questions": ["cabbage", "forest" , "juice"]])
            self.ref.child("game_states").child("users").updateChildValues(["is_waitting_client": true])
        }else{
            //client
            self.isServer = false
            self.ref.child("game_states").child("users").updateChildValues(["user_count": userCount + 1])
            self.ref.child("game_states").child("users").child("client").updateChildValues(["is_online" : true])
            self.ref.child("game_states").child("users").updateChildValues(["is_waitting_client": false])
        }
    }
    
    typealias UserStatusCompletionHandler = (_ error:NSError?, _ userStatus: NSDictionary) -> Void
    typealias GameStatusCompletionHandler = (_ error:NSError?, _ gmaeStart: Bool) -> Void
    
    static let share : TSGFirebaseManager = {
        let instance = TSGFirebaseManager()
        return instance
    }()
    
    override init() {
        self.ref = Database.database().reference()
    }
    
    func countContro(){
        ref.child("game_states").child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let userCount = value?["user_count"] as? Int {
                self.userCount = userCount
            }else {
                self.userCount = 0
            }
            self.initServer()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getQuestions(){
        ref.child("game_states").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let questions = value?["questions"] as? [String] ?? []
            if questions.count > 0 {
                self.questions = questions
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func gmaeStart() {
        if isServer {
            self.ref.child("game_states").updateChildValues(["start": true])
        }
    }
    
    func gmaeOver() {
        if isServer {
            self.ref.child("game_states").updateChildValues(["start": false])
        }
    }
    
    func updateScore(score: Int) {
        if self.isServer {
            self.ref.child("game_states").child("users").child("server").updateChildValues(["score" : score])
        }else{
            self.ref.child("game_states").child("users").child("client").updateChildValues(["score" : score])
        }
    }
    
    func userStatusListener(comp: @escaping UserStatusCompletionHandler) {
        ref.child("game_states").observe(DataEventType.childChanged, with: { (snapshot) in
            if let userStatus = snapshot.value as? NSDictionary {
                if let userCount = userStatus.object(forKey: "user_count") as? Int {
                    self.userCount = userCount
                }
                
//                if let isWaittingCerver = userStatus.object(forKey: "is_waitting_client") as? Bool {
//                    if !self.isServer && isWaittingCerver {
//                        self.initServer()
//                    }
//                }
                comp(nil, userStatus)
            }
            
        })
    }
    
    func gameStatusListener(comp: @escaping GameStatusCompletionHandler) {
        ref.child("game_states").observe(DataEventType.childChanged, with: { (snapshot) in
            
            //            isStart
            if let isStart = snapshot.value as? Bool {
                comp(nil, isStart)
            }
            
        })
    }
    
}
