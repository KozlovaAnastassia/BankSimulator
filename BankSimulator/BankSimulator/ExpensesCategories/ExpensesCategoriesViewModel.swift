//
//  ExpensesCategoriesViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit

protocol ExpensesCategoriesViewModelProtocol {
    var expensesArray: [ExpensesCategories] {get set}
    var result: (() -> Void)? {get set}
    var numberOfRowsInSection: Int {get}
    var dataStorage: LocalDataServiceProtocol {get set}

    func getDataFromCoreData()
    func getExpensesCategory(indexPath: IndexPath) -> String
    func addInitialArray()
}

class ExpensesCategoriesViewModel: ExpensesCategoriesViewModelProtocol {
    
    var expensesArray = [ExpensesCategories]()
    let initialArray = ["Дом", "Продукты", "Досуг", "Постоянные траты", "Путешествия"]
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.expensesArray.count }
    var dataStorage: LocalDataServiceProtocol
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getDataFromCoreData() {
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "ExpensesCategories") {
            for i in expense {
                expensesArray.append(i as! ExpensesCategories)
            }
        }
    }
    
    func getExpensesCategory(indexPath: IndexPath) -> String {
        expensesArray[indexPath.row].category ?? String()
    }
    
    func addInitialArray() {
        if   dataStorage.coreDataEntityIsEmpty(entityName: "ExpensesCategories") {
            for i in initialArray {
                dataStorage.saveDataToCoreData(withData: [i], entityName: "ExpensesCategories", key: ["category"]) { taskObject in
                    expensesArray.append(taskObject as! ExpensesCategories)
                }
            }
        }
    }
    
    func pushToBottomSheetVC(_ indexPath: IndexPath) -> ExpensesDetailController {
        let vc2 = ExpensesDetailController()
        let id = expensesArray[indexPath.row].id ?? String()
        vc2.getID(id: id)
        return vc2
    }
}
