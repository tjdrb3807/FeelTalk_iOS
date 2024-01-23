//
//  Date.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation

enum DateCompare {
    case future
    case past
    case same
    case error
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String?.self, forKey: key),
              let date = from(dateString: dateString) else { return nil }
        
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormetter = DateFormatter()
        
        dateFormetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormetter.locale = Locale(identifier: "ko-KR")
        
        if let date = dateFormetter.date(from: dateString) { return date }
        
        return nil
    }
    
    static func dateToStr(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        
        return formatter.string(from: date)
    }
    
    static func strToDate(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko-KR")
        
        
        if let date = formatter.date(from: date) {
            return date
        } else {
            return nil
        }
    }
    
    static func compareDate(target: Date, from: Date) -> DateCompare? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let targetDateStr = formatter.string(from: target)
        let fromDateStr = formatter.string(from: from)
        
        guard let targetDate = formatter.date(from: targetDateStr),
              let fromDate = formatter.date(from: fromDateStr) else { return nil }
        
        switch targetDate.compare(fromDate) {
        case .orderedAscending:
            return .past
        case .orderedSame:
            return .same
        case .orderedDescending:
            return .future
        }
    }
} 
