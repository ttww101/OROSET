//
//  UIImageView+Extensions.swift
//  Tesoro
//
//  Created by Lucy on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func vibrate(amplitude: CGFloat, duration time: TimeInterval) {
        
        
            UIView.animate(withDuration: time, animations: {
                
                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY + amplitude, width: self.frame.width, height: self.frame.height)
                
            }, completion: { (_) in
                
                UIView.animate(withDuration: time, animations: {
                    
                    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY - amplitude, width: self.frame.width, height: self.frame.height)
                    
                }, completion: { (_) in
                    
                    self.vibrate(amplitude: amplitude, duration: time)
                    
                })
                
                
            })
        
    }
    
}
