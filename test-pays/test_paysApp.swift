//
//  test_paysApp.swift
//  test-pays
//
//

import SwiftUI

@main
struct test_paysApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = ListViewModel(service: CountriesService())
            ListView(viewModel: viewModel)
        }
    }
}
