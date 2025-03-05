//
//  ViewState.swift
//  test-pays
//
//

enum ViewState {

    case loading
    case showContent(countries: [Country])
    case error(message: String)

}

extension ViewState: Equatable {

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case let (.showContent(lhs), .showContent(rhs)):
            return lhs == rhs
        case let (.error(lhs), .error(rhs)):
            return lhs == rhs
        default:
            return true
        }
    }

}
