//
//  ExpensesDetailCell.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
///

import UIKit

class ExpensesDetailCell: UITableViewCell {
    
    private lazy var labelCategory: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelExpense: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.addArrangedSubview(labelCategory)
        stack.addArrangedSubview(labelDate)
        stack.addArrangedSubview(labelExpense)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(stackView)
    }
     
     private func setConstraints() {
         stackView.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.leading.equalTo(16)
             make.trailing.equalTo(-16)
             make.top.equalTo(16)
         }
     }
    
    func configure(_ viewModel: ExpensesDetail) {
        labelCategory.text = viewModel.category
        labelDate.text = viewModel.date
        labelExpense.text = Formuls.shared.twoNumbersAfterPoint(integer: Int(viewModel.money ?? String()) ?? Int())
    }
}


