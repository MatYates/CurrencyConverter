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
    @IBOutlet private weak var selectCurrencyView: SelectCurrencyView!
    
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
        self.setupSelectCurrencyView()
        self.addToolbarToKeyboard()
    }
    
    private func addToolbarToKeyboard() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resetTapped))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        bar.items = [space, done]
        bar.sizeToFit()
        self.currencyTextField.inputAccessoryView = bar
    }
    
    @objc func resetTapped() {
        self.currencyTextField.resignFirstResponder()
    }
    
    private func currenciesUpdated() {
        self.viewModel.currenciesUpdated = { [weak self] (currencies) in
            self?.selectCurrencyView.currencies = currencies
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
    
    private func setupSelectCurrencyView() {
        self.selectCurrencyView.currencyChanged = { [weak self] (currency) in
            self?.viewModel.updateSelectedCurrency(currency: currency, completion: { [weak self] (newConvertedCurrency) in
                self?.convertedCurrencyLabel.text = newConvertedCurrency
            })
        }
    }
}
