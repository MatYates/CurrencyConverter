//
//  DoubleExtensions.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import Foundation

extension Double {
    func formatToEuro()-> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        
        if let amount = formatter.string(from: NSNumber(value: self)) {
            return amount
        } else {
            return ""
        }
    }
    
    func formatToOther(currencyCode: String)-> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        if let amount = formatter.string(from: NSNumber(value: self)) {
            return amount
        } else {
            return ""
        }
    }
}
