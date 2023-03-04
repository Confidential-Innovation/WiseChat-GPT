//
//  FirstLunchViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 4/3/23.
//

import UIKit

class FirstLunchViewController: UIViewController {

    @IBOutlet weak var startProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 2.5, animations: { () -> Void in
            self.startProgressBar.setProgress(1.0, animated: true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8){
            if let intoVC = loadVCfromStoryBoard(name: "SecondLunch", identifier: "SecondViewController") as? SecondViewController {
                intoVC.modalPresentationStyle = .fullScreen
                self.present(intoVC, animated: true)
            }
        }
    }
    
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }

}
