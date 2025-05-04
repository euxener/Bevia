//
//  DailyLogViewModel.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Combine

class DailyLogViewModel: ObservableObject {
    @Published var dailyLogs: [DailyLog] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let dataService: DataServiceProtocol
    private let babyId: UUID
    
    init(babyId: UUID, dataService: DataServiceProtocol) {
        self.babyId = babyId
        self.dataService = dataService
        loadDailyLogs()
    }
    
    func loadDailyLogs(forDate: Date? = nil) {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else {return}
            self.dailyLogs = self.dataService
                .loadAllDailyLogs(babyId: self.babyId, forDate: forDate)
            self.isLoading = false
            
            if self.dailyLogs.isEmpty {
                if forDate != nil {
                    self.errorMessage = "No logs for this date"
                } else {
                    self.errorMessage = "No logs found"
                }
            }
        }
    }
    
    // MARK: - Feeding Log Methods
    
    func addFeedingLog(date: Date, time: Date, feedingType: FeedingType, amount: Double?, duration: Int?, notes: String?) {
        let feedingLog = FeedingLog(
            babyId: babyId,
            date: date,
            time: time,
            feedingType: feedingType,
            amount: amount,
            duration: duration,
            notes: notes
        )
        
        let dailyLog = DailyLog(
            id: feedingLog.id,
            babyId: babyId,
            date: date,
            time: time,
            logType: "feeding",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            loadDailyLogs(forDate: date)
        } else {
            errorMessage = "Failed to save feeding log"
        }
    }
    
    func updateFeedingLog(logId: UUID, date: Date, time: Date, feedingType: FeedingType, amount: Double?, duration: Int?, notes: String?) {
        let feedingLog = FeedingLog(
            id: logId,
            babyId: babyId,
            date: date,
            time: time,
            feedingType: feedingType,
            amount: amount,
            duration: duration,
            notes: notes
        )
        
        let dailyLog = DailyLog(
            babyId: feedingLog.id,
            date: date,
            time: time,
            logType: "feeding",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            if let index = dailyLogs.firstIndex(where: {$0.id == logId}) {
                dailyLogs[index] = dailyLog
            }
        } else {
            errorMessage = "Failed to update feeding log"
        }
    }
    
    // MARK: - Sleep Log Methods
    
    func addSleepLog(date: Date, startTime: Date, endTime: Date?, quality: SleepQuality?, notes: String?) {
        let sleepLog = SleepLog(
            babyId: babyId, date: date, startTime: startTime, endTime: endTime!, quality: quality, notes: notes
        )
        
        let dailyLog = DailyLog(
            id: sleepLog.id,
            babyId: babyId,
            date: date,
            time: startTime,
            logType: "sleep",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            loadDailyLogs(forDate: date)
        } else {
            errorMessage = "Failed to save sleep log"
        }
    }
    
    func updateSleepLog(logId: UUID, date: Date, startTime: Date, endTime: Date?, quality: SleepQuality?, notes: String?) {
        let sleepLog = SleepLog(
            babyId: babyId,
            date: date,
            startTime: startTime,
            endTime: endTime!,
            quality: quality,
            notes: notes
        )
        
        let dailyLog = DailyLog(
            id: sleepLog.id,
            babyId: babyId,
            date: date,
            time: startTime,
            logType: "sleep",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            if let index = dailyLogs.firstIndex(where: {$0.id == logId}) {
                dailyLogs[index] = dailyLog
            }
        } else {
            errorMessage = "Failed to update sleep log"
        }
    }
    
    // MARK: - Diaper Log Methods
    
    func addDiaperLog(date: Date, time: Date, diaperType: DiaperType, notes: String?) {
        let diaperLog = DiaperLog(
            babyId: babyId,
            date: date,
            time: time,
            diaperType: diaperType,
            notes: notes
        )
        
        let dailyLog = DailyLog(
            id: diaperLog.id,
            babyId: babyId,
            date: date,
            time: time,
            logType: "diaper",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            loadDailyLogs(forDate: date)
        } else {
            errorMessage = "Failed to save diaper log"
        }
    }
    
    func updateDiaperLog(logId: UUID, date: Date, time: Date, diaperType: DiaperType, notes: String?) {
        let diaperLog = DiaperLog(
            id: logId,
            babyId: babyId,
            date: date,
            time: time,
            diaperType: diaperType,
            notes: notes
        )
        
        let dailyLog = DailyLog(
            id: diaperLog.id,
            babyId: babyId,
            date: date,
            time: time,
            logType: "diaper",
            notes: notes
        )
        
        if dataService.saveDailyLog(dailyLog) {
            if let index = dailyLogs.firstIndex(where: {$0.id == logId}) {
                dailyLogs[index] = dailyLog
            }
        } else {
            errorMessage = "Failed to update diaper log"
        }
    }
    
    // MARK: - General Log Methods
    
    func deleteDailyLog(logId: UUID) {
        if dataService.deleteDailyLog(babyId: babyId, logId: logId) {
            dailyLogs.removeAll {$0.id == logId}
        } else {
            errorMessage = "Failed to delete log"
        }
    }
    
    // Helpers to get logs for specific types
    func getFeedingLogs() -> [DailyLog] {
        return dailyLogs.filter {$0.logType == "feeding"}
    }
    
    func getSleepLogs() -> [DailyLog] {
        return dailyLogs.filter {$0.logType == "sleep"}
    }
    
    func getDiaperLogs() -> [DailyLog] {
        return dailyLogs.filter {$0.logType == "diaper"}
    }
}
