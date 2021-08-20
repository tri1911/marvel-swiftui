//
//  UtilityExtensions.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-20.
//

import Foundation

extension Array where Element: Hashable {
    func dividesToGroup(of count: Int) -> [[Element]]? {
        if !isEmpty {
            return Dictionary(grouping: self.enumerated()) { $0.offset / count } // Divides elements into groups of count
                .sorted { $0.key < $1.key } // Sorted by keys
                .map { $0.value.map { $0.element } } // Extract groups of desired elements
        }
        return nil
    }
}
