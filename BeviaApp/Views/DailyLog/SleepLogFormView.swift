//
//  SleepLogFormView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct SleepLogFormView: View {
    @ObservedObject var viewModel: DailyLogViewModel
    var mode: FormMode
    var baby: Baby
    var logToEdit: SleepLog?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var date: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600) // Default 1 hour later
    @State private var isOngoing: Bool = false
    @State private var quality: SleepQuality?
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker(
                        "Start Time",
                        selection: $startTime,
                        displayedComponents: .hourAndMinute
                    )
                    Toggle("Still Sleeping", isOn: $isOngoing)
                    
                    if !isOngoing {
                        DatePicker(
                            "End Time",
                            selection: $endTime,
                            displayedComponents: .hourAndMinute
                        )
                        // FIXME: Substitute onChange due to deprecation in iOS 17
                        .onChange(of: endTime) { newValue in
                            if newValue < startTime {
                                // If end time is before start time, adjust it to be equal to start time
                                endTime = startTime
                            }
                        }
                    }
                }
                
                Section(header: Text("Quality")) {
                    Picker("Sleep Quality", selection: $quality) {
                        Text("Sleep Quality").tag(nil as SleepQuality?)
                        ForEach(SleepQuality.allCases, id: \.self) {quality in
                            Text(quality.displayName)
                                .tag(quality as SleepQuality?)
                        }
                    }
                }
                
                if !isOngoing {
                    Section(header: Text("Duration")) {
                        Text(calculateDuration())
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(5)
                }
            }
            .navigationTitle(mode == .create ? "Add Sleep" : "Edit Sleep")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSleepLog()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if let log = logToEdit {
                    date = log.date
                    startTime = log.startTime
                    
                    if let logEndTime = log.endTime {
                        endTime = logEndTime
                        isOngoing = false
                    } else {
                        isOngoing = true
                    }
                    
                    quality = log.quality
                    notes = log.notes ?? ""
                }
            }
        }
    }
    
    private func calculateDuration() -> String {
        let duration = endTime.timeIntervalSince(startTime)
        let minutes = Int(duration / 60)
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") \(remainingMinutes) minute\(remainingMinutes == 1 ? "" : "s")"
        } else {
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        }
    }
    
    private func saveSleepLog() {
        switch mode {
        case .create:
            viewModel.addSleepLog(
                date: date,
                startTime: startTime,
                endTime: isOngoing ? nil : endTime,
                quality: quality,
                notes: notes.isEmpty ? nil : notes
            )
        case .edit:
            guard let log = logToEdit else {return}
            
            viewModel.updateSleepLog(
                logId: log.id,
                date: date,
                startTime: startTime,
                endTime: isOngoing ? nil : endTime,
                quality: quality,
                notes: notes.isEmpty ? nil : notes
            )
        }
    }
}
