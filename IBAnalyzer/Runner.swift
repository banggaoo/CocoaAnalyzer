//
//  Runner.swift
//  IBAnalyzer
//
//  Created by Arkadiusz Holko on 29/01/2017.
//  Copyright © 2017 Arkadiusz Holko. All rights reserved.
//

import Foundation
import SourceKittenFramework

class Runner {
    let path: String
    let directoryEnumerator: DirectoryContentsEnumeratorType
    let nibParser: NibParserType
    let swiftParser: SwiftParserType
    let fileManager: FileManager

    init(path: String,
         directoryEnumerator: DirectoryContentsEnumeratorType = DirectoryContentsEnumerator(),
         nibParser: NibParserType = NibParser(),
         swiftParser: SwiftParserType = SwiftParser(),
         fileManager: FileManager = FileManager()) {
        self.path = path
        self.directoryEnumerator = directoryEnumerator
        self.nibParser = nibParser
        self.swiftParser = swiftParser
        self.fileManager = fileManager
    }
    
    func runDigonasis() throws -> [Issue] {
        return try issues(using: [ConnectionAnalyzer()])
    }

    func issues(using analyzers: [Analyzer]) throws -> [Issue] {
        var classNameToNibMap: [String: Nib] = [:]
        var classNameToClassMap: [String: Class] = [:]
 
        let manager = FileManager.default
        var fileIssues = [FileIssue]()
       
        let nibFiles = try getNibFiles()
        for url in nibFiles {
            printLog("nib "+url.absoluteString)
            
            let fileName = url.deletingPathExtension().lastPathComponent
            let swiftFileName = fileName + ".swift"
            let swiftUrl = url.deletingLastPathComponent().appendingPathComponent(swiftFileName).standardized
            
            if manager.fileExists(atPath: swiftUrl.path) {
                let connections = try nibParser.mappingForFile(at: url)
                for (key, value) in connections {
                    if let nib = classNameToNibMap[key] {
                        if nib.count < value.count {
                            classNameToNibMap[key] = value
                        }
                    } else {
                        classNameToNibMap[key] = value
                    }
                }
            } else {
                let issue = FileIssue.cannotFindSource(fileName: swiftUrl.lastPathComponent)
                fileIssues.append(issue)
            }
        }
           
        let swiftFiles = try getSwiftFiles()
        for url in swiftFiles {
            try swiftParser.mappingForFile(at: url, result: &classNameToClassMap)
        }
        let configuration = AnalyzerConfiguration(classNameToNibMap: classNameToNibMap,
                                                  classNameToClassMap: classNameToClassMap,
                                                  uiKitClassNameToClassMap: uiKitClassNameToClass())
        let issues = analyzers.flatMap { $0.issues(for: configuration) }
        return fileIssues + issues
    }

    
    func getNibFiles() throws -> [URL] {
        return try files().filter { $0.pathExtension == "storyboard" || $0.pathExtension == "xib"}
    }

    func getSwiftFiles() throws -> [URL] {
        return try files().filter { $0.pathExtension == "swift" }
    }

    fileprivate func files() throws -> [URL] {
        let url = URL(fileURLWithPath: path)
        return try directoryEnumerator.files(at: url, fileManager: fileManager)
    }
}

