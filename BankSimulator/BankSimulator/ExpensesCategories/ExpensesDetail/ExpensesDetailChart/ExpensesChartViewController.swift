//
//  ExpensesChart.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit

class ExpensesChartViewController: UIViewController {
    
    var itemId: String
    var viewModel: ExpensesChartViewModelProtocol
    let chartView = ExpensesChartView()

    override func viewDidLoad() {
          super.viewDidLoad()
        
        view = chartView
        viewModel.getdataFromCoreData(id: itemId)
        viewModel.prepareForChart(lineChartView: chartView.lineChartView)
    }
    
    init(itemId: String, viewModel: ExpensesChartViewModelProtocol) {
        self.itemId = itemId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


