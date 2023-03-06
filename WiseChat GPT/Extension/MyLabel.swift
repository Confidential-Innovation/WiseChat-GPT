//
//  HistoryEmtyLabel.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 5/3/23.
//

import UIKit

class MyLabel: UILabel {

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initializeLabel()
  }

  override init(frame: CGRect) {
      super.init(frame: frame)
      initializeLabel()
  }

  func initializeLabel() {

      self.textAlignment = .center
      self.font = UIFont.systemFont(ofSize: 25)
      self.textColor = UIColor.white
  }

}
