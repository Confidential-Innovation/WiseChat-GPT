//
//  ViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 25/2/23.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var wiseChatTextView: UITextView!
    @IBOutlet weak var wiseChatTableView: UITableView!
    @IBOutlet weak var placeHolderTextLabel: UILabel!
    @IBOutlet weak var bottomNSLayoutView: NSLayoutConstraint!
        
    var activityView: UIActivityIndicatorView?
    let container: UIView = UIView()

    
    var chat = [String]()
    var request = VNRecognizeTextRequest(completionHandler: nil)
    var textShare = ""
    var keyboradHeight = 0


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabelViewCell()
        setupUI()
        showActivityIndicatory()
        keyBoardHeightGet()
    }
    
    // MARK: - Private method
    
    func keyBoardHeightGet(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.wiseChatTextView.becomeFirstResponder()

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboradHeight = Int(keyboardRectangle.height)
            UIView.animate(withDuration: 0.2){
                self.bottomNSLayoutView.constant  = CGFloat(self.keyboradHeight)
                self.view.layoutIfNeeded()
            }
            print(keyboradHeight)

        }
    }

    func showActivityIndicatory() {
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 75)
        container.backgroundColor = .white
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.color = .black
        activityView?.center = container.center
        container.center = self.view.center
        container.addSubview(activityView!)
        self.view.addSubview(container)
        container.isHidden = true
        container.layer.cornerRadius = 10
        wiseChatTableView.alpha = 1.0
    }

    private func recongnizeText(image: UIImage){
        // setup TextRecognition
        
        activityView?.startAnimating()
        wiseChatTableView.alpha = 0.4
        container.isHidden = false
        activityView?.isHidden = false
        var textString = ""

        request = VNRecognizeTextRequest(completionHandler: {(request, error) in

            guard let observations = request.results as? [VNRecognizedTextObservation] else {fatalError("Recieved invalid Observation")}

            for observation in observations{
                guard let topCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }

                textString += "\(topCandidate.string)"

                DispatchQueue.main.async { [self] in
                    wiseChatTextView.text = textString
                    placeHolderTextLabel.isHidden = !wiseChatTextView.text.isEmpty
                    activityView?.stopAnimating()
                    wiseChatTableView.alpha = 1.0
                    activityView?.isHidden = true
                    container.isHidden = true
                }
            }
        })

        /// add some properties
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US","fr-FR", "zh-Hans"]
        request.minimumTextHeight = 0.05
        request.usesLanguageCorrection = true

        let requests = [request]

        /// creating request handler
        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = image.cgImage else {fatalError("Missing image scan")}
            let handle = VNImageRequestHandler(cgImage: img, options: [:])
            try? handle.perform(requests)
        }
    }
   
    private func setupUI() {
        wiseChatTextView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        wiseChatTextView.layer.borderWidth = 1.5
        wiseChatTextView.layer.cornerRadius = 15
        wiseChatTextView.delegate = self
        placeHolderTextLabel.alpha = 0.5
        wiseChatTextView.delegate = self
        wiseChatTextView.textColor = UIColor.black
        keyboardTapToHide()
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
                    scrollToButton()
                }
            } catch {
                print("Error! Your api key is already used.\nPlease Change your API Key?")
            }
        }
    }
    
    @IBAction func wiseChatScannerActionButton(_ sender: UIButton) {
        let imagePhotoLibraryPicker = UIImagePickerController()
        imagePhotoLibraryPicker.delegate = self
        imagePhotoLibraryPicker.allowsEditing = true
        imagePhotoLibraryPicker.sourceType = .camera
        imagePhotoLibraryPicker.modalPresentationStyle = .fullScreen
        self.present(imagePhotoLibraryPicker, animated: true, completion: nil)
    }
    
    @IBAction func wiseChatSendButtonAction(_ sender: UIButton) {
        wiseChatTextView.resignFirstResponder()
        let promptText = wiseChatTextView.text
        self.fetchChatGPTForResponse(prompt: promptText!)
        UIView.animate(withDuration: 0.3){
            self.bottomNSLayoutView.constant  = 0
            self.view.layoutIfNeeded()
        }
        placeHolderTextLabel.isHidden = false
        wiseChatTextView.text = ""
    }
    
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        let st = UIStoryboard(name: "Settings", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "SettingsViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
            cell.wiseChatTextLabel.textColor = .white
            cell.bgcellView.backgroundColor = #colorLiteral(red: 0, green: 0.352879107, blue: 1, alpha: 1)
            cell.bgcellView.layer.cornerRadius = 10
            cell.bgcellView.layer.shadowColor = UIColor.blue.cgColor
            cell.bgcellView.layer.shadowOpacity = 1
            cell.bgcellView.layer.shadowOffset = CGSize.zero
            cell.bgcellView.layer.shadowRadius = 1.5
            cell.bgcellView.layer.borderColor = .init(red: 137, green: 207, blue: 240, alpha: 0.1)
            cell.bgcellView.layer.borderWidth = 1.5
            cell.wiseChatImageView.image = UIImage(named: "man")
            return cell

        } else {
            let cell = wiseChatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WiseChatTableViewCell
            cell.selectionStyle = .none
            cell.bgcellView.backgroundColor = #colorLiteral(red: 0.9143115878, green: 0.9542326331, blue: 0.9878992438, alpha: 1)
            cell.bgcellView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.bgcellView.layer.borderWidth = 1.5
            cell.bgcellView.layer.shadowColor = UIColor.black.cgColor
            cell.bgcellView.layer.shadowOpacity = 1
            cell.bgcellView.layer.shadowOffset = CGSize.zero
            cell.bgcellView.layer.shadowRadius = 1.5
            cell.wiseChatTextLabel?.text = chat[indexPath.row]
            cell.wiseChatTextLabel.textColor = .black
            cell.wiseChatImageView.image = UIImage(named: "robot")
            return cell

        }
    }
}

// MARK: Camera UIImageViewController Delegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        recongnizeText(image: image!)
    }
}

extension ViewController : UITextViewDelegate {
    
    func wiseTextViewShouldReturn(_ UITextView: UITextView) -> Bool {
        wiseChatTextView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
        
    }
    
    func keyboardTapToHide() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.wiseChatTableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        UIView.animate(withDuration: 0.3){
            self.bottomNSLayoutView.constant  = 0
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        print("\(String(describing: wiseChatTextView.text))")
        placeHolderTextLabel.isHidden = !wiseChatTextView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2){ [self] in
            bottomNSLayoutView.constant  = CGFloat(keyboradHeight)
            view.layoutIfNeeded()
            wiseChatTextView.becomeFirstResponder()
        }
    }
}
