//
//  Extension+UITableView.swift
//  Infoday
//
//  Created by Thalia on 24/10/24.
//

import Foundation
import UIKit

extension UITableView {

    func setupTableViewCardCell() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(CardCell.self, forCellReuseIdentifier: "cell")
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 400
        self.backgroundColor = .backgroundColor
    }

//    func setupTableViewMenuCell() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.register(MenuCell.self, forCellReuseIdentifier: "cell")
//        self.backgroundColor = .clear
//        self.rowHeight = UITableView.automaticDimension
//        self.estimatedRowHeight = 400
//        self.backgroundColor = .backgroundColor
//        self.tableFooterView = UIView()
//    }
}
