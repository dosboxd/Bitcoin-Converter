//
//  TransactionEntityViewController.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/13/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

final class TransactionEntityViewController: UIViewController {
    
    let transaction: Transaction
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let idValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let dateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let sumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let sumValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupProperties()
    }
    
    func setupViews() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(64)
        }
        
        let idStackView = UIStackView()
        idStackView.axis = .vertical
        idStackView.alignment = .leading
        idStackView.distribution = .fill
        idStackView.spacing = 8
        
        idStackView.addArrangedSubview(idLabel)
        idStackView.addArrangedSubview(idValueLabel)
        
        let priceStackView = UIStackView()
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        priceStackView.distribution = .fill
        priceStackView.spacing = 8
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        let dateStackView = UIStackView()
        dateStackView.axis = .vertical
        dateStackView.alignment = .leading
        dateStackView.distribution = .fill
        dateStackView.spacing = 8
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateValueLabel)
        
        let sumStackView = UIStackView()
        sumStackView.axis = .vertical
        sumStackView.alignment = .leading
        sumStackView.distribution = .fill
        sumStackView.spacing = 8
        
        sumStackView.addArrangedSubview(sumLabel)
        sumStackView.addArrangedSubview(sumValueLabel)
        
        let parentStackView = UIStackView()
        parentStackView.axis = .vertical
        parentStackView.alignment = .fill
        parentStackView.distribution = .fill
        parentStackView.spacing = 8
        
        parentStackView.addArrangedSubview(idStackView)
        parentStackView.addArrangedSubview(priceStackView)
        parentStackView.addArrangedSubview(dateStackView)
        parentStackView.addArrangedSubview(sumStackView)
        
        view.addSubview(parentStackView)
        parentStackView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).inset(-64)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func setupProperties() {
        title = transaction.type?.title
        typeLabel.text = transaction.type?.title
        amountLabel.attributedText = transaction.attributedAmount
        
        idLabel.text = "Идентификатор:"
        if let id = transaction.tid {
            idValueLabel.text = String(describing: id)
        }
        
        priceLabel.text = "Цена:"
        if let price = transaction.price {
            priceValueLabel.text = Currency.usd.code + " " + price
        }
        
        dateLabel.text = "Дата и время:"
        dateValueLabel.text = transaction.date?.toString()
        
        if let sum = transaction.sum {
            sumLabel.text = "Сумма:"
            let numberOfPlaces = 2.0
            let multiplier = pow(10.0, numberOfPlaces)
            let rounded = round(sum * multiplier) / multiplier
            sumValueLabel.text = Currency.usd.code + " " + String(describing: rounded)
        }
    }
}
