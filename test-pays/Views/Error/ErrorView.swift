//
//  ErrorView.swift
//  test-pays
//
//

import SwiftUI

struct ErrorView: View {

    private let errorMessage: String
    private let action: (() -> Void)?

    // MARK: - Init

    public init(message: String, action: (() -> Void)?) {
        self.errorMessage = message
        self.action = action
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(errorMessage)
                .font(.title)
                .foregroundColor(.black)
                .frame(alignment: .center)
                .padding([.leading, .trailing], 16)
            Button("Retry") {
                action?()
            }
            .foregroundStyle(.blue)
        }
    }

}
