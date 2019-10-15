//
//  Configuration.swift
//  IBAnalyzer
//
//  Created by USER on 14/10/2019.
//  Copyright © 2019 Arkadiusz Holko. All rights reserved.
//

import Foundation

enum Rule: String {
    case ignoreOptionalProperty //track optional properties
}

class Configuration {

    static let shared = Configuration()

    var configuration: [Rule: Bool] =
        [.ignoreOptionalProperty: false]

    private init() { }

    func setup(with arguments: [String]) {
        for argument in arguments {
            if let rule = Rule(rawValue: argument) {
                self.configuration[rule] = true
            }
        }
    }

    func isEnabled(_ rule: Rule) -> Bool {
        return configuration[rule] ?? false
    }
}
