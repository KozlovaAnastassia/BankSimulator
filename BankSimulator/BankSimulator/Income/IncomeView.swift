//
//  IncomeView.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

protocol IncomeViewDelegate {
    func tapButtonAddIncome()
    func getIncomeForCell(indexPath: IndexPath) -> String
    func getNumbersOfSection() -> Int
    func getTotalSum() -> String
}

class IncomeView: UIView  {
    
    var tableView =  UITableView()
    var cellIndetifire = "CellIncome"
    var delegate: IncomeViewDelegate?
    
    lazy var buttonAddIncome: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: Constants.ColorsHex.mainBlue)
        button.setTitle(Constants.ButtonTitle.income, for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(TapButtonAddIncome), for: .touchUpInside)
        
        return button
    }()
    
    lazy var labelHeader: UILabel = {
        let label = UILabel()
        label.text = "Доходы"
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        
        return label
    }()
    
    lazy var labelBalance: UILabel = {
        let label = UILabel()
        label.text = "Текущий баланс:"
        
        return label
    }()
    
    lazy var currentBalance: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.text = "0.00 P"
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var stackViewHorisontal: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.spacing = 50
        stack.addArrangedSubview(labelBalance)
        stack.addArrangedSubview(currentBalance)
        
        return stack
    }()
    
    lazy var stackViewVertical: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 30
        stack.addArrangedSubview(stackViewHorisontal)
        stack.addArrangedSubview(labelHeader)
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setViews()
        setTable()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func TapButtonAddIncome() {
        delegate?.tapButtonAddIncome()
    }
    
    func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndetifire)
    }

    func setViews() {
        addSubview(tableView)
        addSubview(buttonAddIncome)
        addSubview(stackViewVertical)
    }
    
    func setConstraints() {
        buttonAddIncome.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(344)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-120)
            
        }
        stackViewVertical.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(128)
            make.top.equalToSuperview().offset(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(stackViewVertical.snp_bottomMargin)
            make.bottom.equalTo(buttonAddIncome.snp_topMargin)
        }
    }
    
    func sentData() {
        tableView.reloadData()
    }
}

extension IncomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  delegate?.getNumbersOfSection() ?? Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifire , for: indexPath)
        cell.textLabel?.text = delegate?.getIncomeForCell(indexPath: indexPath)
        currentBalance.text = delegate?.getTotalSum()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}
