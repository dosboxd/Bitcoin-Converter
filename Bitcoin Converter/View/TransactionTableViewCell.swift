//
//  TransactionTableViewCell.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/13/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    
    var item: Transaction? {
        didSet {
            typeLabel.text = item?.type?.title
            amountLabel.attributedText = item?.attributedAmount
            dateLabel.text = item?.date?.toString()
        }
    }
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .titleBlue
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.alignment = .leading
        vStackView.distribution = .fill
        vStackView.spacing = 8
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.distribution = .fill
        
        vStackView.addArrangedSubview(typeLabel)
        vStackView.addArrangedSubview(dateLabel)
        
        hStackView.addArrangedSubview(vStackView)
        hStackView.addArrangedSubview(amountLabel)
        
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
}
