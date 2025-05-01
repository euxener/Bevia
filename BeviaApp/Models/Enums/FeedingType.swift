//
//  FeedingType.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

enum FeedingType: String, Codable, CaseIterable {
    case breast = "breast"
    case bottle = "bottle"
    case formula = "formula"
    case solid = "solid"
    
    var displayName: String {
        switch self {
        case .breast:
            return "Breastfeeding"
        case .bottle:
            return "Bottle (Breast milk)"
        case .formula:
            return "Formula"
        case .solid:
            return "Solid food"
        }
    }
    
    var systemImage: String {
        switch self {
        case .breast:
            return "figure.2.and.child.holdinghands"
        case .bottle:
            return "baby.bottle"
        case .formula:
            return "mug.fill"
        case .solid:
            return "fork.knife"
        }
    }
    
    var requiresAmount: Bool {
        self == .bottle || self == .formula || self == .solid
    }
    
    var requiresDuration: Bool {
        self == .breast
    }
    
    var amountUnit: String {
        switch self {
        case .bottle, .formula:
            return "ml"
        case .solid:
            return "g"
        default:
            return ""
        }
    }
}
