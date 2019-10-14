//
//  FileAnalyzer.swift
//  IBAnalyzer
//
//  Created by USER on 14/10/2019.
//  Copyright © 2019 Arkadiusz Holko. All rights reserved.
//

import Foundation

enum FileIssue: Issue {
    case cannotFindSource(fileName: String)
    
    var description: String {
        switch self {
        case let .cannotFindSource(fileName):
            return "warning: Could not find swift source file name \(fileName)"
        }
    }
    
    var isSeriousViolation: Bool {
        return false
    }
}
