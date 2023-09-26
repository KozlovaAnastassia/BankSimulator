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
    func getDataFromCoreData()
    
}

class ExpensesDetailViewModel: ExpensesDetailViewModelProtocol {
    
    var expensesDetailArray = [ExpensesDetail]()
    var dataStorage: LocalDataServiceProtocol
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.expensesDetailArray.count }
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail {
        expensesDetailArray[indexPath.row]
    }
    
    func getDataFromCoreData() {
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "ExpensesDetail") {
            for i in expense {
                expensesDetailArray.append(i as! ExpensesDetail)
            }
        }
    }
    
}
