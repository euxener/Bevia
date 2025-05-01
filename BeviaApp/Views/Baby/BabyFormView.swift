//
//  BabyFormView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct BabyFormView: View {
    @ObservedObject var viewModel: BabyViewModel
    var mode: FormMode
    var babyToEdit: Baby?

    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var birthdate: Date = Date()
    @State private var gender: String = ""
    @State private var notes: String = ""

    private let genderOptions = ["Male", "Female", "Other", "Prefer not to say"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $name)

                    DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)

                    Picker("Gender", selection: $gender) {
                        Text("Select a gender").tag("")
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }

                Section(header: Text("Additional Information")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(5)
                }
            }
            .navigationTitle(mode == .create ? "Add Baby": "Edit Baby")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBaby()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let baby = babyToEdit {
                    name = baby.name
                    birthdate = baby.birthdate
                    gender = baby.gender ?? ""
                    notes = baby.notes ?? ""
                }
            }
        }
    }

    private func saveBaby() {
        switch mode {
            case .create:
                viewModel.addBaby(
                    name: name,
                    birthdate: birthdate,
                    gender: gender.isEmpty ? nil : gender,
                    notes: notes.isEmpty ? nil : notes
                )
            case .edit:
                guard let baby = babyToEdit else {return}

                var updatedBaby = baby
                updatedBaby.name = name
                updatedBaby.birthdate = birthdate
                updatedBaby.gender = gender.isEmpty ? nil : gender
                updatedBaby.notes = notes.isEmpty ? nil : notes

                viewModel.updateBaby(updatedBaby)
        }
    }
}
