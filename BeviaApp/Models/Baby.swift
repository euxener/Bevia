//
//  Baby.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

struct Baby: Identifiable, Codable {
    var id: UUID
    var name: String
    var birthdate: Date
    var gender: String?
    var notes: String?

    init(id: UUID = UUID(), name: String, birthdate: Date,
        gender: String? = nil, notes: String? = nil) {
            self.id = id
            self.name = name
            self.birthdate = birthdate
            self.gender = gender
            self.notes = notes
    }

    func calculateAge(asOf date: Date = Date()) -> (years: Int,
                                                    months: Int, days: Int)
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day],
                                                                    from: birthdate, to: date)
        return (
            years: components.year ?? 0,
            months: components.month ?? 0,
            days: components.day ?? 0
        )
    }

    func ageInMonths(as date: Date = Date()) -> Int {
        let age = calculateAge(asOf: date)
        return age.years * 12 + age.months
    }
}
