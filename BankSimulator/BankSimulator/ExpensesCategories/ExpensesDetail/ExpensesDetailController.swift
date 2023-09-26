//
//  ExpensesDetailController.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import Foundation
import UIKit

class ExpensesDetailController: UIViewController {
    
    private var itemID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getID(id: String) {
        self.itemID = id
    }
    
}
