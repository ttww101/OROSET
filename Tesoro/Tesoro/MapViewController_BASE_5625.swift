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
    
    let mapImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        
        let testView = UIView()
        testView.backgroundColor = .red
        testView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        testView.layer.cornerRadius = testView.frame.width / 2
        testView.layer.masksToBounds = true
        
        
//        self.view.addSubview(testView)
        
    }
    
    func setupViewController() {
        
        //load map imageview
        mapImageView.image = #imageLiteral(resourceName: "示意map")
        mapImageView.frame = CGRect(x: 0, y: 0,
                                    width: ScrollMapView.frame.height * 1.3,
                                    height: ScrollMapView.frame.height)
        mapImageView.contentMode = .scaleAspectFit
        ScrollMapView.addSubview(mapImageView)
        
        //scrollView
        ScrollMapView.contentSize = mapImageView.frame.size
        print(ScrollMapView.contentSize)
        
        //vibrate image view
        userImageView.vibrate(amplitude: 10, duration: 0.5)
        enemyImageView.vibrate(amplitude: 10, duration: 0.5)
        
        //progress stack view
//        userProgressDotsStackView.spacing = userProgressDotsStackView.frame.width / 8
//        userProgressDotsStackView.translatesAutoresizingMaskIntoConstraints = false
//        userProgressDotsStackView.centerXAnchor.constraint(equalTo: crownProgressView.centerXAnchor).isActive = true
//        userProgressDotsStackView.centerYAnchor.constraint(equalTo: crownProgressView.centerYAnchor).isActive = true
//        userProgressDotsStackView.widthAnchor.constraint(equalToConstant: crownProgressView.frame.width - 20).isActive = true
//        userProgressDotsStackView.heightAnchor.constraint(equalToConstant: crownProgressView.frame.height + 10).isActive = true
//        for i in 0...4 {
//            userProgressDotsStackView.subviews[i].layer.cornerRadius = userProgressDotsStackView.frame.height / 5
//
//        }
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
