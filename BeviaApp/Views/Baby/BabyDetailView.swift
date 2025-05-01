//
//  BabyDetailView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct BabyDetailView : View {
    @ObservedObject var viewModel: BabyDetailViewModel
    @State private var showingEditSheet = false
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let baby = viewModel.baby {
                VStack {
                    // Baby info header
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)

                        Text(baby.name)
                            .font(.title)
                            .bold()

                        let age = baby.calculateAge()
                        Text(formatAge(age))
                            .foregroundColor(.secondary)

                        if let gender = baby.gender {
                            Text("Gender: \(gender)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()

                    // Tab view for different sections
                    Picker("Section", selection: $selectedTab) {
                        Text("Summary").tag(0)
                        Text("Growth").tag(1)
                        Text("Milestone").tag(2)
                        Text("Daily Logs").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    TabView(selection: $selectedTab) {
                        // Summary tab
                        VStack(alignment: .leading, spacing: 16) {
                            InfoCard(title: "Information", content: [
                                ("Birthday", baby.birthdate.formatted(date: .long, time: .omitted)),
                                ("Age", formatAge(baby.calculateAge())),
                                ("Gender", baby.gender ?? "Not specified")
                            ])

                            if let notes = baby.notes, !notes.isEmpty {
                                InfoCard(title: "Notes", content: [(nil, notes)])
                            }

                            Spacer()
                        }
                        .padding()
                        .tag(0)

                        // Growth Tab
                        Group {
                            GrowthListView(viewModel: GrowthViewModel(babyId: baby.id, dataService: viewModel.dataService))
                        }
                        .tag(1)

                        // Milestones Tab - Placeholder
                        Text("Milestones will be shown here")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(2)
                        
                        Text("Daily logs will be shown here")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingEditSheet = true
                        }) {
                            Text("Edit")
                        }
                    }
                }
                .sheet(isPresented: $showingEditSheet) {
                    BabyFormView(
                        viewModel: BabyViewModel(dataService: viewModel.dataService),
                        mode: .edit,
                        babyToEdit: baby)
                    }
                } else {
                    Text("Baby not found")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }

    private func formatAge(_ age: (years: Int, months: Int, days: Int)) -> String {
        if age.years > 0 {
            return "\(age.years) year\(age.years == 1 ? "" : "s"), \(age.months) month\(age.months == 1 ? "" : "s")"
        } else if age.months > 0 {
            return "\(age.months) month\(age.months == 1 ? "" : "s"), \(age.days) day\(age.days == 1 ? "" : "s")"
        } else {
            return "\(age.days) day\(age.days == 1 ? "" : "s")"
        }
    }
}
struct InfoCard: View {
    let title: String
    let content: [(String?, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                    .padding(.bottom, 4)

                ForEach(0..<content.count, id: \.self) { index in
                    let item = content[index]
                    
                    if let label = item.0 {
                        HStack(alignment: .top) {
                            Text("\(label):")
                                .foregroundColor(.secondary)
                                .frame(width: 80, alignment: .leading)
                            
                            Text(item.1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        Text(item.1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
