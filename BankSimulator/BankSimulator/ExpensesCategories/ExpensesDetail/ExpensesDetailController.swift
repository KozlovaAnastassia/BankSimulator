//
//  ExpensesDetailController.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit

class ExpensesDetailController: UIViewController, ExpensesDetailViewDelegate {
    let expensesDetailView = ExpensesDetailView()
    var viewModel: ExpensesDetailViewModelProtocol
    private var itemID = String()
    
    init(viewModel: ExpensesDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = expensesDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesDetailView.delegate = self
        viewModel.getDataFromCoreData()
        viewModel.result = {
            self.expensesDetailView.reloadTableView()
        }
    }
    
     func tapButtonPaymentSchedule() {
       // navigationController?.pushViewController(PaymentSchedule(), animated: true)
    }
    
     func tapButtonAddExpenses() {
        let vc = BottomSheetController(moneyPlaceholder: "Введите сумму расхода", categoryPlaceholder: "Введите категорию расхода", buttonAddTitle: "Добавить расход")
        vc.delegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    func getID(id: String) {
        self.itemID = id
    }
    
    func getRowNumber() -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail {
        viewModel.getExpensesForCell(indexPath: indexPath)
    }
}

extension ExpensesDetailController: BottomSheetDelegate {
    
    func transit(_ category: String?, _ money: Int?) {
        let date = Formuls.shared.currentDateString()
        let moneyFormatted = Formuls.shared.twoNumbersAfterPoint(integer: Int(money ?? Int()) )
        let arrayValues = [category ?? String(), date, moneyFormatted]
        let arrayKey = ["category", "date", "money"]
        
        viewModel.dataStorage.saveDataToCoreData(withData: arrayValues, entityName: "ExpensesDetail", key: arrayKey) { taskObject in
            viewModel.expensesDetailArray.append(taskObject as! ExpensesDetail)
        }
        expensesDetailView.tableView.reloadData()
    }
}
