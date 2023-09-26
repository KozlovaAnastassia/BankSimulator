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
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "ExpensesCategories", predicateFormat: nil, predicateValue: nil) {
            for i in expense {
                expensesArray.append(i as! ExpensesCategories)
            }
        }
    }
    
    func getExpensesCategoryForCell(indexPath: IndexPath) -> String {
        expensesArray[indexPath.row].category ?? String()
    }
    
    func addInitialArray() {
        if   dataStorage.coreDataEntityIsEmpty(entityName: "ExpensesCategories") {
            var id = 0
            for i in initialArray {
                id += 1
                dataStorage.saveDataToCoreData(withData: [i, String(id)], entityName: "ExpensesCategories", key: ["category", "id"]) { taskObject in
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
}
