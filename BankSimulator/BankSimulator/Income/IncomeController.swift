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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        viewModel.result = {
            self.incomeView.reloadTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if self.viewModel.total[0].totalIncome == "0" {
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
        let moneyFormatted = Formuls.shared.twoNumbersAfterPoint(integer: money ?? Int())
        
        viewModel.dataStorage.saveDataToCoreData(
                                       withData: [String(money ?? Int())],
                                       entityName: Constants.EntityName.income,
                                       key: ["income"])
        { taskObject in
            viewModel.incomeArray.append(taskObject as! Income)
        }
        
        if viewModel.total.isEmpty  {
            viewModel.dataStorage.saveDataToCoreData(
                                           withData: [moneyFormatted],
                                           entityName: Constants.EntityName.totalSum,
                                           key: ["totalIncome"])
            { taskObject in
                viewModel.total.append(taskObject as! TotalSum)
                viewModel.total[0].totalIncome = String(money ?? Int())
        
            }
        } else {
            let newSum = (Int(viewModel.total[0].totalIncome ?? String()) ?? Int()) + (money ?? Int())
            
            viewModel.dataStorage.updateAttributeValue(
                                                keyName: "totalIncome",
                                                value: String(newSum),
                                                entityName: Constants.EntityName.totalSum)
        }
        incomeView.reloadTableView()
    }
}
