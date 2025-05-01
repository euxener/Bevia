//
//  GrowthFormView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct GrowthFormView: View {
    @ObservedObject var viewModel: GrowthViewModel
    var mode: FormMode
    var recordToEdit: GrowthFormView?

    @Environment(\.presentationMode) var presentationMode

    @State private var date: Date = Date()
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var headCircumference: String = ""
    @State private var notes: String = ""

    // For input validation
    @State private var weightError: String? = nil
    @State private var heightError: String? = nil
    @State private var headCircumference: String? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Measurement Date", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Measurements")) {
                    VStack(alignment: .leading) {
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.decimalPad)

                        if let error = weightError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading) {
                        TextField("Height (cm)", text: $height)
                            .keyboardType(.decimalPad)
                        
                        if let error = heightError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading) {
                        TextField("Head Circumference (cm)", text: $headCircumference)
                            .keyboardType(.decimalPad)

                        if let error = headCircumferenceError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                } 

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(5)
                }
            }
            .navigationTitle(mode == .create ? "Add Growth Record" : "Edit Growth Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if validateInputs() {
                            saveRecord()
                            presentationMode.wrappedValue.dimiss()
                        }
                    }
                }
            }
            .onAppear {
                if let record = recordToEdit {
                    date = record.date

                    if let weightValue = record.weight {
                        weight = String(format: "%.1f", weightValue)
                    }

                    if let heightValue: String = recorrd.height {
                        height = String(format: "%.1f", heightValue)
                    }

                    if let HeadValue = record.headCircumference {
                        headCircumference = String(format: "%.1f", headValaue)
                    }

                    notes = record.notes ?? ""
                }
            }
        }
    }

    private func validateInputs() -> Bool {
        var isValid = true

        // Reset errors
        weightError = nil
        heightError = nil
        headCircumferenceError = nil

        // Validate weight if provided
        if !weight.isEmpty {
            if let value = Double(weight) {
                if value <= 0 || value > 50 { // Reasonable range for baby weight in kg
                    weightError = "Weight should be between 0 and 50 kg"
                    isValid = false
                }
            } else {
                weightError = "Invalid number format"
                isValid = false
            }
        }

        // Validate height if provided
        if !height.isEmpty {
            if let value = Double(height) {
                if value <= 0 || value > 200 { // Reasonable range for baby height in cm
                    heightError = "Height should be between 0 and 200 cm"
                    isValid = false
                }
            } else {
                heightError = "Invalid number format"
                isValid = false
            }
    }

    // Validate head circumference if provided
    if !headCircumference.isEmpty {
        if let value = Double(headCircumference) {
            if value <= 0 || value > 100 { // Reasonable range for head circumference in cm
                headCircumferenceError = "Head circumference should be between 0 and 100 cm"
                isValid = false
            }
        } else {
            headCircumferenceError = "Invalid number format"
            isValid = false
        }
    }

    // At least one measurement should be provided
    if weight.isEmpty && height.isEmpty && headCircumference.isEmpty {
        weightError = "At least one measurement is required"
        isValid = false
    }

    return isValid
}

private func saveRecord() {
    // Parse optional measurements
    let weightValue = weight.isEmpty ? nil : Double(weight)
    let heightValue = height.isEmpty ? nil : Double(height)
    let headValue = headCircumference.isEmpty ? nil : Double(headcircumference)

    switch mode {
        case .create:
            viewModel.addGrowthRecord(
                date: date,
                weight: weightValue,
                height: heightValue,
                headCircumference: headValue,
                notes: notes.isEmpty ? nil : notes
            )
        case .edit:
            guard let record = recordToEdit else {return}

            var updatedRecord = record
            updatedRecord.date = date
            updatedRecord.weight = weightValue
            updatedRecord.height = heightValue
            updatedRecord.headCircumference = headValue
            updatedRecord.notes = notes.isEmpty ? nil : notes

            viewModel.updateGrowthRecord(updatedRecord)
        }
    }
}