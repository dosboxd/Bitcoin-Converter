//
//  NowViewController.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit
import SnapKit
import Charts

protocol NowScreenViewProtocol: class {
    func showError(message: String)
}

class NowViewController: UIViewController, NowScreenViewProtocol {
    
    lazy var currenciesSC: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: Currency.usd.code, at: 0, animated: true)
        sc.insertSegment(withTitle: Currency.eur.code, at: 1, animated: true)
        sc.insertSegment(withTitle: Currency.kzt.code, at: 2, animated: true)
        sc.addTarget(self, action: #selector(currencyChanged), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    lazy var intervalSC: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: ChartDateInterval.year.string, at: 0, animated: true)
        sc.insertSegment(withTitle: ChartDateInterval.month.string, at: 1, animated: true)
        sc.insertSegment(withTitle: ChartDateInterval.week.string, at: 2, animated: true)
        sc.addTarget(self, action: #selector(intervalChanged), for: .valueChanged)
        sc.selectedSegmentIndex = 2
        return sc
    }()
    
    var charts = LineChartView()
    var model: NowModel!
    
    let currencyValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        model = NowModelImp()
        model.view = self
        loadData()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.addArrangedSubview(currenciesSC)
        sv.addArrangedSubview(currencyValueLabel)
        sv.addArrangedSubview(charts)
        sv.addArrangedSubview(intervalSC)
        view.addSubview(sv)
        
        charts.snp.makeConstraints { make in
            make.height.equalTo(256).priority(.required)
        }
        
        sv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        charts.drawGridBackgroundEnabled = false
        charts.legend.form = .empty
        
    }
    
    func loadData() {
        setupRate(for: .usd)
        setupChart()
    }
    
    func setupRate(for currency: Currency) {
        model.fetchPrice(for: currency) { [weak self] rate in
            DispatchQueue.main.async {
                self?.currencyValueLabel.text = rate
            }
        }
    }
    
    func setupChart() {
        let currency = Currency(rawValue: currenciesSC.selectedSegmentIndex) ?? Currency.usd // default
        if let interval = ChartDateInterval(rawValue: intervalSC.selectedSegmentIndex) {
            model.fetchHistoricalPrice(for: currency, interval: interval) { [weak self] set in
                DispatchQueue.main.async {
                    self?.charts.data = LineChartData(dataSet: set)
                    self?.charts.noDataText = "no data"
                    self?.charts.notifyDataSetChanged()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM"
                    self?.charts.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: TimeInterval(Date().timeIntervalSinceNow), dateFormatter: formatter)
                }
            }
        }
    }
    
    func showError(message: String) {
        showAlert(title: message, message: "Would you like to redownload data?", cancel: true) {
            self.loadData()
        }
    }
    
    @objc func currencyChanged(_ segmentedControl: UISegmentedControl) {
        if let currency = Currency(rawValue: segmentedControl.selectedSegmentIndex) {
            setupRate(for: currency)
            setupChart()
        }
    }
    
    @objc func intervalChanged(_ segmentedControl: UISegmentedControl) {
        print("interval changed")
        setupChart()
    }
}

