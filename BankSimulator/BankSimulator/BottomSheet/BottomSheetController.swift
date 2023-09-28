//
//  BottomSheetController.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import UIKit

class BottomSheetController: UIViewController, BottomSheetViewDelegate {

    private let viewModel: BottomSheetViewModel
    private var bottomSheetView: BottomSheetView?

   init(viewModel: BottomSheetViewModel) {
       self.viewModel = viewModel
       super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    override func loadView() {
        super.loadView()
        bottomSheetView = BottomSheetView(state: viewModel.state, frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view = bottomSheetView
    }

   override func viewDidLoad() {
       super.viewDidLoad()
       bottomSheetView?.delegate = self
       addPlaceHolder()
   }
    
    private func addPlaceHolder() {
        bottomSheetView?.textFieldCategory.placeholder = viewModel.categoryPlaceholder
        bottomSheetView?.textFieldMoney.placeholder = viewModel.moneyPlaceholder
        bottomSheetView?.buttonAdd.setTitle(viewModel.buttonAddTitle, for: .normal)
    }

    func transit() {
       switch viewModel.state {
       case .expensesDetail:
           if let category = bottomSheetView?.textFieldCategory.text, let money = Int(bottomSheetView?.textFieldMoney.text ?? "") {
               viewModel.transitData(category: category, money: money)
               self.dismiss(animated: true)
           }
       case .income:
           if let money = Int(bottomSheetView?.textFieldMoney.text ?? "") {
               viewModel.transitData(category: nil, money: money)
               self.dismiss(animated: true)
           }
       case .expenses:
           if let category = bottomSheetView?.textFieldCategory.text {
               viewModel.transitData(category: category, money: nil)
               self.dismiss(animated: true)
           }
       default: break
       }
   }
}



