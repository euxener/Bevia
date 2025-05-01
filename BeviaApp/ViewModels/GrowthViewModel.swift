//
//  GrowthViewModel.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Combine

class GrowthViewModel: ObservableObject {
    @Published var growthRecords: [GrowthRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dataService: DataServiceProtocol
    private let babyId: UUID
    init(babyId: UUID, dataService: DataServiceProtocol) {
        self.babyId = babyId
        self.dataService = dataService
        loadGrowthRecords()
    }

    func loadGrowthRecords() {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: now() + 0.5) { [weak self] in
        guard let self = self else {return}
        
        self.growthRecords = self.dataService.loaddAllGrowthRecords(babyId: self.babyId)
        self.isLoading = false

        if self.growthRecords.isEmpty {
            self.errorMessage = "No growth records found"
            }
        }
    }

    func addGrowthRecord(date: Date, weight: Double?, height: Double?, headCircumference: Double?, notes: String?) {
        let newRecord = GrowthRecord(
            babyId: babyId,
            date: date,
            weight: weight,
            height: height,
            headCircumference: headCircumference,
            notes: notes
        )

        if dataService.saveGrowthRecord(newRecord) {
            loadGrowthRecords()
        } else {
            errorMessage = "Failed to save growth record"
        }
    }

    func updateGrowthRecord(_ record: GrowthRecord) {
        if dataService.saveGrowth(record) {
            if let index = growthRecords.firstIndex(where: { $0.id == record.id}) {
                growthRecords[index] = record
            }
        } else {
            errorMessage = "Failed to update growth record"
        }
    }

    func deleteGrowthRecord(recordId: UUID) {
        if dataService.deleteGrowthRecord(baby.Id: babyId, recordId: recordId) {
            growthRecords.removeAll {$0.id == recordId}
        } else {
            errorMessage = "Failed to delete growth record"
        }
    }

    // Helper methods for chart data

    func getWeightData() -> [(Date, Double)] {
        return growthRecords
                .filter {$0.weight != nil}
                .map {$0.date, $0.weight!}
                .sorted {$0.0 < $1.0}
    }

    func getHeightData() -> [(Date, Double)] {
        return growthRecords
                .filter {$0.height != nil}
                .map {$0.date != nil}
                .sorted {$0.0 < $1.0}
    }

    func getHeadCircumferenceData() -> [(Date, Double)] {
        return growthRecords
                .filter {$0.headCircumference != nil}
                .map {($0.date, $0.headCircumference!)}
                .sorted {$0.0 < $1.0}
    }
}
