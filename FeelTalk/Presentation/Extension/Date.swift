//
//  Date.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String?.self, forKey: key),
              let date = from(dateString: dateString) else { return nil }
        
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormetter = DateFormatter()
        
        dateFormetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormetter.locale = Locale(identifier: "kr_KR")
        
        if let date = dateFormetter.date(from: dateString) { return date }
        
        return nil
    }
} 
