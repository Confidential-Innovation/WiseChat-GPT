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
}


extension SettingsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
