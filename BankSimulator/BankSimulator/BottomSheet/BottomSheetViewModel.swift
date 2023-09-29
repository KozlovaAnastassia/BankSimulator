//
//  BottomSheetViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 28.09.2023.
//

import UIKit

enum StateOfConstrains {
    case income
    case expenses
    case expensesDetail
    case plain
}

protocol BottomSheetDelegate: AnyObject {
    func transit(_ category: String?, _ money: Int?)
}

class BottomSheetViewModel {
     var dataStorage = LocalDataService()
     var moneyPlaceholder: String?
     var categoryPlaceholder: String?
     var buttonAddTitle: String
     weak var delegate: BottomSheetDelegate?
        
    
    var state: StateOfConstrains {
        if moneyPlaceholder != nil && categoryPlaceholder != nil {
            return .expensesDetail
        } else if moneyPlaceholder != nil && categoryPlaceholder == nil {
            return .income
        } else if moneyPlaceholder == nil && categoryPlaceholder != nil {
            return .expenses
        } else {
            return .plain
        }
    }
    
    init(moneyPlaceholder: String?, categoryPlaceholder: String?, buttonAddTitle: String){
        self.moneyPlaceholder = moneyPlaceholder
        self.buttonAddTitle = buttonAddTitle
        self.categoryPlaceholder = categoryPlaceholder
    }
    
    func transitData(category: String?, money: Int?) {
        delegate?.transit(category, money)
    }
}
