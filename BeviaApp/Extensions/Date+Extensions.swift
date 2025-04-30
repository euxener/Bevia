//
//  Date+Extensions.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

extension Date {
    func ageComponents(from date: Date) -> (years: Int, months: Int, days: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date, to: self)
        return (
            years: components.year ?? 0,
            months: components.month ?? 0,
            days: components.day ?? 0
        )
    }

    func formattedAge(from birthdate: Date) -> String {
        let age = self.ageComponents(from: birthdate)

        if age.years > 0 {
            return "\(age.years) year\(age.years == 1 ? "" : "s"), \(age.months) month \(age.months == 1 ? "" : "s")"
        } else if age.months > 0 {
            return "\(age.months) month\(age.months == 1 ? "" : "s"), \(age.days) day\(age.days == 1 ? "" : "s")"
        } else {
            return "\(age.days) day\(age.days == 1 ? "" : "s")"
        }
    }
}