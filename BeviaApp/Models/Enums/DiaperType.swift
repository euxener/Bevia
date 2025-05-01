//
//  DiaperType.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

enum DiaperType: String, Codable, CaseIterable {
    case wet = "wet"
    case soiled = "soiled"
    case both = "both"
    
    var displayName: String {
        switch self {
        case .wet:
            return "Wet"
        case .soiled:
            return "Soiled (BM)"
        case .both:
            return "Both (Wet and BM)"
        }
    }
    
    var systemImage: String {
        switch self {
        case .wet:
            return "drop.fill"
        case .soiled:
            return "trash.fill"
        case .both:
            return "allergens"
        }
    }
    
    var color: String {
        switch self {
        case .wet:
            return "blue"
        case .soiled:
            return "brown"
        case .both:
            return "purple"
        }
    }
}
