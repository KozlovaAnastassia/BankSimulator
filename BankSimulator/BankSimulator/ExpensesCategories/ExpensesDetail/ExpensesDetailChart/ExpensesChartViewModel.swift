//
//  ExpensesChartViewModel.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit
import Charts

protocol ExpensesChartViewModelProtocol {
    var dataStorage: LocalDataServiceProtocol {get}
    var chartArray: [ExpensesDetail] {get set}
    
    func getdataFromCoreData(id: String)
    func prepareForChart(lineChartView: LineChartView)
}

class ExpensesChartViewModel: ExpensesChartViewModelProtocol {
    
    var dataStorage: LocalDataServiceProtocol
    var chartArray = [ExpensesDetail]()
    private var dateArray = [String]()
    private var expensesArray = [Int]()
    
    init(dataStorage: LocalDataServiceProtocol) {
        self.dataStorage = dataStorage
    }
    
    private func getFormattedDateArray(dateArray: [String]) -> [String] {
        var newDataArray = [String]()
        for i in dateArray {
            var a = String(i)
            for _ in 1...3 {
                  a.removeLast()
            }
            newDataArray.append(a)
        }
        return newDataArray
    }
    
    private func getChartDataEntry(values: [Int], dateFormattedArray: [String] ) -> [ChartDataEntry]{
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dateFormattedArray.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        return dataEntries
    }
    
    private func setupLineChartData(dataEntries: [ChartDataEntry]) -> LineChartData {
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.colors = [NSUIColor.red]
        let data = LineChartData(dataSet: dataSet)
        setupDataSet(dataSet: dataSet)
        return data
    }
    
    private func setupDataSet(dataSet: LineChartDataSet) {
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 2
        dataSet.circleColors = [NSUIColor.gray]
        dataSet.circleRadius = 5
        dataSet.form = .empty
        dataSet.label = ""
        
    }
    
    private func setupLineChartData(_ lineChartView: LineChartView, dataPoints: [String], values: [Int]) {
        
        let dateFormattedArray = getFormattedDateArray(dateArray: dataPoints)
        let dataEntries = getChartDataEntry(values: values, dateFormattedArray: dateFormattedArray)
        let data = setupLineChartData(dataEntries: dataEntries)
        
        lineChartView.noDataText = "Нет данных для графика"
        lineChartView.data = data
        lineChartView.xAxis.setLabelCount(dateFormattedArray.count, force: true)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateFormattedArray)
    }
    
    func prepareForChart(lineChartView: LineChartView) {
        var expensesDict = [String: Int]()
        var valeue = 0
        
        for i in chartArray {
            if expensesDict[i.date ?? String()] != nil {
                valeue += (Int(i.money ?? String()) ?? Int())
                expensesDict[i.date ?? String()] = valeue
            } else {
                expensesDict[i.date ?? String()] = (Int(i.money ?? String()) ?? Int())
                valeue = (Int(i.money ?? String()) ?? Int())
            }
        }
        let sortedArray = expensesDict.sorted {(Formuls.shared.stringToDate($0.key) ?? Date())  < (Formuls.shared.stringToDate($1.key) ?? Date()) }
        
        for (k, v) in sortedArray {
            dateArray.append(k)
            expensesArray.append(v)
        }
        
        for i in dateArray {
            print(i)
        }
        
        setupLineChartData(lineChartView, dataPoints: dateArray, values: expensesArray)
    }
    
    func getdataFromCoreData(id: String) {
        if let expense =  dataStorage.fetchDataFromCoreData(entityName: Constants.EntityName.expensesDetail,
                                                            predicateFormat: "id == %@",
                                                            predicateValue: id)
        {
            for i in expense {
                chartArray.append(i as! ExpensesDetail)
            }
        }
    }
    
}
