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
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail
    func getDataFromCoreData(id: String)
    func deleteRow(indexPath: IndexPath)
}

class ExpensesDetailViewModel: ExpensesDetailViewModelProtocol {
    
    var expensesDetailArray = [ExpensesDetail]()
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
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.expensesDetail, predicateFormat: "id == %@", predicateValue: id){
            for i in expense {
                expensesDetailArray.append(i as! ExpensesDetail)
            }
        }
    }
    func deleteRow(indexPath: IndexPath) {
       let atribute = expensesDetailArray.remove(at: indexPath.row)
        
        dataStorage.deleteAttributeValue(keyName: "money",
                                         predicateValue: atribute.money ?? String(),
                                         entityName: Constants.EntityName.expensesDetail)
    }
}
