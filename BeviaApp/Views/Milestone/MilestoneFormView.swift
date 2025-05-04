//
//  MilestoneFormView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct MilestoneFormView: View {
    @ObservedObject var viewModel: MilestoneViewModel
    var mode: FormMode
    var baby: Baby
    var milestoneToEdit: Milestone?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var category: MilestoneCategory = .physical
    @State private var isAchieved: Bool = false
    @State private var achievedDate: Date = Date()
    @State private var minAge: String = ""
    @State private var maxAge: String = ""
    @State private var notes: String = ""
    
    // For input validation
    @State private var nameError: String? = nil
    @State private var ageRangeError: String? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Milestone Details")) {
                    TextField("Name", text: $name)
                        .foregroundColor(nameError != nil ? .red : .primary)
                    
                    if let error = nameError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(MilestoneCategory.allCases, id: \.self) {category in
                            Text(category.displayName).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Status")) {
                    Toggle("Achieved", isOn: $isAchieved)
                    
                    if isAchieved {
                        DatePicker(
                            "Date Achieved",
                            selection: $achievedDate,
                            displayedComponents: .date
                        )
                    }
                }
                
                Section(header: Text("Expected Age Range (months)")) {
                    HStack {
                        TextField("Min", text: $minAge)
                            .keyboardType(.numberPad)
                        Text("to")
                        TextField("Max", text: $maxAge)
                            .keyboardType(.numberPad)
                    }
                    
                    if let error = ageRangeError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle(mode == .create ? "Add Milestone" : "Edit Milestone")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if validateInputs() {
                            saveMilestone()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .onAppear {
                if let milestone = milestoneToEdit {
                    name = milestone.name
                    category = milestone.category
                    isAchieved = milestone.isAchieved
                    
                    if let date = milestone.achievedDate {
                        achievedDate = date
                    }
                    
                    if let range = milestone.expectedAgeRange {
                        minAge = "\(range.lowerBound)"
                        maxAge = "\(range.upperBound)"
                    }
                    
                    notes = milestone.notes ?? ""
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        var isValid = true
        
        // Reset errors
        nameError = nil
        ageRangeError = nil
        
        // Validate name
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameError = "Milestone name is required"
            isValid = false
        }
        
        // Validate age range if provided
        if !minAge.isEmpty || !maxAge.isEmpty {
            guard let minValue = Int(minAge), let maxValue = Int(maxAge) else {
                ageRangeError = "Please enter valid numbers"
                isValid = true
                return isValid
            }
            
            if minValue < 0 || maxValue < 0 {
                ageRangeError = "Age must be positive"
                isValid = false
            } else if minValue > maxValue {
                ageRangeError = "Minimum age must be less than or equal to maximum age"
                isValid = false
            } else if maxValue > 72 { // 6 years as an upper limit
                ageRangeError = "Maximum age should be less than 72 months"
                isValid = false
            }
        }
        
        return isValid
    }
    
    private func saveMilestone() {
        // Parse expected age range
        var expectedRange: ClosedRange<Int>? = nil
        if !minAge.isEmpty && !maxAge.isEmpty {
            if let minValue = Int(minAge), let maxValue = Int(maxAge) {
                expectedRange = minValue...maxValue
            }
        }
        
        switch mode {
        case .create:
            viewModel
                .addMilestone(
                    name: name,
                    category: category,
                    achievedData: isAchieved ? achievedDate : nil,
                    expectedAgeRange: expectedRange,
                    notes: notes.isEmpty ? nil : notes
                )
        case .edit:
            guard var milestone = milestoneToEdit else {return}
            
            milestone.name = name
            milestone.category = category
            milestone.achievedDate = isAchieved ? achievedDate : nil
            milestone.expectedAgeRange = expectedRange
            milestone.notes = notes.isEmpty ? nil : notes
            
            viewModel.updateMilestone(milestone)
        }
    }
}
