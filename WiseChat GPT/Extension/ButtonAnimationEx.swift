//
//  ButtonAnimationEx.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 8/3/23.
//

import UIKit

extension UIView {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.90
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.98
        pulse.damping = 10
        layer.add(pulse, forKey: "pulse")
    }
}
