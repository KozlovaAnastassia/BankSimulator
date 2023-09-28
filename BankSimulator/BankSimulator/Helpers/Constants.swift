//
//  Constants.swift
//  BankSimulator
//
//  Created by Анастасия on 28.09.2023.
//

import UIKit

enum Constants {
    
    enum EntityName {
        static var expensesCategories: String {
            "ExpensesCategories"
        }
        static var income: String  {
            "Income"
        }
        static var expensesDetail: String  {
            "ExpensesDetail"
        }
    }
    
    enum ColorsHex {
        static var mainBlue: String {
            "#007AFF"
        }
    }
    
    enum PlaceholderTitle {
        static var money: String {
            "Сумма"
        }
        static var category: String {
            "Наименование"
        }
    }
    
    enum ButtonTitle {
        static var income: String {
            "Добавить доход"
        }
        static var expensesCategory: String {
            "Добавить категорию расходов"
        }
        static var expensesDetail: String {
            "Добавить расход"
        }
    }
    
    enum ConstantArrays {
        static var initialExpensesCategory: [String] {
            ["Дом", "Продукты", "Досуг", "Постоянные траты", "Путешествия"]
        }
        static var category: String {
            "Наименование"
        }
    }
    
}
