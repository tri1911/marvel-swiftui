//
//  SeriesView.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct SeriesView: View {
    @StateObject var request = SeriesInfoRequest.create(SeriesFilter(seriesType: .limited, orderBy: "-startYear"), limit: 30) // 623 in total
    
    var series: [SeriesInfo]? { request.results }
    var screenHeight: CGFloat { UIScreen.main.bounds.height }
    
    var body: some View {
        Group {
            if let series = series {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(series) { info in
                                SeriesCardView(info)
                                Divider()
                            }
                            
                            if series.count < request.total {
                                // Infinity Scrolling
                                if request.offset == series.count {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                        .padding()
                                        .onAppear {
                                            request.fetch(useCache: false)
                                        }
                                } else {
                                    GeometryReader { geometry -> Color in
                                        let minY = geometry.frame(in: .global).minY
                                        let threshold = screenHeight / 1.3
                                        
                                        if minY < threshold {
                                            DispatchQueue.main.async {
                                                request.offset = series.count
                                            }
                                        }
                                        
                                        return .clear
                                    }
                                    .frame(width: 20, height: 20)
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
        .navigationTitle("Series")
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
                // print(scrollingOffset)
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

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView()
    }
}
