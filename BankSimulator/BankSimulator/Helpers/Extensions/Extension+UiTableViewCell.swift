//
//  Extension+UiTableViewCell.swift
//  BankSimulator
//
//  Created by Анастасия on 26.09.2023.
//

import UIKit

extension UITableViewCell {
    func addCustomDisclosureIndicator(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right",
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}
