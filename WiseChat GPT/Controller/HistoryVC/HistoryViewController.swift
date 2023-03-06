//
//  HistoryViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 5/3/23.
//

import UIKit
var historyArray = [String]()
class HistoryViewController: UIViewController {

    @IBOutlet weak var historyBGView: UIView!
    @IBOutlet weak var historyTableView: UITableView!
    lazy var historyEmtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "History is Emty!"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableViewCellSetup()
        chackHistoryArrayNill()

    }
    
    // MARK:   Private methods
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    private func chackHistoryArrayNill() {
        if historyArray.count == 0 {
            historyTableView.isHidden = true
            historyBGView.addSubview(historyEmtyLabel)
            historyEmtyLabel.centerXAnchor.constraint(equalTo: historyBGView.centerXAnchor).isActive = true
            historyEmtyLabel.centerYAnchor.constraint(equalTo: historyBGView.centerYAnchor).isActive = true
        
        } else {
            
            historyTableView.isHidden = false
        }
    }
    
    @IBAction func historyBackActionButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func historyTableViewCellSetup() {
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        historyTableView.register(nib, forCellReuseIdentifier: "cell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        cell.historyLabel.text = historyArray[indexPath.row]
        cell.historylabelBGView.layer.cornerRadius = 15
        return cell
    }
}
