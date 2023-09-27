//
//  ChartIncomeExpenseController.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit
import Charts

class ChartIncomeExpenseController: UIViewController {
    
    var dataStorage = LocalDataService()
    var charExpensesArray = [ExpensesDetail]()
    var charIncomeArray = [Income]()
    
    var expensesArray = [Int]()
    var dateArray = [String]()
    var incomeArray = [Int]()

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
        
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "ExpensesDetail", predicateFormat: nil, predicateValue: nil){
            for i in expense {
                charExpensesArray.append(i as! ExpensesDetail)
            }
        }
        
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: "Income", predicateFormat: nil, predicateValue: nil){
            for i in expense {
                charIncomeArray.append(i as! Income)
            }
        }
        
        
        for i in charExpensesArray {
            expensesArray.append(Int(i.money ?? String()) ?? Int())
            dateArray.append(i.date ?? String())
        }
        
        for i in charIncomeArray {
            incomeArray.append(Int(i.income ?? String()) ?? Int())
         //   dateArray.append(i.date ?? String())
        }
        

        setupLineChart(lineChartView, dataPoints: dateArray, values: expensesArray)
        setupLineChart(lineChartView, dataPoints: dateArray, values: incomeArray)
    }
    
    
    func setupLineChart(_ lineChartView: LineChartView, dataPoints: [String], values: [Int]) {
        var dataEntries: [ChartDataEntry] = []
        var newDataArray = [String]()
        
        
//        //преобразование даты без года
//        for i in dataPoints {
//            var a = i
//            for _ in 1...3 {
//                  a.removeLast()
//            }
//            newDataArray.append(a)
//        }
        

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
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
      //  lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: newDataArray)
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
