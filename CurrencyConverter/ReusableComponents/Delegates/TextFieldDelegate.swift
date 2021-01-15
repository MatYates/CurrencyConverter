//
//  TextFieldDelegate.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

protocol ITextFieldDelegate: UITextFieldDelegate { }

class TextFieldDelegate: NSObject, ITextFieldDelegate {
    
    var textFieldDidBeginEditing: (()-> Void)?
    var textFieldShouldClear: ((_ textField: UITextField)-> Bool)?
    var textFieldShouldReturn: ((_ textField: UITextField)-> Bool)?
    var textFieldShouldEndEditing: ((_ textField: UITextField)-> Bool)?
    var textFieldShouldBeginEditing: ((_ textField: UITextField)-> Bool)?
    var textFieldDidEndEditing: ((_ textField: UITextField, _ reason: UITextField.DidEndEditingReason?)-> Void)?
    var shouldChangeCharactersInRange: ((_ textField: UITextField, _ shouldChangeCharactersInRange: NSRange, _ replacementString: String) -> Bool)?
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldDidBeginEditing?()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.textFieldShouldClear?(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.textFieldShouldReturn?(textField) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.textFieldShouldEndEditing?(textField) ?? true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.textFieldDidEndEditing?(textField, reason)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldDidEndEditing?(textField, nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.shouldChangeCharactersInRange?(textField, range, string) ?? true
    }
}
