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
    var questions: [String] = []
    var userCount: Int = 0 {
        didSet {
            self.isOnline = true
            self.ref.child("game_state").updateChildValues(["start": false])
            if userCount >= 2 {
                //server
                
                //init
                self.isServer = true
                self.ref.child("game_state").child("user").updateChildValues(["user_count": 1])
                self.ref.child("game_state").child("user").child("server").updateChildValues(["isOnline" : true, "score" : 0])
                self.ref.child("game_state").child("user").child("client").updateChildValues(["isOnline" : false, "score" : 0])
                self.ref.child("game_state").updateChildValues(["questions": ["book", "photo"]])
            }else{
                //client
                self.isServer = false
                self.ref.child("game_state").child("user").updateChildValues(["user_count": userCount + 1])
                self.ref.child("game_state").child("user").child("client").updateChildValues(["isOnline" : true])
            }
            print(userCount)
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
        ref.child("game_state").child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userCount = value?["user_count"] as? Int ?? 0
            self.userCount = userCount
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getQuestions(){
        ref.child("game_state").observeSingleEvent(of: .value, with: { (snapshot) in
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
            self.ref.child("game_state").updateChildValues(["start": true])
        }
    }
    
    func gmaeOver() {
        if isServer {
            self.ref.child("game_state").updateChildValues(["start": false])
        }
    }
    
    func updateScore(score: Int) {
        if self.isServer {
            self.ref.child("game_state").child("user").child("server").updateChildValues(["score" : score])
        }else{
            self.ref.child("game_state").child("user").child("client").updateChildValues(["score" : score])
        }
    }
    
    func userStatusListener(comp: @escaping UserStatusCompletionHandler) {
        ref.child("game_state").observe(DataEventType.childChanged, with: { (snapshot) in
            if let userStatus = snapshot.value as? NSDictionary {
                comp(nil, userStatus)
            }
        })
    }
    
    func gameStatusListener(comp: @escaping GameStatusCompletionHandler) {
        ref.child("game_state").observe(DataEventType.childChanged, with: { (snapshot) in
            
            //            isStart
            if let isStart = snapshot.value as? Bool {
                comp(nil, isStart)
            }
            
        })
    }
    
}
