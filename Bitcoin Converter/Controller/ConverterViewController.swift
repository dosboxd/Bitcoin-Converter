//
//  ConverterViewController.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/13/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

final class ConverterViewController: UIViewController {
    
    lazy var currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: Currency.allCases.map({$0.code}))
        control.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        control.selectedSegmentIndex = 0
        control.tintColor = .titleBlue
        return control
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 36, weight: .semibold)
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        return textField
    }()
    
    let btcLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .titleBlue
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var selectedCurrency: Currency = .usd {
        didSet {
            if let text = textField.text, let double = Double(text) {
                convert(value: double)
            }
            print(selectedCurrency)
        }
    }
    
    var btc: Double = 1.0
    var usd: Double = 0.0
    var eur: Double = 0.0
    var kzt: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usd = UserDefaults.standard.value(forKey: "USD") as? Double ?? 0
        eur = UserDefaults.standard.value(forKey: "EUR") as? Double ?? 0
        kzt = UserDefaults.standard.value(forKey: "KZT") as? Double ?? 0
        
        hideKeyboardWhenTappedAround()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(currencySegmentedControl)
        view.addSubview(textField)
        currencySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(28)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(currencySegmentedControl.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        
        stackView.addArrangedSubview(btcLabel)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    @objc func valueChanged(_ control: UISegmentedControl) {
        selectedCurrency = Currency(rawValue: control.selectedSegmentIndex) ?? .usd
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text, let double = Double(text) {
            convert(value: double)
        }
    }
    
    func convert(value: Double) {
        let converted: Double
        switch selectedCurrency {
        case .usd:
            converted = value / usd
        case .eur:
            converted = value / eur
        case .kzt:
            converted = value / kzt
        }
        
        let truncated = Double(round(100000000 * converted) / 100000000)
        btcLabel.text = "BTC " + String(truncated)
    }
}
