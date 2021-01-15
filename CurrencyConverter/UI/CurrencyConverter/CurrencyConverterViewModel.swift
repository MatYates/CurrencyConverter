//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

protocol ICurrencyConverterViewModel {
    var keyboardHeightStreamProvider: IKeyboardHeightStreamProvider { get }
    var currenciesUpdated: (([Currency])-> Void)? {get set}
    func setupCurrencyConverterTextField(textfield: UITextField, completion: @escaping (_ converted: String?)-> Void)
    func updateSelectedCurrency(currency: Currency,  completion: @escaping (_ converted: String?)-> Void)
}

class CurrencyConverterViewModel: ICurrencyConverterViewModel {
    //MARK: - Helpers
    let keyboardHeightStreamProvider: IKeyboardHeightStreamProvider = KeyboardHeightStreamProvider()
    let currencyConverterTextFieldDelegate: TextFieldDelegate = TextFieldDelegate()
    
    //MARK: - Private Properties
    private lazy var apiManager: IAPIManager = {
       return APIManager()
    }()
    private var currencies: [Currency] = [] {
        didSet {
            self.currenciesUpdated?(self.currencies)
        }
    }
    
    //MARK: - Public Properties
    var currenciesUpdated: (([Currency])-> Void)?
    var selectedCurrency: Currency?
    
    init() {
        self.getLatestCurrencyConversions()
    }
    
    //MARK: - API call
    
    private func getLatestCurrencyConversions() {
        //on init call api to get latest currencies, usually i would have a seperate layer for this where it saves to a database etc depending on the project
        //but as i am under time constraints here will have to do
        
        // also assume that Fixer.io is always available, and always returns a well-formed response.
        self.apiManager.getLatestCurrecyConversions { (success, response) in
            if let response = response, success == true {
                self.convertCurrencyDictionary(dict: response.rates)
            }
        }
    }
    
    private func convertCurrencyDictionary(dict: Dictionary<String, Double>) {
        self.currencies = []
        var tempCurrencies: [Currency] = []
        for (key, value) in dict {
            let currency = Currency(currencyCode: key, amount: value)
            tempCurrencies.append(currency)
        }
        tempCurrencies.sort { (currency1, currency2) -> Bool in
            return currency1.currencyCode < currency2.currencyCode
        }
        self.currencies.append(contentsOf: tempCurrencies)
        self.selectedCurrency = currencies.first
    }
    
    //MARK: - TextField and currency conversion
    
    func setupCurrencyConverterTextField(textfield: UITextField, completion: @escaping (_ converted: String?)-> Void) {
        textfield.delegate = self.currencyConverterTextFieldDelegate
        self.currencyConverterTextFieldDelegate.shouldChangeCharactersInRange = { [weak self] (textfield, range, replacementString) in
            guard let self = self else {return false}
            let doubleValue = self.setFormattedAmount(replacementString)
            textfield.text = doubleValue.formatToEuro()
            let convertedCurrency = self.selectedCurrency?.convert(amountEur: doubleValue)
            completion(convertedCurrency)
            return false
        }
    }
    
    private var amountString: String = ""
    private func setFormattedAmount(_ string: String)-> Double {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        if string.rangeOfCharacter(from: disallowedCharacterSet) == nil {
            if string == "",  amountString.count > 0{
                //delete key pressed
                amountString.removeLast()
            }
            //restrict to 10 chars
            if amountString.count <= 9 {
                amountString = amountString + string
            }
            return self.convertAmountString()
        } else {
            return self.convertAmountString()
        }
    }
    
    private func convertAmountString()-> Double {
        let amount = (NSString(string: amountString).doubleValue) / 100
        return amount
    }
    
    //when changing what to convert to this should be called to update the price
    func updateSelectedCurrency(currency: Currency,  completion: @escaping (_ converted: String?)-> Void) {
        self.selectedCurrency = currency
        let doubleValue = self.convertAmountString()
        let convertedCurrency = self.selectedCurrency?.convert(amountEur: doubleValue)
        completion(convertedCurrency)
    }
}
