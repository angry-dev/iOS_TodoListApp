//
//  WriteComentViewController.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/04.
//

import UIKit



class WriteComentViewController: UIViewController {
    
    @IBOutlet weak var comentTextField: UITextField!
    @IBOutlet weak var WriteComentBackgroundView: UIView!
    
    @IBOutlet weak var smileButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var birthButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var whirlButton: UIButton!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet var statusButtons: [UIButton]!
    @IBOutlet weak var completeButton: UIButton!
    
    var selectedStauts = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.comentTextField.becomeFirstResponder()
        self.WriteComentBackgroundView.layer.cornerRadius = 10
        comentTextField.delegate = self
    }
    
    
    @IBAction func tapStatusImageButton(_ sender: UIButton) {
        if sender == self.smileButton {
            changeStatusButtonAlpha(status: smileButton.titleLabel?.text ?? "")
        } else if sender == self.sadButton {
            changeStatusButtonAlpha(status: sadButton.titleLabel?.text ?? "")
        } else if sender == self.angryButton {
            changeStatusButtonAlpha(status: angryButton.titleLabel?.text ?? "")
        } else if sender == self.birthButton {
            changeStatusButtonAlpha(status: birthButton.titleLabel?.text ?? "")
        } else if sender == self.sleepButton {
            changeStatusButtonAlpha(status: sleepButton.titleLabel?.text ?? "")
        } else if sender == self.whirlButton {
            changeStatusButtonAlpha(status: whirlButton.titleLabel?.text ?? "")
        } else {
            changeStatusButtonAlpha(status: loveButton.titleLabel?.text ?? "")
        }
        
        self.completeButtonisEnable()
        self.selectedStauts = sender.titleLabel?.text ?? ""
    }
    
    private func changeStatusButtonAlpha(status: String) {
        self.smileButton.alpha = status == "😄" ? 1 : 0.4
        self.angryButton.alpha = status == "😡" ? 1 : 0.4
        self.sadButton.alpha = status == "😢" ? 1 : 0.4
        self.birthButton.alpha = status == "🥳" ? 1 : 0.4
        self.sleepButton.alpha = status == "😴" ? 1 : 0.4
        self.whirlButton.alpha = status == "😵‍💫" ? 1 : 0.4
        self.loveButton.alpha = status == "😍" ? 1 : 0.4
    }
    
    private func completeButtonisEnable() {
        guard let comentText = self.comentTextField.text?.isEmpty else { return }
        if statusButtons.map({$0.alpha}).contains(1.0) && !comentText  {
            completeButton.isEnabled = true
        }
        
    }
    
    // 코멘트 추가 버튼
    @IBAction func completeButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("doneComent"), object: [selectedStauts,self.comentTextField.text ?? ""])

        self.dismiss(animated: true)
    }
    
}

extension WriteComentViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.completeButtonisEnable()
    }
    
    
}
