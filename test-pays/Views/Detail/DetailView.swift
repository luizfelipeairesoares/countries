//
//  DetailView.swift
//  test-pays
//
//

import SwiftUI

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel

    public init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(
                url: URL(string: viewModel.country.flags.png),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text(createAttributedString(
                title: "Continents: ",
                text: viewModel.country.continents.joined(separator: ", ")
            ))
                .foregroundColor(.black)
                .frame(alignment: .leading)
                .padding([.leading, .trailing], 16)
            Text(createAttributedString(
                title: "Population: ",
                text: "\(viewModel.country.population)"
            ))
                .foregroundColor(.black)
                .frame(alignment: .leading)
                .padding([.leading, .trailing], 16)
            Text(createAttributedString(
                title: "Capitale: ",
                text: "\(viewModel.country.capital.joined(separator: ", "))"
            ))
                .foregroundColor(.black)
                .frame(alignment: .leading)
                .padding([.leading, .trailing], 16)
            Spacer()
        }
        .background(Color(hex: "#DCE9EE"))
        .navigationTitle(viewModel.country.name.common)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }

    // MARK: - Private

    private func createAttributedString(title: String, text: String) -> AttributedString {
        var titleAttrString = AttributedString(title)
        titleAttrString.font = .boldSystemFont(ofSize: 18)
        titleAttrString.foregroundColor = .black
        
        var textAttrString = AttributedString(text)
        textAttrString.font = .systemFont(ofSize: 18)
        textAttrString.foregroundColor = .black

        return titleAttrString + textAttrString
    }
}
