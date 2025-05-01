//
//  DataServiceProtocol.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

protocol DataServiceProtocol {
    // Baby operations
    func saveBaby(_ baby: Baby) -> Bool
    func loadBaby(withID id: UUID) -> Baby?
    func loadAllBabies() ->[Baby]
    func deleteBaby(withID id: UUID) -> Bool

    // Growth record operations
    func saveGrowthRecord(_ record: GrowthRecord) -> Bool
    func loadGrowthRecord(babyId: UUID, recordId: UUID) -> GrowthRecord?
    func loadAllGrowthRecords(babyId: UUID) -> [GrowthRecord]
    func deleteGrowthRecord(babyId: UUID, recordId: UUID) -> Bool
}
