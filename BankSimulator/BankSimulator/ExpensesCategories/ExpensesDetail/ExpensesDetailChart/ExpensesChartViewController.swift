//
//  ExpensesChart.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit

class ExpensesChartViewController: UIViewController {
    
    private var itemId: String
    private var viewModel: ExpensesChartViewModelProtocol
    private let chartView = ExpensesChartView()
    
    override func loadView() {
        super.loadView()
        view = chartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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


