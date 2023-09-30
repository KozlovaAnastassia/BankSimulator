//
//  IncomeViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

protocol IncomeViewModellProtocol {
    var incomeArray: [Income] {get set}
    var total: [TotalSum] {get set}
    
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    var dataStorage: LocalDataServiceProtocol {get set}
    
    func getDataFromCoreData()
    func getIncomeForCell(indexPath: IndexPath) -> String
    func getTotalSum() -> String
    func deleteRow(indexPath: IndexPath)
}

class IncomeViewModell: IncomeViewModellProtocol {
    
    var incomeArray = [Income]()
    var total = [TotalSum]()
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.incomeArray.count }
    var dataStorage: LocalDataServiceProtocol
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getDataFromCoreData() {
        if let income = dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.income,
                                                          predicateFormat: nil,
                                                          predicateValue: nil)  {
           for i in income {
               incomeArray.append(i as! Income)
            }
        }
        
        if let sum = dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.totalSum,
                                                          predicateFormat: nil,
                                                          predicateValue: nil)  {
            for i in sum {
                total.append(i as! TotalSum)
            }
        }
    }
    
    func getIncomeForCell(indexPath: IndexPath) -> String {
        let income = incomeArray[indexPath.row]
        let formatedMoney = Formuls.shared.twoNumbersAfterPoint(integer: Int(income.income ?? String()) ?? Int())
        return formatedMoney
    }
    
    func getTotalSum() -> String {
        return Formuls.shared.twoNumbersAfterPoint(integer: Int(total[0].totalIncome ?? String()) ?? Int())
    }
    
    func deleteRow(indexPath: IndexPath) {
       let atribute = incomeArray.remove(at: indexPath.row)
        let newTotalSum = (Int(total[0].totalIncome ??  String()) ?? Int()) - (Int(atribute.income ?? String()) ?? Int())
        
        dataStorage.deleteAttributeValue(keyName: "income",
                                         predicateValue: atribute.income ?? String(),
                                         entityName: Constants.EntityName.income)
        
        dataStorage.updateAttributeValue(keyName: "totalIncome",
                                         value: String(newTotalSum),
                                         entityName: Constants.EntityName.totalSum)
      
    }
}




