//
//  InputTodoViewController.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/14.
//

import UIKit
import RealmSwift

class InputTodoViewController: UIViewController {
    
    @IBOutlet weak var inpuTodoTextField: UITextField!
    var sendText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inpuTodoTextField.becomeFirstResponder()
        self.inpuTodoTextField.layer.cornerRadius = 10
        self.inpuTodoTextField.delegate = self
        self.inpuTodoTextField.text = sendText
        self.inpuTodoTextField.addLeftPadding()
        setKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.dismiss(animated: true)
    }
    
}

extension UIViewController {
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.view.frame.origin.y += keyboardHeight
                }
            }
        }
    }
}


extension InputTodoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 할일 추가 Notification
        NotificationCenter.default.post(name: Notification.Name("addTodo"), object: [textField.text ?? "",sendText])
        // 텍스트필드 텍스트 초기화
        textField.text = ""
        return true
    }
    
    
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
