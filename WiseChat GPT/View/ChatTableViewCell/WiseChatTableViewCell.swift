//
//  WiseChatTableViewCell.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 25/2/23.
//

import UIKit

class WiseChatTableViewCell: UITableViewCell {

    @IBOutlet weak var bgcellView: UIView!
    @IBOutlet weak var wiseChatTextLabel: UILabel!
    @IBOutlet weak var wiseChatImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


