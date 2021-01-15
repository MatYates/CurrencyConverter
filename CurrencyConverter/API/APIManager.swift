//
//  APIManager.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import Foundation
import UIKit

protocol IAPIManager {
    func getLatestCurrecyConversions(completion: @escaping (_ success: Bool, _ successResponse: APIResponseObject?)-> Void)
}

//very simple network call ignoring no internet and avoiding using libraries etc, if this was something proper i would probably use a networking library
class APIManager: IAPIManager {
    let baseUrl: String = "http://data.fixer.io/api"
    let apiKey: String = "edcad348e7d44e333e0d6c65dd764633"
    let symbols = "CAD,AUD,GBP,JPY,USD"
    
    func getLatestCurrecyConversions(completion: @escaping (_ success: Bool, _ successResponse: APIResponseObject?)-> Void) {
        guard let url = URL(string: "\(baseUrl)/latest?access_key=\(apiKey)&symbols=\(symbols)") else {
            completion(false, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else {
                self.serializeJSON(data: data, completion: completion)
            }
        }
        task.resume()
    }
    
    private func serializeJSON<T: Codable>(data: Data?, completion: @escaping (_ success: Bool, _ successResponse: T?)-> Void) {
        guard let data = data else {
            return
        }
        do {
            if let responseSuccess: T? = try self.decodeJsonToGenericObject(jsonData: data) {
                completion(true, responseSuccess)
            } else {
                completion(false, nil)
            }
        } catch {
            completion(false, nil)
        }
    }
    
    private func decodeJsonToGenericObject<T: Codable>(jsonData: Data) throws -> T?{
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}
