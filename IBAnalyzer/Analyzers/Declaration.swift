//
//  Declaration.swift
//  IBAnalyzer
//
//  Created by USER on 14/10/2019.
//  Copyright © 2019 Arkadiusz Holko. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct Declaration {
    var name: String
    var line: Int
    var column: Int
    var url: URL?
    var isOptional: Bool

    init(name: String, line: Int, column: Int, url: URL? = nil, isOptional: Bool = false) {
        self.name = name
        self.line = line
        self.column = column
        self.url = url
        self.isOptional = isOptional
    }

    init(name: String, file: File, offset: Int64, isOptional: Bool = false) {
        let fileOffset = type(of: self).getLineColumnNumber(of: file, offset: Int(offset))
        var url: URL?
        if let path = file.path {
            url = URL(fileURLWithPath: path)
        }
        self.init(name: name, line: fileOffset.line, column: fileOffset.column, url: url, isOptional: isOptional)
    }

    var description: String {
        return filePath+":\(line):\(column)"
    }

    var filePath: String {
        if let path = url?.absoluteString {
            return path.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
        }
        return name
    }

    func fileName(className: String) -> String {
        if let filename = url?.lastPathComponent {
            return filename
        }
        return className
    }

    private static func getLineColumnNumber(of file: File, offset: Int) -> (line: Int, column: Int) {
        printLog("file.contents "+String(describing: file.contents))
        
        let range = file.contents.startIndex..<(file.contents.index(file.contents.startIndex, offsetBy: offset, limitedBy: file.contents.endIndex) ?? file.contents.endIndex)
        let subString = file.contents[safe: range] // .substring(with: range)
        let lines = subString.components(separatedBy: "\n")

        if let column = lines.last?.count {
            return (line: lines.count, column: column)
        }
        return (line: lines.count, column: 0)
    }
}

extension Declaration: Equatable {
    public static func == (lhs: Declaration, rhs: Declaration) -> Bool {
        return lhs.name == rhs.name
    }
}
