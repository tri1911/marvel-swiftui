//
//  UtilityExtensions.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-20.
//

import Foundation

// in a Collection of Identifiables
// we often might want to find the element that has the same id
// as an Identifiable we already have in hand
// we name this index(matching:) instead of firstIndex(matching:)
// because we assume that someone creating a Collection of Identifiable
// is usually going to have only one of each Identifiable thing in there

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension Collection {
    func dividesToGroup(of count: Int) -> [[Element]] {
        if !isEmpty {
            return Dictionary(grouping: self.enumerated()) { $0.offset / count } // Divides elements into groups of count
                .sorted { $0.key < $1.key } // Sorted by keys
                .map { $0.value.map { $0.element } } // Extract groups of desired elements
        }
        return []
    }
}

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

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
