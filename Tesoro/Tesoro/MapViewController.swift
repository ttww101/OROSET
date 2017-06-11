//
//  MapViewController.swift
//  Tesoro
//
//  Created by Lucy on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var ScrollMapView: UIScrollView!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var enemyProgressView: UIView!
    @IBOutlet weak var enemyProgressDotsStackView: UIStackView!
    var myScore = 0 {
        didSet {
            print("我的分數變動為\(myScore)")
            if myScore >= 6 {
                TSGFirebaseManager.share.isWinnder = true
                TSGFirebaseManager.share.gmaeOver()
                userMove(to: myScore)
            }
        }
    }
    var enemyScore = 0{
        didSet {
            enemyMove(to: enemyScore)
            print("敵人的分數變動為\(enemyScore)")
        }
    }
    @IBOutlet weak var game1Button: UIButton!
    @IBOutlet weak var game2Button: UIButton!
    @IBOutlet weak var game3Button: UIButton!
    @IBOutlet weak var game4Button: UIButton!
    @IBOutlet weak var game5Button: UIButton!
    
    let mapImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        
        TSGFirebaseManager.share.userStatusListener { (error, userStatus) in
            if TSGFirebaseManager.share.isServer {
                if let serverDic = userStatus.object(forKey: "server") as? NSDictionary,
                    let serverScore = serverDic.object(forKey: "score") as? Int{
                    self.myScore = serverScore
                }
                if let clientDic = userStatus.object(forKey: "client") as? NSDictionary,
                    let enemScore = clientDic.object(forKey: "score") as? Int{
                    self.enemyScore = enemScore
                }
            }else {
                if let clientDic = userStatus.object(forKey: "client") as? NSDictionary,
                    let serverScore = clientDic.object(forKey: "score") as? Int{
                    self.myScore = serverScore
                }
                if let serverDic = userStatus.object(forKey: "server") as? NSDictionary,
                    let enemScore = serverDic.object(forKey: "score") as? Int{
                    self.enemyScore = enemScore
                }
            }
//            print("User 狀態變動\(userStatus)")
//            if userStatus.key
        }
        
        TSGFirebaseManager.share.gameStatusListener { (error, isGameStart) in
            if (isGameStart) {
                print("遊戲開始")
            }else{
                print("遊戲結束")
                if TSGFirebaseManager.share.isWinnder {
                    print("贏家")
                }else {
                    print("輸家")
                }
            }
        }
        
    }
    
    func userMove(to game: Int) {
        
        switch game {
            
        case 1:
            
            let p1 = CGPoint(x: self.userImageView.frame.midX, y: self.userImageView.frame.midY)
            let p2 = CGPoint(x: game1Button.frame.midX, y: game1Button.frame.midY)
            self.addLine(fromPoint: p1, toPoint: p2)
            
            UIView.animate(withDuration: 3, animations: {
                
                self.userImageView.frame = self.game1Button.frame
                
            }) { (_) in
                
                
            }
            
        case 2:
            
            let p1 = CGPoint(x: self.userImageView.frame.midX, y: self.userImageView.frame.midY)
            let p2 = CGPoint(x: game2Button.frame.midX, y: game2Button.frame.midY)
            self.addLine(fromPoint: p1, toPoint: p2)
            
            UIView.animate(withDuration: 3, animations: {
                
                self.userImageView.frame = self.game2Button.frame
                
            }) { (_) in
                
                
            }
            
        case 3:
            
            let p1 = CGPoint(x: self.userImageView.frame.midX, y: self.userImageView.frame.midY)
            let p2 = CGPoint(x: game3Button.frame.midX, y: game3Button.frame.midY)
            self.addLine(fromPoint: p1, toPoint: p2)
            
            UIView.animate(withDuration: 3, animations: {
                
                self.userImageView.frame = self.game3Button.frame
                
            }) { (_) in
                
                
            }
            
        default:
            break
        }
        
    }
    
    func enemyMove(to game: Int) {
        
        UIView.animate(withDuration: 1.5) {
            
            let destination_midX = self.enemyProgressDotsStackView.frame.minX + self.enemyProgressDotsStackView.subviews[game].frame.midX
            
            self.enemyImageView.frame = CGRect(x: destination_midX - self.enemyImageView.frame.width/2,
                                          y: self.enemyImageView.frame.minY,
                                          width: self.enemyImageView.frame.width,
                                          height: self.enemyImageView.frame.height)

        }
        
    }
    
    
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 5
        line.lineJoin = kCALineJoinMiter
        line.miterLimit = 1
        self.ScrollMapView.layer.addSublayer(line)
        
        // layer animation
//        let myAnimation = CABasicAnimation(keyPath: "path")
//        
//        myAnimation.fromValue = linePath.cgPath
//        myAnimation.toValue = linePath.cgPath
//        myAnimation.duration = 0.4
//        myAnimation.fillMode = kCAFillModeForwards
//        myAnimation.isRemovedOnCompletion = false
//        
//        self.view.layer.mask?.add(myAnimation, forKey: "animatePath")
        
    }
    
    func startGame(sender: UIButton) {
        
        enemyMove(to: sender.tag)
        
        let p1 = CGPoint(x: self.userImageView.frame.midX, y: self.userImageView.frame.midY)
        let p2 = CGPoint(x: sender.frame.midX, y: sender.frame.midY)
        self.addLine(fromPoint: p1, toPoint: p2)
        
        UIView.animate(withDuration: 3, animations: {
            
            self.userImageView.frame = sender.frame
            
        }) { (_) in
            
            
        }
        
    }
    
    func setupViewController() {
        //load map imageview
        mapImageView.image = #imageLiteral(resourceName: "Tresure Map")
        mapImageView.frame = CGRect(x: 0, y: 0,
                                    width: ScrollMapView.frame.height * 1.3,
                                    height: ScrollMapView.frame.height)
        mapImageView.contentMode = .scaleAspectFit
        ScrollMapView.addSubview(mapImageView)
        
        //scrollView
        ScrollMapView.contentSize = mapImageView.frame.size
        print(ScrollMapView.contentSize)
        
        //game button
        game1Button.imageView?.contentMode = .scaleAspectFit
        game1Button.frame = CGRect(x: mapImageView.frame.width/8, y: mapImageView.frame.height/4, width: 100, height: 100)
        ScrollMapView.addSubview(game1Button)
        
        game2Button.imageView?.contentMode = .scaleAspectFit
        game2Button.frame = CGRect(x: mapImageView.frame.width/4, y: mapImageView.frame.height/2, width: 100, height: 100)
        ScrollMapView.addSubview(game2Button)
        
        game3Button.imageView?.contentMode = .scaleAspectFit
        game3Button.frame = CGRect(x: mapImageView.frame.width/3, y: mapImageView.frame.height/5, width: 120, height: 120)
        ScrollMapView.addSubview(game3Button)
        
        game4Button.imageView?.contentMode = .scaleAspectFit
        game4Button.frame = CGRect(x: mapImageView.frame.width * 1/2, y: mapImageView.frame.height * 2/5, width: 100, height: 100)
        ScrollMapView.addSubview(game4Button)
        
        game5Button.imageView?.contentMode = .scaleAspectFit
        game5Button.frame = CGRect(x: mapImageView.frame.width * 4 / 5, y: mapImageView.frame.height/10, width: 100, height: 100)
        ScrollMapView.addSubview(game5Button)
        
        game1Button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        game2Button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        game3Button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        game4Button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        game5Button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        ScrollMapView.addSubview(userImageView)
        userImageView.frame = CGRect(x: mapImageView.frame.width/15, y: mapImageView.frame.height/8, width: 40, height: 40)
        
        //vibrate image view
        userImageView.vibrate(amplitude: 10, duration: 0.5)
        enemyImageView.vibrate(amplitude: 10, duration: 0.5)
        
        //progress stack view
        enemyProgressDotsStackView.spacing = enemyProgressDotsStackView.frame.width / 8
        enemyProgressDotsStackView.translatesAutoresizingMaskIntoConstraints = false
        enemyProgressDotsStackView.centerXAnchor.constraint(equalTo: enemyProgressView.centerXAnchor).isActive = true
        enemyProgressDotsStackView.centerYAnchor.constraint(equalTo: enemyProgressView.centerYAnchor).isActive = true
        enemyProgressDotsStackView.widthAnchor.constraint(equalToConstant: enemyProgressView.frame.width - 20).isActive = true
        enemyProgressDotsStackView.heightAnchor.constraint(equalToConstant: enemyProgressView.frame.height + 10).isActive = true
        for i in 0...4 {
            enemyProgressDotsStackView.subviews[i].layer.cornerRadius = enemyProgressDotsStackView.frame.height / 5
        }
        
    }

}
