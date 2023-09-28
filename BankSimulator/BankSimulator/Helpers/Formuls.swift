//
//  Formuls.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import Foundation
import UIKit

class Formuls {
    
    static let shared = Formuls()
    
    func twoNumbersAfterPoint(integer: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.currencyGroupingSeparator = " "
        formatter.maximumFractionDigits = 2
        
        if let formattedAmount = formatter.string(from: NSNumber(value: integer)) {
            return formattedAmount + " р"
        } else {
            return String()
        }
    }
    
    func currentDateString() -> String {
        let currantDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let noww = dateFormatter.string(from: currantDate)
        
        let date = dateFormatter.date(from: noww)!
        dateFormatter.dateFormat = "dd.MM.yy"
        let now = dateFormatter.string(from: date)
        return now
    }
}
