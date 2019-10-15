//
//  NibParserTests.swift
//  IBAnalyzer
//
//  Created by Arkadiusz Holko on 27-12-16.
//  Copyright © 2016 Arkadiusz Holko. All rights reserved.
//

import XCTest
@testable import IBAnalyzer

class NibParserTests: XCTestCase {
/*
    func testExampleStoryboard() {
        guard let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"] else {
            fatalError("SRCROOT should be non-nil")
        }

        let path = "/IBAnalyzerTests/Examples/Example.storyboard"
        let storyboardPath = (srcRoot as NSString).appendingPathComponent(path)
        let url = URL(fileURLWithPath: storyboardPath)
        let parser = NibParser()
        let button = Declaration(name: "button", line: 1, column: 0)
        let titleLabel = Declaration(name: "titleLabel", line: 1, column: 0)
        let didTapButton = Declaration(name: "didTapButton:", line: 1, column: 0)
        let expected = ["ViewController": Nib(outlets: [button, titleLabel], actions: [didTapButton]),
             "ViewController2": Nib(outlets: [], actions: [])]
        do {
            let result = try parser.mappingForFile(at: url)
            XCTAssertEqual(result, expected)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }*/
    /*
    func testNib() {
        guard let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"] else {
            fatalError("SRCROOT should be non-nil")
        }

        let folder = "/IBAnalyzerTests/Examples"
        let path = "/IBAnalyzerTests/Examples/VideoCommentBottomBar.xib"
        let folderdPath = (srcRoot as NSString).appendingPathComponent(folder)
        let storyboardPath = (srcRoot as NSString).appendingPathComponent(path)
        let folderUrl = URL(fileURLWithPath: folderdPath)
        let url = URL(fileURLWithPath: storyboardPath)
        /*
        let parser = NibParser()
        do {
            let result = try parser.mappingForFile(at: url)
            print(result)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        */
        let runner = Runner(path: folderUrl.path)

//        Configuration.shared.setup(with: args)

        let issues = try? runner.runDigonasis()
        print(issues)
    }*/
}
