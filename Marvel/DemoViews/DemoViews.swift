//
//  DemoViews.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-11.
//

import SwiftUI

// MARK: - Extension(s)

extension Image {
    static func soobinThumbnail(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        Image("soobin\(Int.random(in: 0..<14))")
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .cornerRadius(10.0)
    }
}

// MARK: - Standard View(s)

struct StandardHeaderView: View {
    var showSubtitle: Bool
    var showSeeAll: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.title3)
                    .fontWeight(.bold)
                
                if showSubtitle {
                    Text("Shows you'll love, made in Canada.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if showSeeAll {
                Button("See All") {}
            }
        }
    }
}

struct StandardSectionView<Content>: View where Content: View {
    var itemsCount: Int = 6
    var showSubtitle: Bool = false
    var showSeeAll: Bool = true
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider().padding(.horizontal)
            
            StandardHeaderView(showSubtitle: showSubtitle, showSeeAll: showSeeAll).padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(0..<itemsCount) { _ in
                        content()
                    }
                }
                .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// Standard Card View used for Section and in SeeAll Grid
struct StandardCardView1: View {
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                Image.soobinThumbnail(width: geometry.size.width, height: geometry.size.height)
            }
            Text("Chae Soo-bin")
                .font(.footnote)
            Text("Actress")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
}

// Standard Card View used for Section and in SeeAll List
struct StandardCardView2: View {
    private let defaultSize: CGFloat = 70
    
    var body: some View {
        HStack(spacing: 15) {
            Image.soobinThumbnail(width: defaultSize, height: defaultSize)
            Text("3")
                .font(.callout)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 5) {
                Text("Spittin' Chiclets Episode 347: Featuring Kevin Weekes + HockeyFest Recap With Matt Murley")
                    .lineLimit(2)
                Text("Tuesday - 3 hrs, 4 min.")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

// MARK: - Section View(s)

// Introduction Card on very top (Custom section view)
struct SectionDemoView1: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 15) {
                ForEach(0..<5) { _ in
                    VStack(alignment: .leading) {
                        Divider()
                        Text("New Release".uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        Text("The Grand Scheme")
                            .font(.title2)
                        Text("Hosted by John Stamos.")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Image.soobinThumbnail(width: UIScreen.main.bounds.width * 0.9, height: 150)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Bottom Banner
struct SectionDemoView2: View {
    var defaultSize: (CGFloat, CGFloat) {
        let width = UIScreen.main.bounds.width * 0.6
        let height = width * 1.3
        return (width, height)
    }
    
    var body: some View {
        StandardSectionView(showSubtitle: true) {
            Image.soobinThumbnail(width: defaultSize.0, height: defaultSize.1)
                .overlay(banner, alignment: .bottom)
                .cornerRadius(10.0)
        }
    }
    
    var banner: some View {
        ZStack {
            Rectangle()
                .frame(height: defaultSize.0 * 0.3)
                .foregroundColor(.purple)
            Text("One of a  kind podcasts featuring the funny and the fascinating.")
                .font(.footnote)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
        }
    }
}

// Large VCard
struct SectionDemoView3: View {
    private let size: CGFloat = 250
    
    var body: some View {
        StandardSectionView {
            VStack(alignment: .leading, spacing: 10) {
                Image.soobinThumbnail(width: size, height: size)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Recently Added".uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                    Text("Leading leaders who lead engineers")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .lineLimit(3)
                    Group {
                        Text("Chae Soo-bin").foregroundColor(.gray)
                        Text("Actress").foregroundColor(.purple)
                    }
                    .font(.footnote)
                }
            }
            .frame(width: size)
        }
    }
}

// Regular VCard
struct SectionDemoView4: View {
    var body: some View {
        StandardSectionView {
            StandardCardView1()
                .aspectRatio(0.8, contentMode: .fit)
                .frame(width: 165)
        }
    }
}

// 2 HCards
struct SectionDemoView5: View {
    var body: some View {
        StandardSectionView {
            VStack(alignment: .leading, spacing: 10) {
                card
                Divider()
                card
            }
        }
    }
    
    var card: some View {
        HStack(alignment: .top) {
            Image.soobinThumbnail(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text("July 9".uppercased())
                    .foregroundColor(.gray)
                    .font(.caption2)
                Spacer()
                Text("Swipe Right for The Climate (with Dr Ayana Elizabeth Johnson)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                Spacer()
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("23 min.")
                        .font(.caption)
                }
                .foregroundColor(.purple)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 110)
    }
}

// 3 HCards
struct SectionDemoView6: View {
    var body: some View {
        StandardSectionView {
            VStack(alignment: .leading, spacing: 15) {
                StandardCardView2()
                Divider()
                StandardCardView2()
                Divider()
                StandardCardView2()
            }
        }
    }
}

// Simple thumbnail in Rectangle shape without any text
struct SectionDemoView7: View {
    var body: some View {
        StandardSectionView {
            Image.soobinThumbnail(width: 200, height: 100)
        }
    }
}

// MARK: - SeeAll View(s)

struct SeeAllDemoView1: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            StandardGridView {
                StandardCardView1()
                    .aspectRatio(0.8, contentMode: .fit)
            }
            .padding(.horizontal)
        }
    }
}

struct SeeAllDemoView2: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                StandardCardView2().padding(.vertical)
            }
        }
        .padding(.trailing)
    }
}

// MARK: - Default Search Result View (Categories)

struct DefaultSearchResultView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Divider().padding(.horizontal)
                
                StandardHeaderView(showSubtitle: false, showSeeAll: false).padding(.horizontal)
                
                StandardGridView {
                    GeometryReader { geometry in
                        Image.soobinThumbnail(width: geometry.size.width, height: geometry.size.height)
                            .overlay(text, alignment: .bottomLeading)
                    }
                    .aspectRatio(1.5, contentMode: .fill)
                }
                .padding(.horizontal)
            }
        }
    }
    
    var text: some View {
        Text("Soobin")
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.white)
            .padding(5)
    }
}

struct StandardGridView<Content>: View where Content: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var itemsCount = 10
    var content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<itemsCount) { _ in
                content()
            }
        }
    }
}

struct SectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
//        SectionDemoView1()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView2()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView3()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView4()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView5()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView6()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
//        SectionDemoView7()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
        SeeAllDemoView1()
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
//        DefaultSearchResultView()
//            .padding(.vertical)
//            .previewLayout(.sizeThatFits)
    }
}
