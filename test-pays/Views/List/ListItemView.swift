//
//  ListItemView.swift
//  test-pays
//
//

import SwiftUI

struct ListItemView: View {

    private let name: String
    private let flag: String

    // MARK: - Init

    public init(name: String, flag: String) {
        self.name = name
        self.flag = flag
    }

    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(
                url: URL(string: flag),
                content: { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                    case .failure, .empty:
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                    @unknown default:
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                    }
                }
            )
            .border(.black.opacity(0.25))
            .frame(width: 100, height: 100)
            Text(name)
                .foregroundColor(.black)
                .font(.title2)
        }
    }

}
