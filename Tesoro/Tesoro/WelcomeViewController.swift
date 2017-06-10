//
//  ViewController.swift
//  Tesoro
//
//  Created by CuGi on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
    }

    func connectComponent() {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            
            self.present(vc, animated: true, completion: { 
                
            })
            
        }
        
    }
    
    func setupViewController() {
        
        connectButton.addTarget(self, action: #selector(connectComponent), for: .touchUpInside)
        
    }
    
    
    
}

