//
//  ChartDataModel.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/16/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Foundation
import Charts

enum ChartDateInterval: Int {
    case year = 0
    case month = 1
    case week = 2
    
    var string: String {
        switch self {
        case .year:
            return "Year"
        case .month:
            return "Month"
        case .week:
            return "Week"
        }
    }
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .year:
            return .month
        case .month:
            return .weekOfMonth
        case .week:
            return .weekday
        }
    }
    
    var date: Date {
        switch self {
        case .year:
            return Date(timeIntervalSinceNow: -(365.0 * 24.0 * 3600.0))
        case .month:
            return Date(timeIntervalSinceNow: -(30.0 * 24.0 * 3600.0))
        case .week:
            return Date(timeIntervalSinceNow: -(7.0 * 24.0 * 3600.0))
        }
    }
}

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSinceNow: value)
        return dateFormatter?.string(from: date) ?? "nil"
    }
    
}

