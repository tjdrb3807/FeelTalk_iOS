//
//  Utils.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/11.
//

import UIKit

class Utils {
    public static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height   // 상태바 높이
    
    /**
     # safeAreaTopInset
     - Note: 현재 디바이스의 safeAreaTopInset값 반환
     */
    static func safeAreaTopInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? Utils.STATUS_HEIGHT
        } else {
            return Utils.STATUS_HEIGHT
        }
    }
    
    /**
     # safeAreaBottomInset
     - Note: 현재 디바이스의 safeAreaBottomInset값 반환
     */
    static func safeAreaBottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ??  0.0
        } else {
            return 0.0
        }
    }
}

// MARK: Date
extension Utils {
    static func convertDateToStr(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter.string(from: date)
    }
    
    static func calculateTimeInterval(time01: Date, time02: Date) -> Int {
        let interval = Int(time01.timeIntervalSince(time02))
        
        return interval
    }
    
    static func formatChallengeDeadline(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일까지"
        
        return formatter.string(from: date)
    }
    
    static func calculateDday(_ date: Date) -> String {
        let interval = date.timeIntervalSince(Date()) / 86400
        
        if interval < 0 {
            return "D-day"
        } else if interval > 999 {
            return "D+999"
        } else {
            return "D-\(Int(interval) + 1)"
        }
    }
}
