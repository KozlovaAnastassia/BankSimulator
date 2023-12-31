//
//  IncomeViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

protocol IncomeViewModellProtocol {
    var incomeArray: [Income] {get set}
    var totalIncomeArray: [TotalSum] {get set}
    
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    var dataStorage: LocalDataServiceProtocol {get set}
    
    func getDataFromCoreData()
    func getIncomeForCell(indexPath: IndexPath) -> String
    func getTotalSum() -> String
    func deleteRow(indexPath: IndexPath)
    func getDataFromBottomSheet(category: String?, money: Int?)
}

class IncomeViewModell: IncomeViewModellProtocol {
    
    var incomeArray = [Income]()
    var totalIncomeArray = [TotalSum]()
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
                totalIncomeArray.append(i as! TotalSum)
            }
        }
    }
    
    func getDataFromBottomSheet(category: String?, money: Int?) {
        let moneyFormatted = Formuls.shared.twoNumbersAfterPoint(integer: money ?? Int())
        
        dataStorage.saveDataToCoreData(
                                       withData: [String(money ?? Int())],
                                       entityName: Constants.EntityName.income,
                                       key: ["income"])
        { taskObject in
            incomeArray.append(taskObject as! Income)
        }
        
        if totalIncomeArray.isEmpty  {
            dataStorage.saveDataToCoreData(
                                           withData: [moneyFormatted],
                                           entityName: Constants.EntityName.totalSum,
                                           key: ["totalIncome"])
            { taskObject in
                totalIncomeArray.append(taskObject as! TotalSum)
                totalIncomeArray[0].totalIncome = String(money ?? Int())
            }
        } else {
            let newSum = (Int(totalIncomeArray[0].totalIncome ?? String()) ?? Int()) + (money ?? Int())
            
            dataStorage.updateAttributeValue(
                                                keyName: "totalIncome",
                                                value: String(newSum),
                                                entityName: Constants.EntityName.totalSum)
        }
    }
    
    func getIncomeForCell(indexPath: IndexPath) -> String {
        let income = incomeArray[indexPath.row]
        let formatedMoney = Formuls.shared.twoNumbersAfterPoint(integer: Int(income.income ?? String()) ?? Int())
        return formatedMoney
    }
    
    func getTotalSum() -> String {
        return Formuls.shared.twoNumbersAfterPoint(integer: Int(totalIncomeArray[0].totalIncome ?? String()) ?? Int())
    }
    
    func deleteRow(indexPath: IndexPath) {
       let atribute = incomeArray.remove(at: indexPath.row)
        let newTotalSum = (Int(totalIncomeArray[0].totalIncome ??  String()) ?? Int()) - (Int(atribute.income ?? String()) ?? Int())
        
        dataStorage.deleteAttributeValue(keyName: "income",
                                         predicateValue: atribute.income ?? String(),
                                         entityName: Constants.EntityName.income)
        
        dataStorage.updateAttributeValue(keyName: "totalIncome",
                                         value: String(newTotalSum),
                                         entityName: Constants.EntityName.totalSum)
    }
}




