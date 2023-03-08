//
//  HistoryViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 5/3/23.
//

import UIKit

public var historyArray = [MessageItemList]()

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyBGView: UIView!
    @IBOutlet weak var historyTableView: UITableView!
    
    var selectHistoryItemArray = 0
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
    
    func convertDateFormat(inputDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.date(from: inputDate)
        return inputDate
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
        let historyQuestion = historyArray[indexPath.row]
        let historyDate = "\(historyArray[indexPath.row].createdAt!)"
        let date = convertDateFormat(inputDate: historyDate)
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        cell.historyLabel.text = historyQuestion.question
        cell.timeLabelAdd.text = date
        cell.historylabelBGView.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectHistoryItemArray = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // 1
        let index = 0
//        var deleteItem = historyArray[indexPath.row]
        // 2
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
                //
                let mapAction = UIAction(
                    title: "Delete",
                    image: UIImage(systemName: "trash")) { _ in
                    }
                
                
                // 5
                return UIMenu(title: "", image: nil, children: [mapAction])
            }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let anim = CATransform3DTranslate(CATransform3DIdentity, 500, 100, 0)
        cell.layer.transform = anim
        cell.alpha = 0.3
        
        UIView.animate(withDuration: 0.4){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
    
}
