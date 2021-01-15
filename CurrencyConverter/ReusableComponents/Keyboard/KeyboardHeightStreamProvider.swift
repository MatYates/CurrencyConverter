//
//  KeyboardHeightStreamProvider.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

protocol IKeyboardHeightStreamProvider {
    func registerForNotifications()
    func deregisterFromNotifications()
    func observeResult(_ observer: ((CGFloat, TimeInterval, Int)->Void)?)
}

class KeyboardHeightStreamProvider: NSObject, IKeyboardHeightStreamProvider {
    
    var observeResult : ((CGFloat, TimeInterval, Int)->Void)? = nil
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }
            
            guard let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
                return
            }
        
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
                        
            let rect = keyboardFrame.cgRectValue
            var height = rect.height
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let bottomPadding = window?.safeAreaInsets.bottom {
                height = height + bottomPadding
            }
            
            if let or = self?.observeResult {
                or(height, duration, animationCurve)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }
            
            guard let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
                return
            }
            
            if let or = self?.observeResult {
                or(0, duration, animationCurve)
            }
        }
    }
    
    func deregisterFromNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func observeResult(_ observer: ((CGFloat, TimeInterval, Int)->Void)?) {
        self.observeResult = observer
    }
}
