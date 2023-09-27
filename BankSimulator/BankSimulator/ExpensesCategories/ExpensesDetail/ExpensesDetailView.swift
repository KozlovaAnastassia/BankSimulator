//
//  ExpensesDetailView.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit

protocol ExpensesDetailViewDelegate: AnyObject {
    func getRowNumber() -> Int
    func getExpensesForCell(indexPath: IndexPath) -> ExpensesDetail
    func tapButtonAddExpenses()
    func tapButtonPaymentSchedule()
}

class ExpensesDetailView: UIView {
    let tableView = UITableView()
    let cellIndentifire = "ExpensesDetailCell"
    weak var delegate: ExpensesDetailViewDelegate?
    
    lazy var ButtonPaymentSchedule: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#007AFF")
        button.setTitle("График платежей", for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(tapButtonPaymentSchedule), for: .touchUpInside)
        return button
    }()

    lazy var addExpensesButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor(hexString: "#007AFF")
    button.setTitle("+", for: .normal)
    button.layer.cornerRadius = 35
    button.addTarget(self, action: #selector(tapButtonAddExpenses), for: .touchUpInside)
        return button
    }()

    lazy var labelExpenses: UILabel = {
        let label = UILabel()
        label.text = "Добавить расход"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setTable()
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapButtonAddExpenses() {
        delegate?.tapButtonAddExpenses()
    }
    
    @objc func tapButtonPaymentSchedule() {
        delegate?.tapButtonPaymentSchedule()
    }
    
    func addSubview() {
        addSubview(tableView)
        addSubview(addExpensesButton)
        addSubview(labelExpenses)
        addSubview(ButtonPaymentSchedule)
    }
    
    func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExpensesDetailCell.self, forCellReuseIdentifier: cellIndentifire)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }

    func setConstraints() {
        ButtonPaymentSchedule.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(344)
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(100)
        }
        addExpensesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.bottom.equalTo(labelExpenses.snp_topMargin)
        }
        labelExpenses.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-100)
        }
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(170)
            make.bottom.equalTo(addExpensesButton.snp_topMargin)
        }
    }
}

extension ExpensesDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.getRowNumber() ?? Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifire)  as? ExpensesDetailCell
        let viewModel = delegate?.getExpensesForCell(indexPath: indexPath) ?? ExpensesDetail()
        cell?.configure(viewModel)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
}
