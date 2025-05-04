//
//  MilestoneListView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct MilestoneListView: View {
    @ObservedObject var viewModel: MilestoneViewModel
    @State private var showingAddMilestone = false
    @State private var showingSuggestions = false
    @State private var selectedMilestone: Milestone? = nil
    
    let baby: Baby
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if viewModel.milestones.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 72))
                        .foregroundColor(.yellow)
                    
                    Text("No milestones yet")
                        .font(.title)
                    
                    Text("Track your baby's development milestones")
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingAddMilestone = true
                        }) {
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                Text("Add Manually")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                padding()
            } else {
                List {
                    ForEach(MilestoneCategory.allCases, id: \.self) {
                        category in
                        let categoryMilestones = viewModel.milestones.filter {$0.category == category}
                        
                        if !categoryMilestones.isEmpty {
                            Section(header: Text(category.displayName)) {
                                ForEach(categoryMilestones) {milestone in
                                    MilestoneRow(milestone: milestone, baby: baby)
                                        .onTapGesture {
                                            selectedMilestone = milestone
                                        }
                                }
                                .onDelete {
                                    indexSet in deleteMilestones(
                                        category: category,
                                        at: indexSet
                                    )
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.loadMilestones()
                }
            }
        }
        .navigationTitle("Milestones")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        showingSuggestions = true
                    }) {
                        Image(systemName: "lightbulb.fill")
                    }
                    
                    Button(action: {
                        showingAddMilestone = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddMilestone) {
            MilestoneFormView(viewModel: viewModel, mode: .create, baby: baby)
        }
        .sheet(isPresented: $showingSuggestions) {
            MilestoneSuggestionsView(viewModel: viewModel, baby: baby)
        }
        .sheet(item: $selectedMilestone) { milestone in
            MilestoneFormView(
                viewModel: viewModel,
                mode: .edit,
                baby: baby,
                milestoneToEdit: milestone
            )
        }
    }
    
    private func deleteMilestones(category: MilestoneCategory, at offsets: IndexSet) {
        let categoryMilestones = viewModel.milestones.filter {
            $0.category == category
        }
        
        for index in offsets {
            viewModel.deleteMilestone(milestoneId: categoryMilestones[index].id)
        }
    }
}

struct MilestoneRow: View {
    let milestone: Milestone
    let baby: Baby
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.name)
                    .font(.headline)
                
                if let range = milestone.expectedRangeString {
                    Text("Expected: \(range)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let notes = milestone.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: milestone.status.systemImage)
                    .foregroundColor(milestone.isAchieved ? .green : .gray)
                
                if let achievedDate = milestone.achievedDate {
                    Text(achievedDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let achievedDate = milestone.achievedDate, let onTime = milestone.isOnTime(
                    birthdate: baby.birthdate
                ) {
                    HStack(spacing: 2) {
                        Image(systemName: onTime ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.caption)
                        Text(onTime ? "On time" : "Off track")
                            .font(.caption)
                    }
                    .foregroundColor(onTime ? .green : .orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct MilestoneSuggestionsView: View {
    @ObservedObject var viewModel: MilestoneViewModel
    let baby: Baby
    
    @Environment(\.presentationMode) var presentationMode
    
    var suggestions: [MilestoneCategory: [StandardMilestone]] {
        viewModel.getMilestoneSuggestions(baby: baby)
    }
    
    var body: some View {
        NavigationView {
            List {
                if suggestions.isEmpty {
                    ContentUnavailableView(
                        "No Suggestions",
                        systemImage: "lightbulb.slash",
                        description: Text("There are no milestone suggestions for your baby's current age")
                    )
                } else {
                    ForEach(Array(suggestions.keys), id: \.self) {category in
                        if let categorySuggestions = suggestions[category], !categorySuggestions.isEmpty {
                            Section(header: Text(category.displayName)) {
                                ForEach(categorySuggestions, id: \.name) { suggestion in
                                    SuggestionRow(
                                        suggestion: suggestion,
                                        category: category
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        addMilestone(
                                            suggestion: suggestion,
                                            category: category
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Milestone Suggestions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func addMilestone(suggestion: StandardMilestone, category: MilestoneCategory) {
        viewModel
            .addMilestone(
                name: suggestion.name,
                category: category,
                achievedData: nil,
                expectedAgeRange: suggestion.expectedAgeRange,
                notes: nil
            )
        presentationMode.wrappedValue.dismiss()
    }
}

struct SuggestionRow: View {
    let suggestion: StandardMilestone
    let category: MilestoneCategory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion.name)
                    .font(.headline)
                
                Text(
                    "Expected: \(suggestion.expectedAgeRange.lowerBound) - \(suggestion.expectedAgeRange.upperBound) months"
                )
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "plus.circle")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}
