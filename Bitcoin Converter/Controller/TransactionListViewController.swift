//
//  TransactionListViewController.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

final class TransactionListViewController: UIViewController {
    
    var transactions: [Transaction] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TransactionTableViewCell.self))
        return tableView
    }()
    
    var model: TranscationListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        model = TransactionListModelImp()
        model?.fetchTransactions { [weak self] transactions in
            DispatchQueue.main.async {
                self?.transactions = transactions ?? []
            }
        }
    }
    
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TransactionTableViewCell.self)) as? TransactionTableViewCell
        cell?.item = transactions[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transactionEntityVC = TransactionEntityViewController(transaction: transactions[indexPath.row])
        show(transactionEntityVC, sender: self)
    }
}

