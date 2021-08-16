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
    var title: String
    var showSubtitle: Bool
    var showSeeAll: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
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

struct StandardSectionView<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    var items: [Item]
    var id: KeyPath<Item, ID>
    var title: String
    var showsSubtitle: Bool
    var showsSeeAll: Bool
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], id: KeyPath<Item, ID>, title: String, showsSubtitle: Bool = false, showsSeeAll: Bool = true, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.title = title
        self.showsSubtitle = showsSubtitle
        self.showsSeeAll = showsSeeAll
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        if items.isEmpty {
            ProgressView().scaleEffect(1.5)
        } else {
            VStack(alignment: .leading) {
                Divider().padding(.horizontal)
                
                StandardHeaderView(title: title, showSubtitle: showsSubtitle, showSeeAll: showsSeeAll).padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(items, id: id) { item in
                            viewForItem(item)
                        }
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

extension StandardSectionView where Item: Identifiable, Item.ID == ID {
    init(_ items: [Item], title: String, showsSubtitle: Bool = false, showsSeeAll: Bool = true, viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \.id, title: title, showsSubtitle: showsSubtitle, showsSeeAll: showsSeeAll, viewForItem: viewForItem)
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

// HCard
struct StandardCardView1: View {
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

// HCard
struct StandardCardView2: View {
    var body: some View {
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

// MARK: - Card View Sample(s)

// Large VCard which has the fixed width size of 250
struct CardView1: View {
    private let size: CGFloat = 250
    
    var type: String = "Recently Added"
    var title: String = "Title"
    var description: String = "Get hooked on a hearty helping of heroes and villains from the humble House of Ideas!"
    var modified: String = "None"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image.soobinThumbnail(width: size, height: size)

            VStack(alignment: .leading, spacing: 5) {
                Text((type).uppercased())
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                Text(description.isEmpty ? "Default Description" : description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Text(modified)
                    .font(.footnote)
                    .foregroundColor(.purple)
            }
        }
        .frame(width: size)
    }
}

// Regular VCard which depends on the assigned width of the parent view
struct CardView2: View {
    var title: String?
    var description: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                Image.soobinThumbnail(width: geometry.size.width, height: geometry.size.height)
            }
            Text(title ?? "Chae Soo-bin")
                .font(.footnote)
                .lineLimit(1)
            Text(description ?? "Actress")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .aspectRatio(0.8, contentMode: .fit)
    }
    
}

struct CardView3: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            StandardCardView1()
            Divider()
            StandardCardView1()
            Divider()
            StandardCardView1()
        }
    }
}

struct CardView4: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            StandardCardView2()
            Divider()
            StandardCardView2()
        }
    }
}

// Simple thumbnail in Rectangle shape without any text
struct CardView5: View {
    var body: some View {
        Image.soobinThumbnail(width: 200, height: 100)
    }
}

// Bottom Banner (Shows Subtitle)
struct CardView6: View {
    var defaultSize: (CGFloat, CGFloat) {
        let width = UIScreen.main.bounds.width * 0.6
        let height = width * 1.3
        return (width, height)
    }
    
    var body: some View {
        Image.soobinThumbnail(width: defaultSize.0, height: defaultSize.1)
            .overlay(banner, alignment: .bottom)
            .cornerRadius(10.0)
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

// SubCatogeries??
struct SectionDemoView2: View {
    var items: [String]
    var title: String
    
    init(_ items: [String], title: String) {
        self.items = items
        self.title = title
    }
    
    var body: some View {
        StandardSectionView(items, id: \.self, title: title, showsSeeAll: false) { item in
            CategoryCardView(content: item)
        }
    }
    
    struct CategoryCardView: View {
        let content: String
        
        var body: some View {
            ZStack(alignment: .leading) {
                RadialGradient(gradient: Gradient(colors: [.purple, .blue]), center: .topLeading, startRadius: 5, endRadius: 500)
                Text(content)
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
}

// MARK: - SeeAll View(s)

struct SeeAllDemoView1: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            StandardGridView {
                CardView2()
            }
            .padding(.horizontal)
        }
    }
}

struct SeeAllDemoView2: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                CardView3().padding(.vertical)
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
                
                StandardHeaderView(title: "Categories Browse", showSubtitle: false, showSeeAll: false).padding(.horizontal)
                
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

struct SectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SectionDemoView2(Category.allCases.map { $0.rawValue.capitalized }, title: "Categories")
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
