//
//  BottomSheetView.swift
//  BankSimulator
//
//  Created by Анастасия on 28.09.2023.
//

import UIKit
import SnapKit

protocol BottomSheetViewDelegate: AnyObject {
    func transit()
}

class BottomSheetView: UIView {
    private var state: StateOfConstrains?
    weak var delegate: BottomSheetViewDelegate?
    
    lazy var textFieldCategory: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    lazy var textFieldMoney: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#007AFF")
        button.setTitleColor( UIColor.blue, for: .highlighted)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(tapButtonAdd), for: .touchUpInside)
        return button
    }()
    
    init(state: StateOfConstrains, frame: CGRect) {
        self.state = state
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(buttonAdd)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapButtonAdd(){
        delegate?.transit()
    }
    
    private func setViews() {
        switch state {
        case .expensesDetail:
            addSubview(textFieldCategory)
            addSubview(textFieldMoney)
        case .income:
            addSubview(textFieldMoney)
        case .expenses:
            addSubview(textFieldCategory)
        default: break
        }
    }
    
    private func setConstraints() {
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

