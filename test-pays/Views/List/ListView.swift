//
//  ListView.swift
//  test-pays
//
//

import SwiftUI

struct ListView: View {

    @ObservedObject var viewModel: ListViewModel

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .foregroundStyle(.black)
            case .error(let message):
                ErrorView(
                    message: message,
                    action: {
                        viewModel.loadAll()
                    }
                )
            case .showContent(let datasource) where datasource.isEmpty:
                ErrorView(
                    message: "Empty List",
                    action: nil
                )
            case .showContent(let datasource):
                List(datasource, id: \.id) { country in
                    NavigationLink {
                        viewModel.show(country)
                    } label: {
                        ListItemView(
                            name: country.name.common,
                            flag: country.flags.png
                        )
                    }
                    .listRowBackground(Color.white.opacity(0.65))
                    .alignmentGuide(.listRowSeparatorLeading) { dimension in
                        dimension[.leading]
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(hex: "#DCE9EE"))
                .listStyle(GroupedListStyle())
                .navigationTitle("Pays")
                .searchable(text: $viewModel.searchText, prompt: "Search Country")
                .onSubmit(of: .search) {
                    viewModel.searchCountry()
                }
                .onChange(of: viewModel.searchText, { oldValue, newValue in
                    if newValue.isEmpty {
                        viewModel.searchCountry()
                    }
                })
            }
        }
        .tint(.black)
        .onAppear {
            viewModel.loadAll()
        }
    }
}
