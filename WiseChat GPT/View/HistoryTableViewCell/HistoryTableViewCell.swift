//
//  HistoryTableViewCell.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 5/3/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historylabelBGView: UIView!
    @IBOutlet weak var historyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
