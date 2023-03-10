//
//  ViewMaskEx.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 10/3/23.
//

import UIKit
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
