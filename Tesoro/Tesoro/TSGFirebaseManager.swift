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
    var isServer: Bool!
    var questions: [String] = []
    var userCount: Int = 0 {
        didSet {
            self.ref.child("game_state").updateChildValues(["start": false])
            if userCount >= 2 {
                //server
                
                //init
                isServer = true
                self.ref.child("game_state").child("user").updateChildValues(["user_count": 1])
                self.ref.child("game_state").child("user").child("server").updateChildValues(["isOnline" : true])
                self.ref.child("game_state").child("user").child("client").updateChildValues(["isOnline" : false])
                self.ref.child("game_state").updateChildValues(["questions": ["book", "photo"]])
            }else{
                //client
                isServer = false
                self.ref.child("game_state").child("user").updateChildValues(["user_count": userCount + 1])
                self.ref.child("game_state").child("user").child("client").updateChildValues(["isOnline" : true])
            }
            print(userCount)
        }
    }
    
    typealias CountCompletionHandler = (_ error:NSError?, _ userCount: Int) -> Void
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
    
    func userCountListener(comp: @escaping CountCompletionHandler) {
        ref.child("game_state").observe(DataEventType.childChanged, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let userCount = value?["user_count"] as? Int else {
                return
            }
            if userCount > 0 {
                comp(nil, userCount)
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
    
    func gmaeStart() {
        if isServer {
            self.ref.child("game_state").updateChildValues(["start": true])
        }
    }
    
}
