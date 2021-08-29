//
//  CategoriesSectionView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct CategoriesSectionView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Divider().padding(.horizontal)
            StandardHeaderView<AnyView>(title: "Categories").padding(.horizontal)
            StandardSectionView(Category.allCases) { category in
                Group {
                    if category == .comics {
                        Button {
                            tabSelection = 2
                        } label: {
                            CategoryCardView(category: category.rawValue.capitalized)
                        }
                    } else {
                        NavigationLink(destination: category.destination) {
                            CategoryCardView(category: category.rawValue.capitalized)
                        }
                    }
                }
            }
        }
    }
    
    enum Category: String, CaseIterable, Identifiable {
        case characters, comics, events, series
        
        var id: String { self.rawValue }
        
        @ViewBuilder
        var destination: some View {
            switch self {
            case .characters:
                CharactersView()
            case .events:
                EventsView()
            case .series:
                SeriesView()
            case .comics:
                EmptyView()
            }
        }
    }
}

struct CategoryCardView: View {
    let category: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RadialGradient(gradient: Gradient(colors: [.purple, .blue]), center: .topLeading, startRadius: 5, endRadius: 500)
            Text(category)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 130)
        }
        .cornerRadius(5.0)
        .aspectRatio(2.2, contentMode: .fit)
        .frame(width: 220)
    }
}
