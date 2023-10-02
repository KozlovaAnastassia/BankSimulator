//
//  ExpensesDetailController.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit
import CoreData

class ExpensesDetailController: UIViewController, ExpensesDetailViewDelegate {
    private let expensesDetailView = ExpensesDetailView()
    private var viewModel: ExpensesDetailViewModelProtocol
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
        
        viewModel.result = { [weak self] in
            self?.expensesDetailView.reloadTableView()
        }
        expensesDetailView.delegate = self
        viewModel.getDataFromCoreData(id: itemID)
    }
    
     func tapButtonPaymentSchedule() {
         navigationController?.pushViewController(ExpensesChartViewController(itemId: itemID, viewModel: ExpensesChartViewModel(dataStorage: LocalDataService())), animated: true)
    }
    
     func tapButtonAddExpenses() {
         let viewModel = BottomSheetViewModel(moneyPlaceholder: Constants.PlaceholderTitle.money,
                                              categoryPlaceholder: Constants.PlaceholderTitle.category,
                                              buttonAddTitle: Constants.ButtonTitle.expensesDetail)
         
         let vc = BottomSheetController(viewModel: viewModel)
         viewModel.delegate = self
         
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
    
    func deleteRow(indexPath: IndexPath) {
        viewModel.deleteRow(indexPath: indexPath)
    }
    
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail {
        viewModel.getExpensesForCell(indexPath: indexPath)
    }
}

extension ExpensesDetailController: BottomSheetDelegate {
    
    func transit(_ category: String?, _ money: Int?) {
        
        viewModel.getDataFromBottomSheet(category: category ?? String(), money: money ?? Int(), id: itemID)
        expensesDetailView.reloadTableView()
    }
}
