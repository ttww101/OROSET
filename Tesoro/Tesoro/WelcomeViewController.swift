//
//  ViewController.swift
//  Tesoro
//
//  Created by CuGi on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit
import Spring

class WelcomeViewController: UIViewController {

    @IBOutlet weak var appNameLabel: SpringLabel!
//    @IBOutlet weak var swordImageView: SpringImageView!
    @IBOutlet weak var connectButton: SpringButton!
    
    var userCount: Int = 0 {
        didSet {
            if userCount == 2 {
                self.connectButton.isEnabled = isServer
                self.connectButton.animate()
            }else {
                self.connectButton.isEnabled = false
            }
        }
    }
    var isServer  = false 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
        TSGFirebaseManager.share.gameStatusListener { (error, isGameStart) in
            if (isGameStart) {
                print("遊戲開始")
                self.connectGame()
            }else{
                print("遊戲結束")
                if TSGFirebaseManager.share.isWinnder {
                    print("贏家")
                }
            }
        }
        
        TSGFirebaseManager.share.userStatusListener { (error, userStatus) in
            self.isServer = TSGFirebaseManager.share.isServer
            self.userCount = TSGFirebaseManager.share.userCount
//            print("User 狀態變動\(userStatus)")
        }
        
        
        
    }
    
    func connectGame() {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            
            TSGFirebaseManager.share.gmaeStart()
            
            self.present(vc, animated: true, completion: { 
                
            })
            
        }
        
    }
    
    func setupViewController() {
        
        connectButton.isEnabled = false
        connectButton.imageView?.contentMode = .scaleAspectFit
        connectButton.addTarget(self, action: #selector(connectGame), for: .touchUpInside)
        
        appNameLabel.flashAnimation(from: 0.7, to: 0.1, duration: 1.5)
    }
    
    
    
}

