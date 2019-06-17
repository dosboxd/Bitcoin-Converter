//
//  NowModel.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Charts
import Foundation

protocol NowModel {
    
    var view: NowScreenViewProtocol? { get set }
    
    func fetchPrice(for currency: Currency, completion: @escaping (String?) -> Void)
    func fetchHistoricalPrice(for currency: Currency, interval: ChartDateInterval, completion: @escaping (ChartDataSet?) -> Void)
}

final class NowModelImp: NowModel {
    
    weak var view: NowScreenViewProtocol?
    
    func fetchPrice(for currency: Currency, completion: @escaping (String?) -> Void) {
        NetworkLayerImp.shared.request(to: CoindeskAPI.price(currency: currency)) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showError(message: error.localizedDescription)
            case .success(let data):
                print(data)
                do {
                    let decoded = try JSONDecoder().decode(Price.self, from: data)
                    let rate = decoded.bpi?[currency.code]?.rate
                    UserDefaults.standard.set(decoded.bpi?[currency.code]?.rateFloat, forKey: currency.code)
                    completion(rate)
                } catch {
                    print(error)
                    self.view?.showError(message: error.localizedDescription)
                }
                
            }
        }
    }
    
    func fetchHistoricalPrice(for currency: Currency, interval: ChartDateInterval, completion: @escaping (ChartDataSet?) -> Void) {
        
        let startDate = interval.date.toString(dateFormat: "yyyy-MM-dd")
        let endDate = Date().toString(dateFormat: "yyyy-MM-dd")
        let currency = currency.code
        let queryItems = ["start": startDate, "end": endDate, "currency": currency]
        
        NetworkLayerImp.shared.request(to: CoindeskAPI.historicalBPI, queryItems: queryItems) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showError(message: error.localizedDescription)
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(HistoricalBPI.self, from: data)
                    let calculated = self.convertChartDataEntry(from: decodedData, for: interval)
                    
                    let set = LineChartDataSet(entries: calculated.sorted(by: { $0.x < $1.x }), label: interval.string)
                    completion(set)
                } catch {
                    print(error)
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func convertChartDataEntry(from data: HistoricalBPI, for interval: ChartDateInterval) -> [ChartDataEntry] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if interval == .week {
            return data.bpi?.compactMap({
                guard let date = dateFormatter.date(from: $0.key) else { return nil }
                // returning without calculating average
                let timeInterval = Double(date.timeIntervalSinceNow)
                return ChartDataEntry(x: timeInterval, y: $0.value)
            }) ?? []
            
        } else if interval ==  .month || interval == .year {
            // creating dictionary with unique identifiers of out date components
            var dataSource = [Int: [(timestamp: Double, value: Double)]]()
            _ = data.bpi?.map({
                guard let date = dateFormatter.date(from: $0.key) else { return }
                let dateID = Calendar.current.component(interval.calendarComponent, from: date)
                
                // checking if it's nil – we create one and if not – we append
                if dataSource[dateID] == nil {
                    dataSource[dateID] = [(timestamp: date.timeIntervalSinceNow, value: $0.value)]
                } else {
                    dataSource[dateID]?.append((timestamp: date.timeIntervalSinceNow, value: $0.value))
                }
            })
            
            var dataSourceByDate = [Double: [Double]]()
            _ = dataSource.map({ day in
                guard let max = day.value.max(by: { $0.timestamp > $1.timestamp })?.timestamp else { return }
                dataSourceByDate[max] = day.value.map({$0.value})
            })
            
            // calculating average of week and month
            return dataSourceByDate.compactMap({ component in
                guard component.value.count > 0 else { return nil }
                let sum = component.value.reduce(0, +)
                let average = sum / Double(component.value.count)
                return ChartDataEntry(x: Double(component.key), y: average)
            })
        }
        
        return []
    }
}
