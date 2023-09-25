//
//  IncomeViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import Foundation
import UIKit

protocol IncomeViewModellProtocol {
    var incomeArray: [Income] {get set}
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    var dataStorage: LocalDataServiceProtocol {get set}
    
    func getDataFromCoreData()
    func getIncome(indexPath: IndexPath) -> String
    func getTotalSum() -> String
    func numberOrRows() -> Int
}


class IncomeViewModell: IncomeViewModellProtocol {
    
    
    var incomeArray = [Income]()
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.incomeArray.count }
    var dataStorage: LocalDataServiceProtocol
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getDataFromCoreData() {
        if let income = dataStorage.fetchDataFromCoreData(entityName: "Income") {
           for i in income {
               incomeArray.append(i as! Income)
            }
        }
    }
    
    func getIncome(indexPath: IndexPath) -> String {
        let income = incomeArray[indexPath.row]
        return income.income ?? String()
    }
    
    func getTotalSum() -> String {
        return incomeArray.last?.totalSum ?? String()
    }
    
    func numberOrRows() -> Int {
           return self.incomeArray.count
       }
}




