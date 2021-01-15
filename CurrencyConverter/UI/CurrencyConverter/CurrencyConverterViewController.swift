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
    
    private lazy var viewModel: ICurrencyConverterViewModel = {
       return CurrencyConverterViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    deinit {
        
    }
    
    private func setup() {
        
    }
}
