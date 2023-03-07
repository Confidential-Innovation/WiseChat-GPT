//
//  SecondViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 4/3/23.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var letsGoGifView: UIView!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var letsGoImageView: UIImageView!
    @IBOutlet weak var messageGifView: UIImageView!
    @IBOutlet weak var askView1: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifPlayFunction()
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
    
    private func gifPlayFunction() {
        askView1.layer.cornerRadius = 20
        let imageName = UIImage.gifImageWithName("let's go gif")
        let imageName2 = UIImage.gifImageWithName("contact us")
        letsGoImageView.image = imageName
        messageGifView.image = imageName2
    }
}
