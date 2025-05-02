//
//  MilestoneViewModel.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Combine

class MilestoneViewModel: ObservableObject {
    @Published var milestones: [Milestone] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let dataService: DataServiceProtocol
    private let babyId: UUID
    private let standardMilestones: [MilestoneCategory: [StandardMilestone]]
    
    init(
        babyId: UUID,
        dataService: DataServiceProtocol
    ) {
        self.babyId = babyId
        self.dataService = dataService
        self.standardMilestones = MilestoneViewModel.createStandardMilestones()
        loadMilestones()
    }
    
    func loadMilestones() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else {return}
        
            self.milestones = self.dataService.loadAllMilestones(babyId: self.babyId)
            self.isLoading = false
            
            if self.milestones.isEmpty {
                self.errorMessage = "No milestones found"
            }
        }
    }
    
    func addMilestone(name: String, category: MilestoneCategory, achievedData: Date?, expectedAgeRange: ClosedRange<Int>?, notes: String?) {
        let newMilestone = Milestone(
            babyId: babyId,
            name: name,
            category: category,
            achievedDate: achievedData,
            expectedAgeRange: expectedAgeRange,
            notes: notes
        )
        
        if dataService.saveMilestone(newMilestone) {
            loadMilestones()
        } else {
            errorMessage = "Failed to save milestone"
        }
    }
    
    func updateMilestone(_ milestone: Milestone) {
        if dataService.saveMilestone(milestone) {
            if let index = milestones.firstIndex(where: {$0.id == milestone.id}) {
                milestones[index] = milestone
            }
        } else {
            errorMessage = "Failed to update milestone"
        }
    }
    
    func deleteMilestone(milestoneId: UUID) {
        if dataService.deleteMilestone(babyId: babyId, milestoneId: milestoneId) {
            milestones.removeAll {$0.id == milestoneId}
        } else {
            errorMessage = "Failed to delete milestone"
        }
    }
    
    func getMilestoneSuggestions(baby: Baby) -> [MilestoneCategory: [StandardMilestone]] {
        let ageInMonths = baby.ageInMonths()
        
        var suggestions: [MilestoneCategory: [StandardMilestone]] = [:]
        
        for(category, categoryMilestones) in standardMilestones {
            let relevantMilestones = categoryMilestones.filter {milestone in
                // Include milestones that baby might achieve soon (within next 3 months)
                milestone.expectedAgeRange.contains(ageInMonths) ||
                (milestone.expectedAgeRange.lowerBound > ageInMonths &&
                 milestone.expectedAgeRange.lowerBound <= ageInMonths + 3)
            }
            
            if !relevantMilestones.isEmpty {
                suggestions[category] = relevantMilestones
            }
        }
        
        return suggestions
    }
    
    // Static method to create standard milestones
    private static func createStandardMilestones() -> [MilestoneCategory: [StandardMilestone]] {
        return [
            .physical: [
                StandardMilestone(name: "Holds head up", expectedAgeRange: 1...4),
                StandardMilestone(name: "Rolls over", expectedAgeRange: 3...7),
                StandardMilestone(name: "Sits without support", expectedAgeRange: 5...8),
                StandardMilestone(name: "Crawls", expectedAgeRange: 6...10),
                StandardMilestone(name: "Pulls to stand", expectedAgeRange: 8...12),
                StandardMilestone(name: "Walks alone", expectedAgeRange: 9...18),
                StandardMilestone(name: "Climbs stairs", expectedAgeRange: 12...18),
                StandardMilestone(name: "Kicks a ball", expectedAgeRange: 18...24),
            ],
            .social: [
                StandardMilestone(name: "Smiles", expectedAgeRange: 1...3),
                StandardMilestone(name: "Laughs", expectedAgeRange: 3...6),
                StandardMilestone(name: "Recognizes familiar people", expectedAgeRange: 3...6),
                StandardMilestone(name: "Stranger anxiety", expectedAgeRange: 6...12),
                StandardMilestone(name: "Plays peek-a-boo", expectedAgeRange: 6...12),
                StandardMilestone(name: "Waves bye-bye", expectedAgeRange: 8...12),
                StandardMilestone(name: "Plays with others", expectedAgeRange: 12...24),
                StandardMilestone(name: "Shows empathy", expectedAgeRange: 18...36),
            ],
            .language: [
                StandardMilestone(name: "Coos", expectedAgeRange: 1...4),
                StandardMilestone(name: "Babbles", expectedAgeRange: 4...8),
                StandardMilestone(name: "Says first word", expectedAgeRange: 8...14),
                StandardMilestone(name: "Says 2-3 words", expectedAgeRange: 12...18),
                StandardMilestone(name: "Points to objects", expectedAgeRange: 12...18),
                StandardMilestone(name: "Follows simple instructions", expectedAgeRange: 12...24),
                StandardMilestone(name: "Speaks in 2-word phrases", expectedAgeRange: 18...24),
                StandardMilestone(name: "Uses 3-word sentences", expectedAgeRange: 24...36),
            ],
            .cognitive: [
                StandardMilestone(name: "Follows moving objects", expectedAgeRange: 1...3),
                StandardMilestone(name: "Recognizes familiar objects", expectedAgeRange: 3...6),
                StandardMilestone(name: "Finds hidden objects", expectedAgeRange: 6...12),
                StandardMilestone(name: "Explores objects", expectedAgeRange: 6...12),
                StandardMilestone(name: "Scribbles", expectedAgeRange: 12...18),
                StandardMilestone(name: "Sorts shapes", expectedAgeRange: 18...24),
                StandardMilestone(name: "Follows 2-step commands", expectedAgeRange: 18...24),
                StandardMilestone(name: "Engages in pretend play", expectedAgeRange: 24...36),
            ]
        ]
    }
}

// Helper struct for standard milestone templates
struct StandardMilestone {
    var name: String
    var expectedAgeRange: ClosedRange<Int>
    
    func toMilestone(babyId: UUID) -> Milestone {
        return Milestone(
            babyId: babyId,
            name: name,
            category: .physical, // This would need to be set correctly
            achievedDate: nil,
            expectedAgeRange: expectedAgeRange,
            notes: nil
        )
    }
}
