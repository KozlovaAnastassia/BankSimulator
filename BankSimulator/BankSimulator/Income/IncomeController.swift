//
//  ViewController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit
import CoreData

class IncomeController: UIViewController, IncomeViewDelegate {

    private let newView = IncomeView()
    var viewModel: IncomeViewModellProtocol
    
    init(viewModel: IncomeViewModellProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view = newView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDataFromCoreData()
        viewModel.result = {
            self.newView.sentData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newView.delegate = self
    }
    
    func getDataForCell(indexPath: IndexPath) -> String {
        viewModel.getIncome(indexPath: indexPath)
    }
    
    func getNumbersOfSection() -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func getTotalSum() -> String {
        let totalSum = viewModel.incomeArray.last?.totalSum
        return Formuls.shared.twoNumbersAfterPoint(integer: Int(totalSum ?? String()) ?? Int())
    }
    
    func transit() {
        let vc = BottomSheetController(moneyPlaceholder: "Введите сумму", categoryPlaceholder: nil, buttonAddTitle: "Добавить доход")
        vc.delegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc , animated: true)
    }
}

extension IncomeController: BottomSheetDelegate {
    func transit(_ category: String?, _ money: Int?) {
        
        let newSum = (Int(viewModel.incomeArray.last?.totalSum ?? String()) ?? Int()) + (money ?? Int())
        let moneyFormatted = Formuls.shared.twoNumbersAfterPoint(integer: money ?? Int())
        
        viewModel.dataStorage.saveDataToCoreData(
                                       withData: [String(moneyFormatted), String(newSum)],
                                       entityName: "Income", key: ["income", "totalSum"])
                                            {taskObject in
                                                viewModel.incomeArray.append(taskObject as! Income)
                                            }
        newView.sentData()
    }
}
