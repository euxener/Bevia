//
//  MilestoneCategory.swift
//  Bevia
//
//  Created by Eugenio Herrera on 01/05/25.
//
import Foundation

enum MilestoneCategory: String, Codable, CaseIterable {
    case physical = "physical"
    case social = "social"
    case language = "language"
    case cognitive = "cognitive"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .physical:
            return "Physical"
        case .social:
            return "Social"
        case .language:
            return "Language"
        case .cognitive:
            return "Cognitive"
        case .other:
            return "Other"
        }
    }
    
    var systemImage: String {
        switch self {
        case .physical:
            return "figure.walk"
        case .social:
            return "person.2.fill"
        case .language:
            return "text.bubble.fill"
        case .cognitive:
            return "brain"
        case .other:
            return "star.fill"
        }
    }
}
