//
//  ExpensesChartView.swift
//  BankSimulator
//
//  Created by Анастасия on 27.09.2023.
//

import UIKit
import Charts

class ExpensesChartView: UIView {
    
     lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        return lineChartView
    }()
    
    private lazy var labelChart: UILabel = {
        let label = UILabel()
        label.text = "График расходов"
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubviews()
        setConstraints()
        setupLineChartVisual()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(lineChartView)
        addSubview(labelChart)
    }
    
    private func setupLineChartVisual() {
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 14, weight: .bold)
        
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.rightAxis.axisMinimum = 0.0
        
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 14, weight: .bold)
        lineChartView.setDragOffsetX(30)
        
        lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    private func setConstraints() {
        lineChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(-200)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        labelChart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
}

