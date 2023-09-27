//
//  TabBar.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import Foundation
import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            setTabBar(viewController: IncomeController(viewModel: IncomeViewModell(dataStorage: LocalDataService())), title: "Доходы", image: UIImage(systemName: "circle")),
            setViewController(viewController: UINavigationController(rootViewController: ExpensesCategoriesController(viewModel: ExpensesCategoriesViewModel(dataStorage: LocalDataService()))), title: "Расходы", image: UIImage(systemName: "circle")),
        ]
    }
    
    func setTabBar(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    func setViewController(viewController: UINavigationController, title: String, image: UIImage?) -> UINavigationController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
}

