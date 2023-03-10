//
//  SettingsViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 28/2/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingRobotGifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingRobotGifPlay()
    }
    
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func contactActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func writeAReviewActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func privactyPolicyActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func shareAppActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func TermsOfUseActionButton(_ sender: UIButton) {
        let st = UIStoryboard(name: "Term", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    private func settingRobotGifPlay() {
        let imageName = UIImage.gifImageWithName("robot gif")
        settingRobotGifView.image = imageName
    }
}


extension SettingsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
