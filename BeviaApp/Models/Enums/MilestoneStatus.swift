//
//  MilestoneStatus.swift
//  Bevia
//
//  Created by Eugenio Herrera on 01/05/25.
//
import Foundation

enum MilestoneStatus: String, Codable {
    case achieved = "achieved"
    case notAchieved = "not_achieved"
    
    var displayname: String {
        switch self {
        case .achieved:
            return "Achieved"
        case .notAchieved:
            return "Not achieved"
        }
    }

    var systemImage: String {
        switch self {
        case .achieved:
            return "checkmark.circle.fill"
        case .notAchieved:
            return "circle"
        }
    }
    
    var color: String {
        switch self {
        case .achieved:
            return "green"
        case .notAchieved:
            return "gray"
        }
    }
}
