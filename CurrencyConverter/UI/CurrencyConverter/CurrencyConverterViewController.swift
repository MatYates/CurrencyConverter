//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var convertedCurrencyLabel: UILabel!
    
    //MARK: - Private properties
    private lazy var viewModel: ICurrencyConverterViewModel = {
       return CurrencyConverterViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    deinit {
        self.viewModel.keyboardHeightStreamProvider.deregisterFromNotifications()
    }
    
    //MARK: - Setup
    
    private func setup() {
        self.currenciesUpdated()
        self.setupKeyboardHeightStreamProvider()
        self.setupTextField()
    }
    
    private func currenciesUpdated() {
        self.viewModel.currenciesUpdated = { [weak self] (currencies) in
            
        }
    }
    
    private func setupTextField() {
        self.viewModel.setupCurrencyConverterTextField(textfield: self.currencyTextField, completion: { [weak self] (convertedCurrency) in
            self?.convertedCurrencyLabel.text = convertedCurrency ??  ""
        })
        self.currencyTextField.becomeFirstResponder()
    }
    
    private func setupKeyboardHeightStreamProvider(){
        self.viewModel.keyboardHeightStreamProvider.registerForNotifications()
        self.viewModel.keyboardHeightStreamProvider.observeResult({ [weak self] (height, time, animationCurve) in
            guard let scroll = self?.scrollView else {return}
            var contentInset: UIEdgeInsets = scroll.contentInset
            let keyoardHeight: CGFloat = height
            contentInset.bottom = keyoardHeight
            scroll.contentInset = contentInset
            scroll.scrollIndicatorInsets = contentInset
        })
    }
}
