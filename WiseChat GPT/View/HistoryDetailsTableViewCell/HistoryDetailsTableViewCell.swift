//
//  HistoryDetailsTableViewCell.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 9/3/23.
//

import UIKit

class HistoryDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var robotImageView: UIImageView!
    @IBOutlet weak var robotTextLabel: UILabel!
    @IBOutlet weak var robotView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImageView2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        maksToCornerRound()

    }
    
    // Maks to cornersRound Function
    func maksToCornerRound() {
        if userLabel.text!.count < 28 && robotTextLabel.text!.count < 28 {
            let rectShape = CAShapeLayer()

            rectShape.bounds = robotView.frame
            rectShape.position = robotView.center
            rectShape.path = UIBezierPath(roundedRect: robotView.bounds,    byRoundingCorners: [.topLeft , .topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            robotView.layer.mask = rectShape
            
            let rectShape2 = CAShapeLayer()
            rectShape2.frame = userView.frame
            rectShape2.position = userView.center
            rectShape2.path = UIBezierPath(roundedRect: userView.bounds,    byRoundingCorners: [.topLeft , .topRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            userView.layer.mask = rectShape2
            
        } else {
            let rectShape3 = CAShapeLayer()

            rectShape3.frame = robotView.frame
//            rectShape.position = robotView.center
            rectShape3.path = UIBezierPath(roundedRect: robotView.bounds,    byRoundingCorners: [.topLeft , .topRight, .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
            robotView.layer.mask = rectShape3
            
            let rectShape4 = CAShapeLayer()
            rectShape4.frame = userView.frame
            rectShape4.position = userView.center
            rectShape4.path = UIBezierPath(roundedRect: userView.bounds,    byRoundingCorners: [.topLeft , .topRight, .bottomLeft], cornerRadii: CGSize(width: 15, height: 15)).cgPath
            userView.layer.mask = rectShape4
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
