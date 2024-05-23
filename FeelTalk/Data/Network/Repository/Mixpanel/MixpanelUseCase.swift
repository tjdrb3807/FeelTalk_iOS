//
//  MixpanelUseCase.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/05/21.
//

import Foundation
import Mixpanel

final class MixpanelRepository {
    static let shared = MixpanelRepository()
    
    // MARK: Cache
    var pageCountPair: (String, Int)? = nil
    var chatTimer: Timer? = nil
    var questionTimer: Timer? = nil
    var answerTimer: Timer? = nil
}


// MARK: p0

extension MixpanelRepository {
    func logIn(id: Int) {
        Mixpanel.mainInstance().identify(distinctId: "\(id)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        let isActive = getUserActiveDateLocal() == now
        Mixpanel.mainInstance().registerSuperProperties([
            "isActive": isActive
        ])
    }
    
    func navigatePage() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        
        var (date, count) = getPageNavigationCountCache()
        ?? getPageNavigationCountLocal()
        ?? (now, 0)
        
        if date < now {
            date = now
            count = 1
        } else {
            count += 1
        }
        savePageNavigationCountCache(date: date, count: count)
        savePageNavigationCountLocal(date: date, count: count)
        
        if count == 3 {
            saveUserActiveDateLocal(date: date)
        }
        
        let isActive = count >= 3 || getUserActiveDateLocal() == date
        Mixpanel.mainInstance().registerSuperProperties([
            "isActive": isActive
        ])
    }
    
    func setInChatSheet(isInChat: Bool) {
        if isInChat {
            startChatTimer()
        } else {
            cancelChatTimer()
        }
    }
    
    func setInQuestionPage(isInQuestion: Bool) {
        if isInQuestion {
            startQuestionTimer()
        } else {
            cancelQuestionTimer()
        }
    }
    
    func setInAnswerSheet(isInAnswer: Bool) {
        if isInAnswer {
            startAnswerTimer()
        } else {
            cancelAnswerTimer()
        }
    }
    
    func answerQuestion() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        
        saveUserActiveDateLocal(date: now)
        Mixpanel.mainInstance().registerSuperProperties([
            "isActive": true
        ])
    }
    
}
 

// MARK: p1

extension MixpanelRepository {
    func sendChat() {
        Mixpanel.mainInstance().track(event: "Send Chat")
    }
    
    func shareContent() {
        Mixpanel.mainInstance().track(event: "Click Chat Menu Share Button")
    }
    
    func setInContentShare(isInContentShare: Bool) {
        if isInContentShare {
            startContentShareTimer()
            Mixpanel.mainInstance().track(event: "Open Chat Menu")
        } else {
            cancelContentShareTimer()
        }
    }
    
    func openSignalSheet() {
        Mixpanel.mainInstance().track(event: "Open Signal Sheet")
    }
    
    func changeMySignal() {
        Mixpanel.mainInstance().track(event: "Change Signal")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let lastDateString = getSignalChangeDateLocal() else { return }
        guard let lastDate = dateFormatter.date(from: lastDateString) else { return }
        let nowDate = Date()
        saveSignalChangeDateLocal(date: dateFormatter.string(from: nowDate))
        
        let diff = nowDate.timeIntervalSince1970 - lastDate.timeIntervalSince1970
        let totalSeconds = Int(diff / 1000)
        let totalMinutes = totalSeconds / 60
        let totalHours = totalMinutes / 60
        
        let seconds = totalSeconds % 60
        let minutes = totalMinutes % 60
        let dateTime = "\(totalHours):\(minutes):\(seconds)"
        
        Mixpanel.mainInstance().track(
            event: "Signal Change Interval",
            properties: ["Time_BetweenChangeSignal": dateTime]
        )
    }
    
    func addChallenge() {
        Mixpanel.mainInstance().track(event: "Add Challenge")
    }
    
    func completeChallenge() {
        Mixpanel.mainInstance().track(event: "Complete Challenge")
    }
    
    func deleteChallenge() {
        Mixpanel.mainInstance().track(event: "Delete Challenge")
    }
    
    func openCompletedChallengeDetail() {
        Mixpanel.mainInstance().track(event: "Open Completed Challenge Detail")
    }
    
}


// MARK: Cache Data Source

extension MixpanelRepository {
    
    // MARK: p0
    
    private func startChatTimer() {
        cancelChatTimer()
        chatTimer = Timer.scheduledTimer(withTimeInterval: 300000, repeats: false) { timer in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let now = dateFormatter.string(from: Date())
            
            Mixpanel.mainInstance().track(
                event: "Session Chat",
                properties: ["ChatDate": now]
            )
        }
    }
    
    private func cancelChatTimer() {
        chatTimer?.invalidate()
        chatTimer = nil
    }
    
    private func startQuestionTimer() {
        cancelQuestionTimer()
        questionTimer = Timer.scheduledTimer(withTimeInterval: 300000, repeats: false) { timer in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let now = dateFormatter.string(from: Date())
            
            Mixpanel.mainInstance().track(
                event: "Session Question",
                properties: ["QuestionDate": now]
            )
        }
    }
    
    private func cancelQuestionTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }
    
    private func startAnswerTimer() {
        cancelAnswerTimer()
        questionTimer = Timer.scheduledTimer(withTimeInterval: 300000, repeats: false) { timer in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let now = dateFormatter.string(from: Date())
            
            Mixpanel.mainInstance().track(
                event: "Session Question",
                properties: ["QuestionDetailDate": now]
            )
        }
    }
    
    private func cancelAnswerTimer() {
        answerTimer?.invalidate()
        answerTimer = nil
    }
    
    private func savePageNavigationCountCache(date: String, count: Int) {
        pageCountPair = (date, count)
    }
    
    private func getPageNavigationCountCache() -> (String, Int)? {
        return pageCountPair
    }
    
    
    // MARK: p1
    
    private func startContentShareTimer() {
        
    }
    
    private func cancelContentShareTimer() {
        
    }
    
}


// MARK: Local Data Sources

extension MixpanelRepository {
    
    // MARK: p0
    
    private func saveUserActiveDateLocal(date: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = "mixpanel_user_active_date.txt"
        let fileUrl = dir.appendingPathComponent(fileName)
    
        do {
            try date.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func getUserActiveDateLocal() -> String? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName = "mixpanel_user_active_date.txt"
        let fileUrl = dir.appendingPathComponent(fileName)
        
        do {
            let isUserActive = try String(contentsOf: fileUrl, encoding: .utf8)
            return isUserActive
        } catch {
            return nil
        }
    }
    
    private func savePageNavigationCountLocal(date: String, count: Int) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName1 = "mixpanel_page_navigation_date.txt"
        let fileUrl1 = dir.appendingPathComponent(fileName1)
        
        let fileName2 = "mixpanel_page_navigation_count.txt"
        let fileUrl2 = dir.appendingPathComponent(fileName2)
    
        do {
            try date.write(to: fileUrl1, atomically: false, encoding: .utf8)
            try "\(count)".write(to: fileUrl2, atomically: false, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func getPageNavigationCountLocal() -> (String, Int)? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName1 = "mixpanel_page_navigation_date.txt"
        let fileUrl1 = dir.appendingPathComponent(fileName1)
        
        let fileName2 = "mixpanel_page_navigation_count.txt"
        let fileUrl2 = dir.appendingPathComponent(fileName2)
        
        do {
            let date = try String(contentsOf: fileUrl1, encoding: .utf8)
            guard let count = Int(try String(contentsOf: fileUrl2, encoding: .utf8))
            else { return nil }
            return (date, count)
        } catch {
            return nil
        }
    }
    
    
    // MARK: p1
    
    private func saveSignalChangeDateLocal(date: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = "mixpanel_signal_change_date.txt"
        let fileUrl = dir.appendingPathComponent(fileName)
    
        do {
            try date.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func getSignalChangeDateLocal() -> String? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName = "mixpanel_signal_change_date.txt"
        let fileUrl = dir.appendingPathComponent(fileName)
        
        do {
            let signalChangeDate = try String(contentsOf: fileUrl, encoding: .utf8)
            return signalChangeDate
        } catch {
            return nil
        }
    }
    
}
