//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import Foundation

class Currency {
    let currencyCode: String
    let amount: Double
    
    init(currencyCode: String, amount: Double) {
        self.currencyCode = currencyCode
        self.amount = amount
    }
    
    func convert(amountEur: Double)-> String {
        let total = amountEur * self.amount
        return total.formatToOther(currencyCode: self.currencyCode)
    }
}
