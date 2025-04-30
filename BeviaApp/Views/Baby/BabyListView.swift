//
//  BabyListView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI

struct BabyListView: View {
    @ObservedObject var viewModel: BabyViewModel
    @State private var showingAddBaby = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if viewModel.babies.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 72))
                        .foregroundColor(.blue)

                        Text("No babies added yet")
                        .font(.title)

                        Text("Tap the + button to add your baby")
                        .foregroundColor(.secondary)

                        Button(action: {
                            showingAddBaby = true
                        }) {
                            Text("Add Baby")
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
                        ForEach(viewModel.babies) { baby in
                            NavigationLink(destination: BabyDetailView(viewModel: BabyDetailViewModel(babyID: baby.id, dataService: viewModel.dataService))) {
                                BabyRowView(baby: baby)
                            }
                            }
                            .onDelete(perform: deleteBabies)
                    }
                }
            }
            .navigationTitle("Baby Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBaby = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBaby) {
                BabyFormView(viewModel: viewModel, mode: .create)
            }
            .refreshable {
                viewModel.loadBabies()
            }
        }
    }

    private func deleteBabies(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteBaby(withID: viewModel.babies[index].id)
        }
    }
}

struct BabyRowView: View {
    let baby: Baby

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(baby.name)
            .font(.headline)

            let age = baby.calculateAge()

            Text(formatAge(age))
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func formatAge(_ age: (years: Int, months: Int, days: Int)) -> String {
        if age.years > 0 {
            return "\(age.years) year\(age.years == 1 ? "" : "s"), \(age.months) month\(age.months == 1 ? "" : "s")"
        } else if age.months > 0 {
            return "\(age.months) month\(age.months == 1 ? "": "s"), \(age.days) day\(age.days == 1 ? "" : "s")"
        } else {
            return "\(age.days) day\(age.days == 1 ? "" : "s")"
        }
    }
}
