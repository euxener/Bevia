//
//  BabyDetailViewModel.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Combine

class BabyDetailViewModel: ObservableObject {
    @Published var baby: Baby?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dataService: DataServiceProtocol

    init(babyID: UUID, dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadBaby(withID: babyID)
    }

    func loadBaby(withID id: UUID) {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        guard let self = self else {return}
        
        self.baby = self.dataService.loadBaby(withID: id)
        self.isLoading = false
        
        if self.baby == nil {
            self.errorMessage = "Failed to load baby information."
        }
        }
    }

    func updateBaby(name: String, birthdate: Date, gender: String?, notes:String?) {
        guard var updatedBaby = baby else {return}

        updatedBaby.name = name
        updatedBaby.birthdate = birthdate
        updateBaby.gender = gender
        updatedBaby.notes = notes

        if dataService.saveBaby(updatedBaby) {
            self.baby = updatedBaby
        } else {
            errorMessage = "Failed to update baby. Please try again."
        }
    }
}
