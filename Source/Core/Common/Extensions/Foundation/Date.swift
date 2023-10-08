//
//  Date.swift
//

import Foundation

extension Date {
    
    var startOfDay: Self {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Self? {
        Calendar.current.startOfDay(for: self).adding(.day, value: 1)
    }
    
    var millisecondsSince1970: Int {
        Int((timeIntervalSince1970 * 1000).rounded())
    }
    
    func adding(_ unit: Calendar.Component, value: Int) -> Date? {
        Calendar.current.date(byAdding: unit, value: value, to: self)
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
