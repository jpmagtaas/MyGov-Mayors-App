//
//  OTPView.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/23/21.
//

import UIKit

@IBDesignable class OTPView: UIStackView {

    var textFieldArray = [OTPTextField]()
    var numberOfOTPdigit = 4
    @IBInspectable var isPin: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        setTextFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setTextFields()
    }
    
    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    private func setTextFields() {
        for i in 0..<numberOfOTPdigit {
            let field = OTPTextField()
        
            textFieldArray.append(field)
            addArrangedSubview(field)
            field.delegate = self
            field.backgroundColor = .clear
            field.font = .boldSystemFont(ofSize: 31)
            field.textColor = .label
            field.textAlignment = .center
            field.layer.shadowColor = UIColor.black.cgColor
            field.layer.shadowOpacity = 0.1
            field.keyboardType = .numberPad
            
            if !isPin {
                let bottomLine = CALayer()
                bottomLine.frame = CGRect(x: 0, y: 48, width: 42, height: 2)
                bottomLine.backgroundColor = UIColor.lightGray.cgColor
                field.borderStyle = .none
                field.layer.addSublayer(bottomLine)
            } else {
                field.borderStyle = .line
                field.backgroundColor = .gray
            }
            
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            i != 0 ? (textFieldArray[i-1].nextTextFiled = textFieldArray[i]) : ()
        }
    }
}

extension OTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {
            return true
        }
        if !string.isEmpty {
            field.text = string
            field.resignFirstResponder()
            field.nextTextFiled?.becomeFirstResponder()
            return true
        }
        return true
    }
}

class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextFiled: UITextField?
    
    override func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}

