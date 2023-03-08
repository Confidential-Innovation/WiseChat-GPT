//
//  ViewController.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 25/2/23.
//

import UIKit
import Vision
import AVFoundation
import AVFAudio

class HomeViewController: UIViewController {

    @IBOutlet weak var wiseChatTextView: UITextView!
    @IBOutlet weak var wiseChatTableView: UITableView!
    @IBOutlet weak var placeHolderTextLabel: UILabel!
    @IBOutlet weak var bottomNSLayoutView: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textBGView: UIView!
    @IBOutlet weak var sendButtonHide: UIButton!
    
    var activityView: UIActivityIndicatorView?
    let scanLoderView: UIView = UIView()
    let typingLoaderView: UIView = UIView()
    var chat = [String]()
    var request = VNRecognizeTextRequest(completionHandler: nil)
    var textShare = ""
    var selectIndexNumber = 0
    var answerNumberCount = 0
    var keyboradHeight = 0
    let animation = DotsAnimation()
    var currentUtterance = AVSpeechSynthesizer()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // core data shared item

    lazy var copyTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Copeid!"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabelViewCell()
        setupUI()
        showActivityIndicatory()
        keyBoardHeightGet()
        getAllItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TypingLoaderAnimation()
    }
    
    
    // MARK: - Private method
    
    
    /// KeyboardNotification and get height
    private func keyBoardHeightGet(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.wiseChatTextView.becomeFirstResponder()

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboradHeight = Int(keyboardRectangle.height)
            UIView.animate(withDuration: 0.25){ [self] in
                if keyboradHeight > 261 {
                    bottomNSLayoutView.constant  = CGFloat(self.keyboradHeight)-20
                } else {
                    bottomNSLayoutView.constant  = CGFloat(self.keyboradHeight)
                }
                view.layoutIfNeeded()
            }
            
            bgView.backgroundColor = .black
        }
    }
    
    /// Typing Loader Animation
    private func TypingLoaderAnimation() {

        typingLoaderView.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        typingLoaderView.backgroundColor = .systemPink
        typingLoaderView.center = self.view.center
        let animationDots = animation.startDotsAnimation(superView: typingLoaderView, dotsColor: #colorLiteral(red: 0.9143115878, green: 0.9542326331, blue: 0.9878992438, alpha: 1))
        animationDots.frame = typingLoaderView.bounds
        typingLoaderView.addSubview(animationDots)
        self.view.addSubview(typingLoaderView)
        typingLoaderView.isHidden = true
        typingLoaderView.layer.cornerRadius = 10
    }
    
/// Scanner Activity Indicator
    private func showActivityIndicatory() {
        scanLoderView.frame = CGRect(x: 0, y: 0, width: 80, height: 75)
        scanLoderView.backgroundColor = .white
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.color = .black
        activityView?.center = scanLoderView.center
        scanLoderView.center = self.view.center
        scanLoderView.addSubview(activityView!)
        self.view.addSubview(scanLoderView)
        scanLoderView.isHidden = true
        scanLoderView.layer.cornerRadius = 10
    }
    
/// Image scan to text
    private func recongnizeText(image: UIImage){
        
        /// setup TextRecognition
        activityView?.startAnimating()
        wiseChatTableView.alpha = 0.4
        scanLoderView.isHidden = false
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
                    scanLoderView.isHidden = true
                }
            }
        })

        /// add some properties
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
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

    
    func tableViewCellClickAlertMenuOption() {

        let optionMenu = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: "- Details -", attributes: titleAttributes)
        let messageString = NSAttributedString(string: "Answer Number: \(answerNumberCount)", attributes: messageAttributes)
        optionMenu.setValue(titleString, forKey: "attributedTitle")
        optionMenu.setValue(messageString, forKey: "attributedMessage")
        
        let speakerAction = UIAlertAction(title: "Speaker", style: .default, handler: { [self]
            (alert: UIAlertAction!) -> Void in
            if !currentUtterance.isSpeaking {
                let speakText = AVSpeechUtterance(string: chat[selectIndexNumber])
                speakText.voice = AVSpeechSynthesisVoice(language: "en-AI")
                speakText.rate = 0.5
                let synth = AVSpeechSynthesizer()
    //            synth.replacementObject(for: chat[selectIndexNumber])
                synth.speak(speakText)
            } else {
                currentUtterance.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
            
        })
        let speakerImage = UIImage(systemName: "speaker.3")
        if let speakerImage = speakerImage?.imageWithSize(scaledToSize: CGSize(width: 36, height: 28)) {
            speakerAction.setValue(speakerImage, forKey: "image")
        }
          
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: { [self]
            (alert: UIAlertAction!) -> Void in
            wiseChatTableView.addSubview(copyTextLabel)
            UIPasteboard.general.string = chat[selectIndexNumber]
            copyTextLabel.layer.cornerRadius = 20
            copyTextLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            copyTextLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            copyTextLabel.centerXAnchor.constraint(equalTo: wiseChatTableView.centerXAnchor).isActive = true
            copyTextLabel.centerYAnchor.constraint(equalTo: wiseChatTableView.centerYAnchor).isActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.copyTextLabel.isHidden = true
            }

        })
        
        let copyImage = UIImage(systemName: "doc.on.doc")
        if let copyImage = copyImage?.imageWithSize(scaledToSize: CGSize(width: 30, height: 30)) {
            copyAction.setValue(copyImage, forKey: "image")
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        let saveImage = UIImage(systemName: "text.badge.plus")
        if let saveImage = saveImage?.imageWithSize(scaledToSize: CGSize(width: 30, height: 28)) {
            saveAction.setValue(saveImage, forKey: "image")
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { [self]
            (alert: UIAlertAction!) -> Void in
            let shareAll = [chat[selectIndexNumber]]
            let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        })
        let shareImage = UIImage(systemName: "arrow.up.square")
        if let shareImage = shareImage?.imageWithSize(scaledToSize: CGSize(width: 30, height: 28)) {
            shareAction.setValue(shareImage, forKey: "image")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        optionMenu.addAction(speakerAction)
        optionMenu.addAction(copyAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        optionMenu.view.tintColor = .black
        optionMenu.setBackgroundColor(color: .white)
        self.present(optionMenu, animated: true, completion: nil)

    }

    
    /// Private UI Setup
    private func setupUI() {
        wiseChatTextView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        wiseChatTextView.layer.borderWidth = 1.5
        wiseChatTextView.layer.cornerRadius = 15
        wiseChatTextView.delegate = self
        placeHolderTextLabel.alpha = 0.5
        wiseChatTextView.delegate = self
        wiseChatTextView.textColor = UIColor.black
        bgView.backgroundColor = #colorLiteral(red: 0.1824988425, green: 0.192479372, blue: 0.1879994869, alpha: 1)
        keyboardTapToHide()
        bgView.isUserInteractionEnabled = true

    }
    
    /// TableView cell setup
    func setupTabelViewCell() {
        let nib = UINib(nibName: "WiseChatTableViewCell", bundle: nil)
        wiseChatTableView.register(nib, forCellReuseIdentifier: "cell")
        wiseChatTableView.separatorColor = .none
        wiseChatTableView.delegate = self
        wiseChatTableView.dataSource = self
    }
    
    /// Stausbar color change
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    /// Scroll function
    private func scrollToButton() {
        let topRow = IndexPath(row: chat.count-1, section: 0)
        UIView.animate(withDuration: 0.3) {
            self.wiseChatTableView.scrollToRow(at: topRow, at: .bottom, animated: true)
            self.view.layoutIfNeeded()
        }
    }
    
    /// ChatGPT Message Answer Response
    private func fetchChatGPTForResponse(prompt: String) {
        Task {
            do {
                let gptText = try await APIService().sendPromtToGPT(promt: prompt)
                await MainActor.run {
                    chat.append(prompt)
                    chat.append(gptText.replacingOccurrences(of: "\n\n", with: ""))
                    createItem(question: prompt, answer: gptText.replacingOccurrences(of: "\n\n", with: ""))
                    typingLoaderView.isHidden = true
                    wiseChatTableView.alpha = 1.0
                    wiseChatTableView.reloadData()
                    sendButtonHide.alpha = 1
                    bgView.isUserInteractionEnabled = true
                    scrollToButton()
                }
            } catch {
                print("Error! 'Please change your API key' or 'Your internet not access! Please your internet connect.'")
                typingLoaderView.isHidden = true
                wiseChatTableView.alpha = 1.0
                let alert = UIAlertController(title: "Attention!", message: "Error! 'Please change your API key' or 'Your internet not access! Please your internet connect.'", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                alert.view.tintColor = .systemPink
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Scanner Action Button
    @IBAction func wiseChatScannerActionButton(_ sender: UIButton) {
        let imagePhotoLibraryPicker = UIImagePickerController()
        imagePhotoLibraryPicker.delegate = self
        imagePhotoLibraryPicker.allowsEditing = true
        imagePhotoLibraryPicker.sourceType = .camera
        imagePhotoLibraryPicker.modalPresentationStyle = .fullScreen
        self.present(imagePhotoLibraryPicker, animated: true, completion: nil)
    }
    
    /// Send Action Button
    @IBAction func wiseChatSendButtonAction(_ sender: UIButton) {
        wiseChatTextView.resignFirstResponder()
        if wiseChatTextView.text.count > 0 {
            let promptText = wiseChatTextView.text
            self.fetchChatGPTForResponse(prompt: promptText!)
            UIView.animate(withDuration: 0.3){ [self] in
                bottomNSLayoutView.constant  = 0
                bgView.backgroundColor = #colorLiteral(red: 0.1824988425, green: 0.192479372, blue: 0.1879994869, alpha: 1)
                view.layoutIfNeeded()
                typingLoaderView.isHidden = false
                wiseChatTableView.alpha = 0.5
                sendButtonHide.alpha = 0.5
            }
            bgView.isUserInteractionEnabled = false
            placeHolderTextLabel.isHidden = false
            wiseChatTextView.text = ""
        } else {
            let alert = UIAlertController(title: "No question!", message: "You didn't ask any questions. Please enter your question in the Text-Field.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = .red
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Settings Action Button
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        let st = UIStoryboard(name: "Settings", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "SettingsViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func noteActionButton(_ sender: UIButton) {
        let st = UIStoryboard(name: "Term", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "TermViewController") as! TermViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func historyActionButton(_ sender: UIButton) {
        let st = UIStoryboard(name: "History", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

/// UITableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.bgcellView.layer.borderWidth = 3
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
            cell.bgcellView.layer.shadowRadius = 3
            cell.bgcellView.layer.cornerRadius = 15
            cell.wiseChatTextLabel?.text = chat[indexPath.row]
            cell.wiseChatTextLabel.textColor = .black
            cell.wiseChatImageView.image = UIImage(named: "robot")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 1 {
            selectIndexNumber = indexPath.row
            answerNumberCount = ((indexPath.row)+1)/2
            tableViewCellClickAlertMenuOption()

        } else {
        }
    }
    
    // MARK: Cell Animation

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row % 2 == 0 {
            let anim = CATransform3DTranslate(CATransform3DIdentity, 500, 100, 0)
            cell.layer.transform = anim
            cell.alpha = 0.3
            
            UIView.animate(withDuration: 0.4){
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        } else {
            let anim = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
            cell.layer.transform = anim
            cell.alpha = 0.3
            
            UIView.animate(withDuration: 0.5){
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        }
        
    }
    
    
    //    MARK: TableView tapped to contextMenu
/*
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // 1
        var index = 0
        if indexPath.row % 2 == 0 {
            index = indexPath.row

        }
        // 2
        let identifier = "\(index)" as NSString

        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
                //
                let mapAction = UIAction(
                    title: "View map",
                    image: UIImage(systemName: "map")) { _ in
                    }

                // 4
                let shareAction = UIAction(
                    title: "Sshare",
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    }

                // 5
                return UIMenu(title: "", image: nil, children: [mapAction, shareAction])
            }
    }
 */
    
}

// MARK: Camera UIImageViewController Delegate

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        recongnizeText(image: image!)
    }
}

/// UITextView Delegate
extension HomeViewController : UITextViewDelegate {
    
    func wiseTextViewShouldReturn(_ UITextView: UITextView) -> Bool {
        wiseChatTextView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }
    
    /// Keyboard Dismiss Function
    private func keyboardTapToHide() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.wiseChatTableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        UIView.animate(withDuration: 0.3){ [self] in
            bottomNSLayoutView.constant  = 0
            bgView.backgroundColor = #colorLiteral(red: 0.1824988425, green: 0.192479372, blue: 0.1879994869, alpha: 1)
            view.layoutIfNeeded()
        }
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        print("\(String(describing: wiseChatTextView.text))")  /// Instant text show output
        placeHolderTextLabel.isHidden = !wiseChatTextView.text.isEmpty
    }
    
    /// TextView First Tap to animate top TextBackgroundView
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.25){ [self] in
            if keyboradHeight > 261 {
                bottomNSLayoutView.constant  = CGFloat(self.keyboradHeight)-20
            } else {
                bottomNSLayoutView.constant  = CGFloat(self.keyboradHeight)
            }
            view.layoutIfNeeded()
            bgView.backgroundColor = .black
        }
    }
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}

// MARK: Action Sheet Button Image

extension UIImage {
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: UIAlert Controller Custom Action Sheet

extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}


extension HomeViewController {
    //    MARK: CoreData Function

       internal func getAllItem() {
            do {
                historyArray = try context.fetch(MessageItemList.fetchRequest())
            }
            catch {
                print("Error")
            }
        }
        
       public func createItem(question: String, answer: String) {
            let newItem = MessageItemList(context: context)
            newItem.question = question
            newItem.answer = answer
            newItem.createdAt = Date()

            do {
                try context.save()
                getAllItem()
            }
            catch {
                // Error
            }
        }
        
    fileprivate func deleteItem(item: MessageItemList) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            // Error
        }
    }
}
