//
//  String+Safe.swift
//  IBAnalyzer
//
//  Created by USER on 14/10/2019.
//  Copyright © 2019 Arkadiusz Holko. All rights reserved.
//

import Foundation

extension String {
    subscript(safe range: Range<Index>) -> Substring {
        let endIndex: Index = self.endIndex
        let lowerRangeIndex: Index = range.lowerBound
        let upperRangeIndex: Index = range.upperBound
        let subscriptedRange = Range(uncheckedBounds: (lower: Swift.min(lowerRangeIndex, endIndex), upper: Swift.min(upperRangeIndex, endIndex)))
        
        return self[subscriptedRange]
    }
}

