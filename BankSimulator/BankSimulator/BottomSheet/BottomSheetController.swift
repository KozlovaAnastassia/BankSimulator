//
//  BottomSheetController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import Foundation
import UIKit
import SnapKit

enum StateOfConstrains {
    case income
    case expenses
    case expensesDetail
    case plain
}

protocol BottomSheetDelegate: AnyObject {
    func transit(_ category: String?, _ money: Int?)
}

class  BottomSheetController: UIViewController {
    weak var delegate: BottomSheetDelegate?
    
    var state = StateOfConstrains.plain
    var moneyPlaceholder: String?
    var categoryPlaceholder: String?
    var buttonAddTitle: String
    
    lazy var textFieldCategory: UITextField = {
        let textField = UITextField()
        textField.placeholder = categoryPlaceholder
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    lazy var textFieldMoney: UITextField = {
        let textField = UITextField()
        textField.placeholder = moneyPlaceholder
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#007AFF")
        button.setTitle(buttonAddTitle, for: .normal)
        button.setTitleColor( UIColor.blue, for: .highlighted)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(TapButtonAdd), for: .touchUpInside)
        
        return button
    }()
    
    init(moneyPlaceholder: String?, categoryPlaceholder: String?, buttonAddTitle: String){
        self.moneyPlaceholder = moneyPlaceholder
        self.buttonAddTitle = buttonAddTitle
        self.categoryPlaceholder = categoryPlaceholder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(buttonAdd)
        defineState()
        setViews()
        setConstraints()
    }
    
    func defineState() {
        if moneyPlaceholder != nil && categoryPlaceholder != nil {
            state = StateOfConstrains.expensesDetail
        } else if moneyPlaceholder != nil && categoryPlaceholder == nil {
            state = StateOfConstrains.income
        } else if moneyPlaceholder == nil && categoryPlaceholder != nil {
            state = StateOfConstrains.expenses
        }
    }
    func setViews() {
        switch state {
        case .expensesDetail:
            view.addSubview(textFieldCategory)
            view.addSubview(textFieldMoney)
        case .income:
            view.addSubview(textFieldMoney)
        case .expenses:
            view.addSubview(textFieldCategory)
        default: break
        }
    }
    
    @objc func TapButtonAdd() {
        switch state {
        case .expensesDetail:
            if let category = textFieldCategory.text, let money = Int(textFieldMoney.text ?? "") {
                delegate?.transit(category, money)
                self.dismiss(animated: true)
            }
        case .income:
            if let money = Int(textFieldMoney.text ?? "") {
                delegate?.transit(nil, money)
                self.dismiss(animated: true)
            }
        case .expenses:
            if let category = textFieldCategory.text {
                delegate?.transit(category, nil)
                self.dismiss(animated: true)
            }
        default: break
        }
    }
    
    func setConstraints() {
        switch state {
        case .expensesDetail:
            textFieldCategory.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(360)
                make.height.equalTo(64)
                make.top.equalToSuperview().offset(14)
            }
            textFieldMoney.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(360)
                make.height.equalTo(64)
                make.top.equalTo(78)
            }
            buttonAdd.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(344)
                make.height.equalTo(48)
                make.top.equalTo(145)
            }
        case .expenses:
            textFieldCategory.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(360)
                make.height.equalTo(64)
                make.top.equalToSuperview().offset(14)
            }
            buttonAdd.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(344)
                make.height.equalTo(48)
                make.top.equalTo(78)
            }
        case .income:
            textFieldMoney.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(360)
                make.height.equalTo(64)
                make.top.equalToSuperview().offset(14)
            }
            buttonAdd.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(344)
                make.height.equalTo(48)
                make.top.equalTo(78)
            }
        default: break
        }
    }
}

