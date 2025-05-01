//
//  FeedingLog.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct FeedingLog: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var date: Date
    var time: Date
    var feedingType: FeedingType
    var amount: Double?
    var duration: Int?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        babyId: UUID,
        date: Date,
        time: Date,
        feedingType: FeedingType,
        amount: Double? = nil,
        duration: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.time = time
        self.feedingType = feedingType
        self.amount = amount
        self.duration = duration
        self.notes = notes
    }
    
    // Internal computed property to be consistent with Daily Log
    var logType: String {
        return "feeding"
    }
    
    var amountString: String? {
        guard let amount = amount else {return nil}
        let unit = feedingType.amountUnit
        return "\(String(format: "%.0f", amount)) \(unit)"
    }
    
    var durationString: String? {
        guard let duration = duration else {return nil}
        return "\(duration) min"
    }
}

// Helper extension to convert to/from DailyLog
extension FeedingLog {
    init?(from dailyLog: DailyLog, feedingType: FeedingType, amount: Double?, duration: Int?) {
        guard dailyLog.logType == "feeding" else {
            return nil
        }
        
        self.id = dailyLog.id
        self.babyId = dailyLog.babyId
        self.date = dailyLog.date
        self.time = dailyLog.time
        self.feedingType = feedingType
        self.amount = amount
        self.duration = duration
        self.notes = dailyLog.notes
    }
    
    func toDailyLog() -> DailyLog {
        return DailyLog(
            id: id,
            babyId: babyId,
            date: date,
            time: time,
            logType: "feeding",
            notes: notes
        )
    }
}
