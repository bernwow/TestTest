//
//  ViewController.swift
//  Test
//
//  Created by Bern on 14.10.2018.
//  Copyright © 2018 Bern. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    let formatter: StringFormatter! = StringFormatter()
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var expiringDateTextField: UITextField!
    @IBOutlet weak var CVCCodeTextField: UITextField!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var bottomOutlet: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        cardNumberTextField.addTarget(formatter, action: #selector(StringFormatter.reformatAsCardNumber), for: .editingChanged)
        ownerNameTextField.addTarget(formatter, action: #selector(StringFormatter.reformatAsOwnerName), for: .editingChanged)
        expiringDateTextField.addTarget(formatter, action: #selector(StringFormatter.reformatAsExpiringDate), for: .editingChanged)
        CVCCodeTextField.addTarget(formatter, action: #selector(StringFormatter.reformatAsCVC), for: .editingChanged)
    }
    
    @IBAction func hideButtonTapped(_ sender: Any) {
        CVCCodeTextField.isSecureTextEntry = !CVCCodeTextField.isSecureTextEntry;
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        cardNumberTextField.text = "";
        ownerNameTextField.text = "";
        expiringDateTextField.text = "";
        CVCCodeTextField.text = "";
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        var message = "Succes"
        
        if cardNumberTextField.text!.count < 19 {
            message = "Wrong card number"
        } else if ownerNameTextField.text!.count < 5 {
            message = "Wrong name"
        } else if expiringDateTextField.text!.count < 4 {
            message = "Wrong date"
        } else if CVCCodeTextField.text!.count < 3 {
            message = "Wrong CVC"
        }
        displayAlertMessage(messageToDisplay: message)

    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomOutlet.constant == 0{
                self.bottomOutlet.constant += keyboardSize.height
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.bottomOutlet.constant != 0 {
            self.bottomOutlet.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        formatter.previousTextFieldContent = textField.text;
        formatter.previousSelection = textField.selectedTextRange;
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cardNumberTextField {
            if textField.text?.first == "4" {
                cardTypeLabel.isHidden = false
                cardTypeLabel.text = "Visa"
            } else if textField.text?.first == "4" {
                cardTypeLabel.isHidden = false
                cardTypeLabel.text = "MasterCard"
            } else {
                cardTypeLabel.isHidden = true
            }
        }
    }
}
