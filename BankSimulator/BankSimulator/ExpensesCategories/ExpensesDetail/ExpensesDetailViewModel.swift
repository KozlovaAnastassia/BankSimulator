//
//  ExpensesDetailViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//


import UIKit

protocol ExpensesDetailViewModelProtocol {
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail
    func getDataFromCoreData(id: String)
    func deleteRow(indexPath: IndexPath)
    func getDataFromBottomSheet(category: String, money: Int, id: String)
}

class ExpensesDetailViewModel: ExpensesDetailViewModelProtocol {
    
    private var expensesDetailArray = [ExpensesDetail]()
    private var dataStorage: LocalDataServiceProtocol
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
    }
    
    func getDataFromBottomSheet(category: String, money: Int, id: String) {
        
        let date = Formuls.shared.currentDateString()
        let moneyFormatted = String(money)
        
        let arrayValues = [category , date, id, moneyFormatted]
        let arrayKey = ["category", "date",  "id", "money"]
        
        dataStorage.saveDataToCoreData(withData: arrayValues,
                                       entityName: Constants.EntityName.expensesDetail,
                                       key: arrayKey)
        { taskObject in
            expensesDetailArray.append(taskObject as! ExpensesDetail)
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
        let atribute = expensesDetailArray.remove(at: indexPath.row)
        
        dataStorage.deleteAttributeValue(keyName: "money",
                                         predicateValue: atribute.money ?? String(),
                                         entityName: Constants.EntityName.expensesDetail)
    }
}
