//
//  ExpensesControllerViewController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit
import CoreData

class ExpensesCategoriesController: UIViewController, ExpensesCategoriesViewDelegate {
    
    let viewModel = ExpensesCategoriesViewModel(dataStorage: LocalDataService())
    var newView = ExpensesCategoriesView()
    
    override func loadView() {
        super.loadView()
        view = newView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.addInitialArray()
        viewModel.result = {
            self.newView.reloadTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDataFromCoreData()
       
        newView.delegate = self
    }
  
    func transit() {
        let vc = BottomSheetController(moneyPlaceholder: nil, categoryPlaceholder: "Введите категорию", buttonAddTitle: "Добавить категорию расходов")
        vc.delegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    func getDataForCell(indexPath: IndexPath) -> String {
        viewModel.getExpensesCategory(indexPath: indexPath)
    }
    
    func getNumbersOfSection() -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func pushToBottomSheetVC(indexPath: IndexPath) {
        let vc2 = viewModel.pushToBottomSheetVC(indexPath)
        navigationController?.pushViewController(vc2, animated: true)
    }
}
    
extension ExpensesCategoriesController: BottomSheetDelegate {
    func transit(_ category: String?, _ money: Int?) {

        let id = (Int(viewModel.expensesArray.last?.id ?? String()) ?? Int()) + 1
        viewModel.dataStorage.saveDataToCoreData(withData: [category ?? String(), String(id)], entityName: "ExpensesCategories", key: ["category", "id"]) { taskObject in
            viewModel.expensesArray.append(taskObject as! ExpensesCategories)
        }
        self.newView.reloadTableView()
    }
}
