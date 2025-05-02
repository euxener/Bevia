//
//  Milestone.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct Milestone: Identifiable, Codable {
    var id: UUID
    var babyId: UUID
    var name: String
    var category: MilestoneCategory
    var achievedDate: Date?
    var expectedAgeRange: ClosedRange<Int>? // Range in months
    var notes: String?
    
    init(
        id: UUID = UUID(),
        babyId: UUID,
        name: String,
        category: MilestoneCategory,
        achievedDate: Date? = nil,
        expectedAgeRange: ClosedRange<Int>? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.name = name
        self.category = category
        self.achievedDate = achievedDate
        self.expectedAgeRange = expectedAgeRange
        self.notes = notes
    }
    
    var isAchieved: Bool {
        return achievedDate != nil
    }
    
    func isOnTime(birthdate: Date) -> Bool? {
        guard let achievedDate = achievedDate, let expectedRange = expectedAgeRange else {
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.month],
            from: birthdate,
            to: achievedDate
        )
        guard let ageInMonths = components.month else {return nil}
        
        return expectedRange.contains(ageInMonths)
    }
    
    // Format the expected age range as a string
    var expectedRangeString: String? {
        guard let range = expectedAgeRange else {return nil}
        
        if range.lowerBound == range.upperBound {
            return "\(range.lowerBound) months"
        } else {
            return "\(range.lowerBound)-\(range.upperBound) months"
        }
    }
}

// Helper for file operations
extension Milestone {
    static func getFilename(for id: UUID) -> String {
        return "milestone_\(id.uuidString).json"
    }
}
