//
//  SleepLog.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct SleepLog: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var date: Date
    var startTime: Date
    var endTime: Date?
    var quality: SleepQuality?
    var notes: String?
    
    init(id: UUID = UUID(), babyId: UUID, date: Date, startTime: Date, endTime: Date, quality: SleepQuality? = nil, notes: String? = nil) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.quality = quality
        self.notes = notes
    }
    
    // Internal computed property to be consistent with DailyLog
    var logType: String {
        return "sleep"
    }
    
    // Calculate sleep duration in minutes if endTime is available
    var duration: Int? {
        guard let endTime = endTime else {return nil}
        let minutes = Int(endTime.timeIntervalSince(startTime) / 60)
        return minutes
    }
    
    var durationString: String? {
        guard let duration = duration else {return "Ongoing"}
        
        let hours = duration / 60
        let minutes = duration % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

extension SleepLog {
    init?(from dailyLog: DailyLog, startTime: Date, endTime: Date?, quality: SleepQuality?) {
        guard dailyLog.logType == "sleep" else {
            return nil
        }
        
        self.id = dailyLog.id
        self.babyId = dailyLog.babyId
        self.date = dailyLog.date
        self.startTime = startTime
        self.endTime = endTime
        self.quality = quality
        self.notes = dailyLog.notes
    }
    
    func toDailyLog() -> DailyLog {
        return DailyLog(
            id: id,
            babyId: babyId,
            date: date,
            time: startTime,
            logType: "sleep",
            notes: notes
        )
    }
}
