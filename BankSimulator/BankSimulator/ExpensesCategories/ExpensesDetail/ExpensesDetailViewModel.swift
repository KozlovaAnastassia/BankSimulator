//
//  ExpensesDetailViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//


import UIKit

protocol ExpensesDetailViewModelProtocol {
    var expensesDetailArray: [ExpensesDetail] {get set}
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    var dataStorage: LocalDataServiceProtocol {get set}
    var totalExpenses: [TotalSum] {get set}
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail
    func getDataFromCoreData(id: String)
    func deleteRow(indexPath: IndexPath)
    func getDataFromBottomSheet(arrayValues: [String], arrayKey: [String], moneyFormatted: String, money: Int? )
}

class ExpensesDetailViewModel: ExpensesDetailViewModelProtocol {
    
    var expensesDetailArray = [ExpensesDetail]()
    var totalExpenses = [TotalSum]()
    var dataStorage: LocalDataServiceProtocol
    var itemID = String()
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.expensesDetailArray.count }
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail {
        expensesDetailArray[indexPath.row]
    }
    
    func getDataFromCoreData(id: String) {
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.expensesDetail,
                                                            predicateFormat: "id == %@",
                                                            predicateValue: id){
            for i in expense {
                expensesDetailArray.append(i as! ExpensesDetail)
            }
        }
        if let sum = dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.totalSum,
                                                          predicateFormat: nil,
                                                          predicateValue: nil)  {
            for i in sum {
                totalExpenses.append(i as! TotalSum)
            }
        }
    }
    
    func getDataFromBottomSheet(arrayValues: [String], arrayKey: [String], moneyFormatted: String, money: Int?  ) {
        dataStorage.saveDataToCoreData(withData: arrayValues,
                                       entityName: Constants.EntityName.expensesDetail,
                                       key: arrayKey)
        { taskObject in
            expensesDetailArray.append(taskObject as! ExpensesDetail)
        }
        
        
        if dataStorage.coreDataEntityIsEmpty(entityName: Constants.EntityName.totalSum) {
            dataStorage.saveDataToCoreData(
                                           withData: [moneyFormatted],
                                           entityName: Constants.EntityName.totalSum,
                                           key: ["totalExpense"])
        { taskObject in
            totalExpenses.append(taskObject as! TotalSum)
        }
        } else {
            let newSum = (Int(totalExpenses[0].totalExpense ?? String()) ?? Int()) + (money ?? Int())
            dataStorage.updateAttributeValue(
                                                keyName: "totalExpense",
                                                value: String(newSum),
                                                entityName: Constants.EntityName.totalSum)
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
        let atribute = expensesDetailArray.remove(at: indexPath.row)
        let newTotalSum = (Int(totalExpenses[0].totalExpense ??  String()) ?? Int()) - (Int(atribute.category ?? String()) ?? Int())
        
        dataStorage.deleteAttributeValue(keyName: "money",
                                         predicateValue: atribute.money ?? String(),
                                         entityName: Constants.EntityName.expensesDetail)
        
        dataStorage.updateAttributeValue(keyName: "totalExpense",
                                         value: String(newTotalSum),
                                         entityName: Constants.EntityName.totalSum)
    }
}
