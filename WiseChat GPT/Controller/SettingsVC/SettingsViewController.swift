//
//  SettingsViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 28/2/23.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    

}
