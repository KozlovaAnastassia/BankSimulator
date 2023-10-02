//
//  ViewController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

class IncomeController: UIViewController, IncomeViewDelegate {
    private let incomeView = IncomeView()
    private var viewModel: IncomeViewModellProtocol
    
    init(viewModel: IncomeViewModellProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view = incomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.result = { [weak self] in
            self?.incomeView.reloadTableView()
        }
        viewModel.getDataFromCoreData()
        incomeView.delegate = self
        
    }
    
     func getIncomeForCell(indexPath: IndexPath) -> String {
        viewModel.getIncomeForCell(indexPath: indexPath)
    }
    
    func getNumbersOfSection() -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func deleteRow(indexPath: IndexPath) {
        viewModel.deleteRow(indexPath: indexPath)
        
        if self.viewModel.totalIncomeArray[0].totalIncome == "0" {
            self.incomeView.currentBalance.text = "0.00 p"
        }
    }
 
    func getTotalSum() -> String {
        return viewModel.getTotalSum()
    }
    
    func tapButtonAddIncome() {
        let viewModel = BottomSheetViewModel(moneyPlaceholder: Constants.PlaceholderTitle.money,
                                             categoryPlaceholder: nil,
                                             buttonAddTitle: Constants.ButtonTitle.income)
        let vc = BottomSheetController(viewModel: viewModel)
        viewModel.delegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc , animated: true)
    }
}

extension IncomeController: BottomSheetDelegate {
    func transit(_ category: String?, _ money: Int?) {
        viewModel.getDataFromBottomSheet(category: category, money: money)
        incomeView.reloadTableView()
    }
}
