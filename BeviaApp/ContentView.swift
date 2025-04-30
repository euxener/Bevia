//
//  ContentView.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Initialize service and view model
        let dataService = FileDataService()
        let babyViewModel = BabyViewModel(dataService: dataService)

        // Show the BabyListView
        BabyListView(viewModel: babyViewModel)
    }
}