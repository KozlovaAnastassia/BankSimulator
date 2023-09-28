//
//  ExpensesCategoriesView.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit

protocol ExpensesCategoriesViewDelegate: AnyObject {
    func tapButtonAddExpenses()
    func getExpensesCategoryForCell(indexPath: IndexPath) -> String
    func getNumbersOfSection() -> Int
    func pushToBottomSheetVC(indexPath: IndexPath)
}

class ExpensesCategoriesView: UIView {
    
    weak var delegate: ExpensesCategoriesViewDelegate?
    private let expensesTableView = UITableView()
    private let identifireCell = "cellExpenses"
    
    private lazy var buttonAddExpense: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: Constants.ColorsHex.mainBlue)
        button.setTitle(Constants.ButtonTitle.expensesCategory, for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(tapButtonAddExpenses), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(buttonAddExpense)
        setTable()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapButtonAddExpenses(){
        delegate?.tapButtonAddExpenses()
    }
    
    private func setConstraints() {
        buttonAddExpense.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(344)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-120)
        }
        expensesTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalToSuperview().offset(-170)
        }
    }
    private func setTable() {
        expensesTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifireCell)
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        addSubview(expensesTableView)
    }
    
    func reloadTableView() {
        expensesTableView.reloadData()
    }
}


extension ExpensesCategoriesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.getNumbersOfSection()  ?? Int()}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifireCell, for: indexPath)
        
        cell.textLabel?.text = delegate?.getExpensesCategoryForCell(indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.addCustomDisclosureIndicator(with: UIColor(hexString: Constants.ColorsHex.mainBlue))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushToBottomSheetVC(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel(frame: CGRect(x: 130, y: 0, width: tableView.bounds.size.width, height: 30))
        headerLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        headerLabel.textColor = .black
        headerLabel.text = "Расходы"
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
