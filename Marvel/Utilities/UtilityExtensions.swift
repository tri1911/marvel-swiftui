//
//  UtilityExtensions.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-20.
//

import Foundation

extension String {
    mutating func addMarvelArgument(_ name: String, _ value: Int? = nil, `default` defaultValue: Int = 0) {
        if value != nil, value != defaultValue {
            addMarvelArgument(name, "\(value!)")
        }
    }
    
    mutating func addMarvelArgument(_ name: String, _ value: Date?) {
        if value != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            addMarvelArgument(name, dateFormatter.string(from: value!))
        }
    }
    
    mutating func addMarvelArgument(_ name: String, _ value: String? = nil) {
        if value != nil {
            self += (hasSuffix("?") ? "" : "&") + name + "=" + value!
        }
    }
}

extension Array {
    func dividesToGroup(of count: Int) -> [[Element]] {
        if !isEmpty {
            return Dictionary(grouping: self.enumerated()) { $0.offset / count } // Divides elements into groups of count
                .sorted { $0.key < $1.key } // Sorted by keys
                .map { $0.value.map { $0.element } } // Extract groups of desired elements
        }
        return []
    }
}
