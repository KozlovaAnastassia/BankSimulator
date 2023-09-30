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
    func getExpensesCategoryForCell(indexPath: IndexPath) -> String
    func deleteRow(indexPath: IndexPath) 
    func addInitialArray()
    func getDataFromBottomSheet(category: String?, money: Int?)
}

class ExpensesCategoriesViewModel: ExpensesCategoriesViewModelProtocol {
    
    private let initialArray = Constants.ConstantArrays.initialExpensesCategory
    var expensesArray = [ExpensesCategories]()
    var result: (() -> Void)?
    var numberOfRowsInSection: Int {return self.expensesArray.count }
    var dataStorage: LocalDataServiceProtocol
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    func getDataFromCoreData() {
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.expensesCategories, predicateFormat: nil, predicateValue: nil) {
            for i in expense {
                expensesArray.append(i as! ExpensesCategories)
            }
        }
    }
    
    func getExpensesCategoryForCell(indexPath: IndexPath) -> String {
        expensesArray[indexPath.row].category ?? String()
    }
    
    func addInitialArray() {
        if   dataStorage.coreDataEntityIsEmpty(entityName: Constants.EntityName.expensesCategories) {
            var id = 0
            for i in initialArray {
                id += 1
                dataStorage.saveDataToCoreData(withData: [i, String(id)],
                                               entityName: Constants.EntityName.expensesCategories,
                                               key: ["category", "id"])
                { taskObject in
                    expensesArray.append(taskObject as! ExpensesCategories)
                }
            }
        }
    }
    
    func pushToBottomSheetVC(_ indexPath: IndexPath) -> ExpensesDetailController {
        let vc2 = ExpensesDetailController(viewModel: ExpensesDetailViewModel(dataStorage: LocalDataService()))
        let id = expensesArray[indexPath.row].id ?? String()
        vc2.getID(id: id)
        return vc2
    }
    
    func getDataFromBottomSheet(category: String?, money: Int?) {
        let id = (Int(expensesArray.last?.id ?? String()) ?? Int()) + 1
        dataStorage.saveDataToCoreData(withData: [category ?? String(), String(id)], entityName: Constants.EntityName.expensesCategories, key: ["category", "id"]) { taskObject in
            expensesArray.append(taskObject as! ExpensesCategories)
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
       let atribute = expensesArray.remove(at: indexPath.row)
        
        dataStorage.deleteAttributeValue(keyName: "category",
                                         predicateValue: atribute.category ?? String(),
                                         entityName: Constants.EntityName.expensesCategories)
    }
}
