//
//  GrowthChartView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import SwiftUI
import Charts

struct GrowthChartView: View {
    @ObservedObject var viewModel: GrowthViewModel
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Picker("Measurement", selection: $selectedTab) {
                    Text("Weight").tag(0)
                    Text("Height").tag(1)
                    Text("Head").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    WeightChartView(data: viewModel.getWeightData())
                } else if selectedTab == 1 {
                    HeightChartView(data: viewModel.getHeightData())
                } else {
                    HeadCircumferenceChartView(data: viewModel.getHeadCircumferenceData())
                }

                Spacer()
            }
            .navigationTitle("Growth Charts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct WeightChartView: View {
    let data: [(Date, Double)]

    var body: some View {
        VStack {
            if data.isEmpty {
                ContentUnavailableView(
                    "No Weight Data",
                    systemImage: "scalemass",
                    description: Text("Add weight measurements to see a chart")
                )
            } else {
                Text("Weight (kg)")
                    .font(.headline)
                    .padding(.top)

                Chart {
                    ForEach(data, id: \.0) {item in
                        LineMark(
                            x: .value("Date", item.0),
                            y: .value("Weight", item.1)
                        )
                        .foregroundStyle(.blue)

                        PointMark(
                            x: .value("Date", item.0),
                            y: .value("Weight", item.1)
                        )
                        .foregroundStyle(.blue)
                    }
                }
                .frame(height: 300)
                .padding()

                // Table of values
                List {
                    ForEach(data.sorted(by: {$0.0 > $1.0}), id: \.0) {date, weight in
                    HStack {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text("\(String(format: "%.1f", weight)) kg")
                            .bold()
                        }
                    }
                }
            }
        }
    }
}

struct HeightChartView: View {
    let data: [(Date, Double)]

    var body: some View {
        VStack {
            if data.isEmpty {
                ContentUnavailableView(
                    "No Height Data",
                    systemImage: "ruler",
                    description: Text("Add height measurements to see a chart")
                )
            } else {
                Text("Height (cm)")
                    .font(.headline)
                    .padding(.top)

                Chart {
                    ForEach(data, id: \.0) {item in
                        LineMark(
                            x: .value("Date", item.0),
                            y: .value("Height", item.1)
                        )
                        .foregroundStyle(.green)

                        PointMark(
                            x: .value("Date", item.0),
                            y: .value("Height", item.1)
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 300)
                .padding()

                // Table of values
                List {
                    ForEach(data.sorted(by: {$0.0 > $1.0}), id: \.0) {date, height in
                    HStack {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text("\(String(format: "%.1f", height)) cm")
                            .bold()
                        }
                    }
                }
            }
        }
    }
}

struct HeadCircumferenceChartView: View {
    let data: [(Date, Double)]

    var body: some View {
        VStack {
            if data.isEmpty {
                ContentUnavailableView(
                    "No Head Circumference Data",
                    systemImage: "circle.dashed",
                    description: Text("Add head measurements to see a chart")
                )
            } else {
                Text("Head Circumference (cm)")
                    .font(.headline)
                    .padding(.top)

                Chart {
                    ForEach(data, id: \.0) {item in
                        LineMark(
                            x: .value("Date", item.0),
                            y: .value("Head", item.1)
                        )
                        .foregroundStyle(.orange)

                        PointMark(
                            x: .value("Date", item.0),
                            y: .value("Head", item.1)
                        )
                        .foregroundStyle(.orange)
                    }
                }
                .frame(height: 300)
                .padding()

                // Table of values
                List {
                    ForEach(data.sorted(by: {$0.0 > $1.0}), id: \.0) {date, circumference in
                        HStack {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text("\(String(format: "%.1f", circumference)) cm")
                                .bold()
                        }
                    }
                }
            }
        }
    }
}
