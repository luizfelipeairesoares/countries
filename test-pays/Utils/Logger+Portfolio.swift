//
//  Logger+Portfolio.swift
//  test-pays
//
//

import OSLog

extension Logger {

    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.luizsoares.test-pays"

    static let network = Logger(subsystem: subsystem, category: "network")

}
