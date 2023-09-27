//
//  ExpensesChart.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit
import Charts

class ExpensesChartViewController: UIViewController {
    
    var itemId: String
    var dataStorage = LocalDataService()
    var charArray = [ExpensesDetail]()
    var expensesArray = [Int]()
    var dateArray = [String]()

    override func viewDidLoad() {
          super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(lineChartView)

        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lineChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
        
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "ExpensesDetail", predicateFormat: "id == %@", predicateValue: itemId){
            for i in expense {
                charArray.append(i as! ExpensesDetail)
            }
        }
        for i in charArray {
            expensesArray.append(Int(i.money ?? String()) ?? Int())
            dateArray.append(i.date ?? String())
        }

        setupLineChart(lineChartView, dataPoints: dateArray, values: expensesArray)
    }
    
    init(itemId: String) {
        self.itemId = itemId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLineChart(_ lineChartView: LineChartView, dataPoints: [String], values: [Int]) {
        var dataEntries: [ChartDataEntry] = []
        var newDataArray = [String]()
        
        
        //преобразование даты без года
        for i in dataPoints {
            var a = i
            for _ in 1...3 {
                  a.removeLast()
            }
            newDataArray.append(a)
        }

        for i in 0..<newDataArray.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }

        for i in dataEntries {
            print(i)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.colors = [NSUIColor.red]

        let data = LineChartData(dataSet: dataSet)
        dataSet.drawValuesEnabled = false
        
        dataSet.lineWidth = 2
        dataSet.circleColors = [NSUIColor.gray]
        dataSet.circleRadius = 5
        dataSet.form = .empty
        dataSet.label = ""

        lineChartView.data = data
        
        lineChartView.xAxis.setLabelCount(newDataArray.count, force: true)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: newDataArray)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 14, weight: .bold)
        
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.rightAxis.axisMinimum = 0.0
        
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 14, weight: .bold)
        lineChartView.setDragOffsetX(30)
     
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}


