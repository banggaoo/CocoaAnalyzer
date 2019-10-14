//
//  ConnectionAnalyzerTests.swift
//  IBAnalyzer
//
//  Created by Arkadiusz Holko on 14/01/2017.
//  Copyright © 2017 Arkadiusz Holko. All rights reserved.
//

import XCTest
@testable import IBAnalyzer

extension ConnectionIssue: Equatable {
    public static func == (lhs: ConnectionIssue, rhs: ConnectionIssue) -> Bool {
        // Not pretty but probably good enough for tests.
        return String(describing: lhs) == String(describing: rhs)
    }
}

class ConnectionAnalyzerTests: XCTestCase {
    
    func testNoOutletsAndActions() {
        let nib = Nib(outlets: [], actions: [])
        let klass = Class(outlets: [], actions: [], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass])
        XCTAssertFalse(hasConnectionIssue(configuration: config))
    }

    func testMissingOutlet() {
        let label = Declaration(name: "label", line: 1, column: 0)
        let nib = Nib(outlets: [label], actions: [])
        let klass = Class(outlets: [], actions: [], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass])
        let issue = ConnectionIssue.missingOutlet(className: "A", outlet: label)
        XCTAssertTrue(hasConnectionIssue(with: issue, configuration: config))
    }

    func testMissingAction() {
        let didTapButton = Declaration(name: "didTapButton:", line: 1, column: 0)
        let nib = Nib(outlets: [], actions: [didTapButton])
        let klass = Class(outlets: [], actions: [], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass])
        let issue = ConnectionIssue.missingAction(className: "A", action: didTapButton)
        XCTAssertTrue(hasConnectionIssue(with: issue, configuration: config))

    }

    func testUnnecessaryOutlet() {
        let nib = Nib(outlets: [], actions: [])
        let label = Declaration(name: "label", line: 1, column: 0)
        let klass = Class(outlets: [label], actions: [], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass])
        let issue = ConnectionIssue.unnecessaryOutlet(className: "A", outlet: label)
        XCTAssertTrue(hasConnectionIssue(with: issue, configuration: config))
    }

    func testUnnecessaryAction() {
        let nib = Nib(outlets: [], actions: [])
        let didTapButton = Declaration(name: "didTapButton:", line: 1, column: 0)
        let klass = Class(outlets: [], actions: [didTapButton], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass])
        let issue = ConnectionIssue.unnecessaryAction(className: "A", action: didTapButton)
        XCTAssertTrue(hasConnectionIssue(with: issue, configuration: config))

    }

    func testNoIssueWhenOutletInSuperClass() {
        let label = Declaration(name: "label", line: 1, column: 0)
        let nib = Nib(outlets: [label], actions: [])
        let map = ["A": Class(outlets: [label], actions: [], inherited: []),
                   "B": Class(outlets: [], actions: [], inherited: ["A"])]
        let config = AnalyzerConfiguration(classNameToNibMap: ["B": nib],
                                                  classNameToClassMap: map)
        XCTAssertFalse(hasConnectionIssue(configuration: config))
    }

    func testNoIssueWhenOutletInSuperSuperClass() {
        let label = Declaration(name: "label", line: 1, column: 0)
        let nib = Nib(outlets: [label], actions: [])
        let map = ["A": Class(outlets: [label], actions: [], inherited: []),
                   "B": Class(outlets: [], actions: [], inherited: ["A"]),
                   "C": Class(outlets: [], actions: [], inherited: ["B"])]
        let config = AnalyzerConfiguration(classNameToNibMap: ["C": nib],
                                                  classNameToClassMap: map)
        XCTAssertFalse(hasConnectionIssue(configuration: config))
    }

    func testNoIssueWhenActionInSuperClass() {
        let didTapButton = Declaration(name: "didTapButton:", line: 1, column: 0)
        let nib = Nib(outlets: [], actions: [didTapButton])
        let map = ["A": Class(outlets: [], actions: [didTapButton], inherited: []),
                   "B": Class(outlets: [], actions: [], inherited: ["A"]),
                   "C": Class(outlets: [], actions: [], inherited: ["B"])]
        let config = AnalyzerConfiguration(classNameToNibMap: ["C": nib],
                                                  classNameToClassMap: map)
        XCTAssertFalse(hasConnectionIssue(configuration: config))
    }

    func testUsesUIKitClasses() {
        let delegate = Declaration(name: "delegate:", line: 1, column: 0)
        let nib = Nib(outlets: [delegate], actions: [])
        let klass = Class(outlets: [], actions: [], inherited: ["UITextField"])
        let textField = Class(outlets: [delegate], actions: [], inherited: [])
        let config = AnalyzerConfiguration(classNameToNibMap: ["A": nib],
                                                  classNameToClassMap: ["A": klass],
                                                  uiKitClassNameToClassMap: ["UITextField": textField])
        XCTAssertFalse(hasConnectionIssue(configuration: config))
    }
}

// MARK: Util
extension ConnectionAnalyzerTests {

    private func getIssues(for configuration: AnalyzerConfiguration) -> [Issue] {
        var result = [Issue]()
        let connectionAnalyzer = ConnectionAnalyzer()
        result.append(contentsOf: connectionAnalyzer.issues(for: configuration))
        return result
    }
    
    private func hasConnectionIssue(with connectionIssue: ConnectionIssue? = nil,
                                    configuration: AnalyzerConfiguration) -> Bool {
        return hasIssue(with: connectionIssue, configuration: configuration)
    }
    
    private func hasIssue<IssueType: Issue & Equatable>(with issue: IssueType?,
                          configuration: AnalyzerConfiguration) -> Bool {
        let issues = getIssues(for: configuration)
        guard let issue = issue else { return issues.hasElement }
        let sameIssues = issues.filter {
            guard let typedIssue = $0 as? IssueType else { return false }
            return typedIssue == issue
        }
        return sameIssues.hasElement
    }
}

extension Array {
    var hasElement: Bool {
        return !isEmpty
    }
}
