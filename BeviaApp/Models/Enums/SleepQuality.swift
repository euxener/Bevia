//
//  SleepQuality.swift
//  Bevia
//
//  Created by Eugenio Herrera on 01/05/25.
//
import Foundation

enum SleepQuality: String, Codable, CaseIterable {
    case good = "good"
    case fair = "fair"
    case poor = "poor"
    
    var displayName: String {
        switch self {
        case .good:
            return "Good"
        case .fair:
            return "Fair"
        case .poor:
            return "Poor"
        }
    }
    
    var systemImage: String {
        switch self {
        case .good:
            return "star.fill"
        case .fair:
            return "star.leadinghalf.filled"
        case .poor:
            return "star"
        }
    }
    
    var color: String {
        switch self {
        case .good:
            return "green"
        case .fair:
            return "yellow"
        case .poor:
            return "red"
        }
    }
}
