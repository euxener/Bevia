//
//  ChartHelpers.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Charts

// Struct to represent chart data points
struct GrowthDataPoint: Identifiable {
    var id = UUID()
    var date: Date
    var value: Double
    var type: String
}

// Helper functions for growths charts
enum ChartHelpers {
    // WHO Growth Standards: https://www.who.int/childgrowth/standards/en/
    // These are simplified percentile values for demonstration
    // In a real app, you would use more comprehensive data

    // Weight-for-age percentiles (boys, 0-24 months, simplified)
    static let weightPercentilesBoys: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 2.9), (3, 5.7), (6, 7.3), (9, 8.4), (12, 9.2), (18, 10.4), (24, 11.5)],
        "p50": [(0, 3.3), (3, 6.4), (6, 8.0), (9, 9.2), (12, 10.0), (18, 11.5), (24, 12.7)],
        "p97": [(0, 4.3), (3, 7.5), (6, 9.5), (9, 10.7), (12, 11.7), (18, 13.3), (24, 14.8)]
    ]

    // Weight-for-age percentiles (girls, 0-24 months, simplified)
    static let weightPercentilesGirls: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 2.8), (3, 5.1), (6, 6.7), (9, 7.7), (12, 8.4), (18, 9.5), (24, 10.5)],
        "p50": [(0, 3.2), (3, 5.8), (6, 7.3), (9, 8.5), (12, 9.2), (18, 10.5), (24, 11.8)],
        "p97": [(0, 4.2), (3, 6.9), (6, 8.7), (9, 10.0), (12, 11.0), (18, 12.5), (24, 13.9)]
    ]

    // Height-for-age percentiles (boys, 0-24 months, simplified)
    static let heightPercentilesBoys: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 46.3), (3, 59.4), (6, 65.0), (9, 69.2), (12, 72.7), (18, 78.4), (24, 83.2)],
        "p50": [(0, 49.9), (3, 62.1), (6, 67.6), (9, 72.0), (12, 75.7), (18, 82.3), (24, 87.1)],
        "p97": [(0, 53.4), (3, 64.8), (6, 70.3), (9, 74.8), (12, 78.8), (18, 86.1), (24, 91.1)]
    ]

    // Height-for-age percentiles (girls, 0-24 months, simplified)
    static let heightPercentilesBoys: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 45.6), (3, 57.4), (6, 63.2), (9, 67.7), (12, 71.3), (18, 77.2), (24, 82.0)],
        "p50": [(0, 49.1), (3, 60.2), (6, 65.7), (9, 70.4), (12, 74.3), (18, 80.7), (24, 86.0)],
        "p97": [(0, 52.7), (3, 63.0), (6, 68.3), (9, 73.2), (12, 77.4), (18, 84.2), (24, 90.0)]
    ]

    static let headPercentilesBoys: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 32.4), (3, 39.2), (6, 42.3), (9, 44.2), (12, 45.5), (18, 47.1), (24, 48.1)],
        "p50": [(0, 34.5), (3, 40.8), (6, 43.8), (9, 45.6), (12, 46.9), (18, 48.4), (24, 49.3)],
        "p97": [(0, 36.6), (3, 42.3), (6, 45.2), (9, 47.0), (12, 48.2), (18, 49.7), (24, 50.5)]
    ]

    static let headPercentilesGirls: [String: [(age: Int, value: Double)]] = [
        "p3": [(0, 31.9), (3, 38.1), (6, 41.1), (9, 43.0), (12, 44.2), (18, 45.7), (24, 46.6)],
        "p50": [(0, 33.9), (3, 39.5), (6, 42.4), (9, 44.2), (12, 45.3), (18, 46.8), (24, 47.8)],
        "p97": [(0, 35.8), (3, 41.0), (6, 43.7), (9, 45.3), (12, 46.5), (18, 48.0), (24, 49.0)]
    ]

// Get percentile data for a specific measurement, age range and gender

static func getPercentileData(type: String, gender: String, ageRangeMonths: ClosedRange<Int>) -> [String: [GrowthDataPoint]] {
    var percentileDict: [String: [(age: Int, value: Double)]]

    // Select the appropriate percentile data
    switch (type, gender.lowercased()) {
        case ("weight", "male"):
            percentileDict = weightPercentilesBoys
        case ("weight", "female"):
            percentileDict = weightPercentileGirls
        case ("height", "male"):
            percentileDict = heightPercentilesBoys
        case ("height", "female"):
            percentileDict = heightPercentileGirls
        case ("head", "male"):
            percentileDict = headPercentilesBoys
        case ("head", "female"):
            percentileDict = headPercentileGirls
        default:
            return [:]
    }

    // Convert to GrowthDataPoint format
    var result: [String: [GrowthDataPoint]] = [:]

    for (percentile, data) in percentileDict {
        var dataPoints: [GrowthDataPoint] = []

        for point in data {
            if ageRangeMonths.contains(point.age) {
                let date = Calendar.current.date(byAdding: .month, value: point.age, to: Date()) ?? Date()
                dataPoints.append(GrowthDataPoint(date: date, value: point.value, type: percentile))
            }
        }

        result[percentile] = dataPoints
    }

    return result
}

// Calculate percentile for a given measurement
static func calculatePercentile(value: Double, age: Int, type: String, gender: String) -> Int {
    var percentileDict: [String: [(age: Int, value: Double)]]

    // Select the appropriate percentile data
    switch (type, gender.lowercased()) {
    case ("weight", "male"):
        percentileDict = weightPercentilesBoys
    case ("weight", "female"):
        percentileDict = weightPercentilesGirls
    case ("height", "male"):
        percentileDict = heightPercentilesBoys
    case ("height", "female"):
        percentileDict = heightPercentilesGirls
    case ("head", "male"):
        percentileDict = headPercentilesBoys
    case ("head", "female"):
        percentileDict = headPercentilesGirls
    default:
        return 50 // Default to 50th percentile if no matching data
    }

    // Simplistic percentile calculation - for demostration purposes
    // In a real app, you should use proper statitical methods

    // Find closest age points

    var lowerAge = 0
    var upperAge = 24

    for a in percentileDict["p50"]!.map({$0.age}) {
        if a <= age && a > lowerAge {
            lowerAge = a
        }
        if a >= age && a < upperAge {
            upperAge = a
        }
    }

    // Get values for 3rd, 50th, and 97th percentiles at this age
    let p3 = interpolateValue(age: age, lowerAge: lowerAge, upperAge: upperAge, percentileData: percentileDict["p3"]!)
    let p50 = interpolateValue(age: age, lowerAge: lowerAge, upperAge: upperAge, percentileData: percentileDict["p50"]!)
    let p97 = interpolateValue(age: age, lowerAge: lowerAge, upperAge: upperAge, percentileData: percentileDict["p97"]!)

    // Simple estimation based on the position between percentiles
    if value <= p3 {
        return 3
    } else if value >= p97 {
        return 97
    } else {
        let range = p97 - p3
        let position = (value - p3) / range
        return Int(position * 94) + 3 // Scale to 3-97 range
    }
}

// Helper to interpolate values between age points
    private static func interpolateValue(age: Int, lowerAge: Int, upperAge: Int, percentileData: [(age: Int, value: Double)]) -> Double {

        // Get values at lower and upper ages
        guard let lowerPoint = percentileData.first(where: {$0.age == lowerAge}),
            let upperPoint = percentileData.first(where: {$0.age == upperAge}) else {
            return 0
        }

        // If ages are the same, just return the value
        if lowerAge == upperAge {
            return lowerPoint.value
        }

        // Linear interpolation
        let ageDiff = upperAge - lowerAge
        let valueDiff = upperPoint.value - lowerPoint.value
        let ratio = Double(age - lowerAge) / Double(ageDiff)

        return lowerPoint.value + (valueDiff * ratio)
    }
}