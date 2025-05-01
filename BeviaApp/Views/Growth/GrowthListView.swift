//
//  GrowthListView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct GrowthListView: View {
    @ObservableObject var viewModel: GrowthViewModel
    @State private var showingAddRecord = false
    @State private var showingChartView = false

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if viewModel.growthRecords.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "ruler")
                        .font(.system(size: 72))
                        .foregroundColor(.blue)

                    Text("No growth records yet")
                        .font(.title)

                    Text("Tap the + button to add measurements")
                        .foregroundColor(.secondary)

                    Button(action: {
                        showingAddRecord = true
                    }) {
                        Text("Add Growth Record")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
                .padding()
            } else {
                List {
                    Section(header: HStack {
                        Text("Growth Records")
                        Spacer()
                        Button(action: {
                            showingChartView = true
                        }) {
                            Label("Chart", systemImage: "chart.line.uptrend.xyaxis")
                        }
                    }) {
                        ForEach(viewModel.growthRecords) { record in
                            GrowthRecordRow(record: record)
                        }
                        .onDelete(perform: deleteRecords)
                    }
                }
                .refreshable {
                    viewModel.loadGrowthRecords()
                }
            }
        }
        .navigationTitle("Growth Records")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddRecord = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddRecord) {
            GrowthFormView(viewModel: viewModel, mode: .create)
        }
        .sheet(isPresented: $showingChartView) {
            GrowthChartView(viewModel: viewModel)
        }
    }

    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteGrowthRecord(recordId: viewModel.growthRecords[index].id)
        }
    }
}

struct GrowthRecordRow: View {
    let record: GrowthRecord
    let dateFormatter: DataFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dateFormatter.string(from: record.date))
                .font(.headline)

            HStack {
                if let weight = record.weight {
                    Label("\(String(format: "%.1f", weight)) kg", systemImage: "scalemass")
                        .font(.subheadline)
                }

                Spacer()

                if let height = record.height {
                    Label("\(String(format: "%.1f", height)) cm", systemImage: "ruler")
                        .font(.subheadline)
                }
            }

            if let headCircumference = record.headCircumference {
                Label("Head: \(String(format: "%.1f", headCircumference)) cm", systemImage: "circle.dashed")
                    .font(.subheadline)
            }

            if let notes = record.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

