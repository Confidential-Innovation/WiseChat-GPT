//
//  SecondViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 4/3/23.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var askButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        askButton.layer.cornerRadius = 12

    }
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }

    
    @IBAction func startQuestionButton(_ sender: UIButton) {
        if let vc = loadVCfromStoryBoard(name: "Home", identifier: "HomeViewController") as? HomeViewController{
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
