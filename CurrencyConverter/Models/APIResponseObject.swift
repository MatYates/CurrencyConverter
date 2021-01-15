//
//  APIResponseObject.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import Foundation

//reponse object from fixer.io
class APIResponseObject: Codable {
    let base: String
    let date: String
    let success: Bool
    let timestamp: Int
    let rates: Dictionary<String, Double>
    
    init(base: String, date: String, success: Bool, timestamp: Int, rates: Dictionary<String, Double>){
        self.base = base
        self.date = date
        self.success = success
        self.timestamp = timestamp
        self.rates = rates
    }
}
