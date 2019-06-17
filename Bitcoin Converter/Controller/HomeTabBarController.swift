//
//  HomeTabBarController.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nowVC = NowViewController()
        let transcationListVC = TransactionListViewController()
        let converterVC = ConverterViewController()
        
        nowVC.title = "Сейчас"
        transcationListVC.title = "Транзакции"
        converterVC.title = "Конвертер"
        
        nowVC.tabBarItem.image = UIImage(named: "now")
        transcationListVC.tabBarItem.image = UIImage(named: "transactions")
        converterVC.tabBarItem.image = UIImage(named: "exchange")
        
        viewControllers = [nowVC, transcationListVC, converterVC].map({ UINavigationController(rootViewController: $0) })
    }
    
}
