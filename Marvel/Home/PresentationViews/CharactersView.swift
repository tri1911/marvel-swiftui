//
//  CharactersView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI
import Combine

struct CharactersView: View {
    @StateObject var request = CharacterInfoRequest.create(CharacterFilter(orderBy: "name"), limit: 10)
    
    var characters: [CharacterInfo]? { request.results }
    
    var body: some View {
        Group {
            if let characters = characters {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            StandardGridView(items: characters) { character in
                                CharacterCardView(character)
                            }
                            
                            // Load More Button (Only when there are more data to fetch)
                            if characters.count < request.total {
                                if request.offset == characters.count {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                        .padding()
                                } else {
                                    Button {
                                        request.offset = characters.count
                                        request.fetch(useCache: false)
                                    } label: {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .foregroundColor(.gray.opacity(0.2))
                                            .frame(width: 100, height: 40)
                                            .overlay(Text("Load More"))
                                    }
                                }
                            }
                        }
                        .id(1)
                        .overlay(reader, alignment: .top) // track the scrolling offset
                    }
                    .overlay(scrollToTopButton(proxy), alignment: .bottomTrailing)
                }
            } else {
                LoadingView()
            }
        }
        .navigationTitle("Characters")
    }
    
    // MARK: - Scrolling to Top Button
    
    @State private var initialOffset: CGFloat = 0
    @State private var scrollingOffset: CGFloat = 0

    var buttonOpacity: Double { max(0, min(Double(-scrollingOffset)/450, 1)) } // Cap to (0, 1)

    // Geometry Reader to track the scrollingOffset
    var reader: some View {
        GeometryReader { geometry -> Color in
            let currentOffset = geometry.frame(in: .global).minY
            DispatchQueue.main.async {
                // Save the initial offset
                if initialOffset == 0 { initialOffset = currentOffset }
                // Updating the scrolling offset
                scrollingOffset = currentOffset - initialOffset
            }
            return .clear
        }
        .frame(width: 0, height: 0)
    }

    func scrollToTopButton(_ proxy: ScrollViewProxy) -> some View {
        Button {
            withAnimation {
                proxy.scrollTo(1, anchor: .top)
            }
        } label: {
            Image(systemName: "arrow.up")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
                .padding()
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.02), radius: 5, x: 5, y: 5)
        }
        .padding()
        .opacity(buttonOpacity)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
