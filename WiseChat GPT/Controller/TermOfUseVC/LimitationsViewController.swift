//
//  LimitationsViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 5/3/23.
//

import UIKit

class LimitationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    @IBAction func limitationsBackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
