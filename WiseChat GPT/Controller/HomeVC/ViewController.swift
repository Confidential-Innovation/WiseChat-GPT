//
//  ViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 25/2/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wiseChatTextView: UITextView!
    @IBOutlet weak var wiseChatTableView: UITableView!
    
    @IBOutlet weak var placeHolderTextLabel: UILabel!
    
    var chat = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabelViewCell()
        setupUI()
        
    }
    
    private func setupUI() {
        wiseChatTextView.layer.borderColor = .init(red: 33/33, green: 200/4, blue: 222/3, alpha: 1)
        wiseChatTextView.layer.borderWidth = 1
        wiseChatTextView.layer.cornerRadius = 15
        wiseChatTextView.delegate = self
        placeHolderTextLabel.alpha = 0.5
        wiseChatTextView.textColor = UIColor.black
    }
    
    func setupTabelViewCell() {
        let nib = UINib(nibName: "WiseChatTableViewCell", bundle: nil)
        wiseChatTableView.register(nib, forCellReuseIdentifier: "cell")
        wiseChatTableView.separatorColor = .none
        wiseChatTableView.delegate = self
        wiseChatTableView.dataSource = self
    }
    
    // Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    private func scrollToButton() {
        let topRow = IndexPath(row: chat.count-1, section: 0)
        UIView.animate(withDuration: 0.3) {
            self.wiseChatTableView.scrollToRow(at: topRow, at: .bottom, animated: true)
            self.view.layoutIfNeeded()
        }
    }

    private func fetchChatGPTForResponse(prompt: String) {
        Task {
            do {
                let gptText = try await APIService().sendPromtToGPT(promt: prompt)
                await MainActor.run {
                    chat.append(prompt)
                    chat.append(gptText.replacingOccurrences(of: "\n\n", with: ""))
                    wiseChatTableView.reloadData()
                }
            } catch {
                print("Error")
            }
        }
    }
    
    @IBAction func wiseChatScannerActionButton(_ sender: UIButton) {
    }
    
    @IBAction func wiseChatSendButtonAction(_ sender: UIButton) {
        wiseChatTextView.resignFirstResponder()
        if let promptText = wiseChatTextView.text, promptText.count > 0 {
            fetchChatGPTForResponse(prompt: promptText)
            placeHolderTextLabel.isHidden = false
            wiseChatTextView.text = ""
            
        } else {
            print("Please check textfield")
        }
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = wiseChatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WiseChatTableViewCell
            cell.selectionStyle = .none
            cell.wiseChatTextLabel?.text = chat[indexPath.row]
            cell.bgcellView.backgroundColor = .systemBlue
            cell.bgcellView.layer.cornerRadius = 10
            cell.wiseChatImageView.image = UIImage(named: "man")
            return cell

        } else {
            let cell = wiseChatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WiseChatTableViewCell
            cell.selectionStyle = .none
            cell.bgcellView.backgroundColor = .systemGray
            cell.wiseChatTextLabel?.text = chat[indexPath.row]
            cell.wiseChatImageView.image = UIImage(named: "robot")
            return cell

        }
    }
    
}

extension ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("\(String(describing: wiseChatTextView.text))")
        placeHolderTextLabel.isHidden = !wiseChatTextView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        wiseChatTextView.becomeFirstResponder()
        if chat.count > 0 {
            scrollToButton()
        }
    }
}
