//
//  UILabel+Extensions.swift
//  Tesoro
//
//  Created by Lucy on 2017/6/11.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit

extension UILabel {
    
    func flashAnimation(from alpha1: CGFloat, to alpha2: CGFloat, duration time: TimeInterval) {
        
        self.alpha = alpha1
        
        UIView.animate(withDuration: time, animations: {
            
            self.alpha = alpha2
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: time, animations: {
                
                self.alpha = alpha1
                
            }, completion: { (_) in
                
                self.flashAnimation(from: alpha1, to: alpha2, duration: time)
                
            })
            
            
        })
        
    }
    
}
