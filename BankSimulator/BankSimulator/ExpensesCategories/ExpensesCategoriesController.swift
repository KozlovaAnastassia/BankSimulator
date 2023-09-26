//
//  ExpensesControllerViewController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

class ExpensesCategoriesController: UIViewController, ExpensesCategoriesViewDelegate {
    
    let viewModel: ExpensesCategoriesViewModel
    var expensesCategoriesView = ExpensesCategoriesView()
    
    init(viewModel: ExpensesCategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = expensesCategoriesView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.addInitialArray()
        viewModel.result = {
            self.expensesCategoriesView.reloadTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getDataFromCoreData()
        expensesCategoriesView.delegate = self
    }
  
    func tapButtonAddExpenses() {
        let vc = BottomSheetController(moneyPlaceholder: nil, categoryPlaceholder: "Введите категорию", buttonAddTitle: "Добавить категорию расходов")
        vc.delegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    func getExpensesCategoryForCell(indexPath: IndexPath) -> String {
        viewModel.getExpensesCategoryForCell(indexPath: indexPath)
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
        self.expensesCategoriesView.reloadTableView()
    }
}
