//
//  BabyViewModel.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation
import Combine

class BabyViewModel: ObservableObject {
    @Published var babies: [Baby] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadBabies()
    }

    func loadBabies() {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        guard let self = self else {return}
        
        self.babies = self.dataService.loadAllBabies()
        self.isLoading = false

        if self.babies.isEmpty {
            self.errorMessage = "No babies found. Add your first baby!"
        }

        }
    }

    func addBaby(name: String, birthdate: Date, gender: String?, notes: String?) {
        let newBaby = Baby(name: name, birthdate: birthdate, gender: gender, notes: notes)

        if dataService.saveBaby(newBaby) {
            loadBabies()
        } else {
            errorMessage = "Failed to save baby. Please try again."
        }
    }
    
    func updateBaby(_ baby: Baby) {
        if dataService.saveBaby(baby) {
            if let index = babies.firstIndex(where: {$0.id == baby.id}) {
                babies[index] = baby
            }
        } else {
            errorMessage = "Failed to update baby. Please try again."
        }
    }

    func deleteBaby(withID id: UUID) {
        if dataService.deleteBaby(withID: id) {
            babies.removeAll {$0.id == id}
        } else {
            errorMessage = "Failed to delete baby. Please try again."
        }
    }
}