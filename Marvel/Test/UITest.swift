//
//  UITest.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-13.
//

import SwiftUI

struct UITest: View {
    var body: some View {
        VStack {
//            let numbers = Array(0..<20)
//            let groups = Dictionary(grouping: numbers) { $0 / 3 }
//                .sorted { $0.key < $1.key }
//                .map { $0.value }
            let strings = (0..<13).map { String($0) }
            let groups = groups(strings)
            
            ForEach(groups, id: \.self) { group in
                HStack {
                    ForEach(group, id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
        }
    }
    
    private func groups(_ items: [String]) -> [[String]] {
        let enumratedStrings = items.enumerated()
        return Dictionary(grouping: enumratedStrings) { index, item in index / 3 }
            .sorted { $0.key < $1.key }
            .map { $0.value.map { index, item in item } }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        UITest()
    }
}
