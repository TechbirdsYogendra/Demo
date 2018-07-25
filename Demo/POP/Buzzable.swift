//
//  Fuzzable.swift
//  Demo
//
//  Created by Yogendra on 7/10/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import Foundation
import UIKit

protocol Buzzable {}
extension Buzzable where Self: UIView {
    
    func buzz() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}
