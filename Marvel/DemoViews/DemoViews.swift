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

struct StandardHeaderView<Destination>: View where Destination: View{
    var title: String
    var showSubtitle: Bool
    var showSeeAll: Bool
    var destination: Destination
    
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
                NavigationLink(destination: destination.navigationTitle(title)) {
                    Text("See All")
                }
            }
        }
    }
}

struct StandardSectionView<Item, ID, ItemView, Destination>: View where ID: Hashable, ItemView: View, Destination: View {
    var items: [Item]?
    var id: KeyPath<Item, ID>
    var title: String
    var showsSubtitle: Bool
    var showsSeeAll: Bool
    var destination: Destination
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item]?, id: KeyPath<Item, ID>, title: String, showsSubtitle: Bool = false, showsSeeAll: Bool = true, destination: Destination, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.title = title
        self.showsSubtitle = showsSubtitle
        self.showsSeeAll = showsSeeAll
        self.destination = destination
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        if let items = items {
            // Main VStack
            VStack(alignment: .leading) {
                // Divider
                Divider().padding(.horizontal)
                // Header
                StandardHeaderView(
                    title: title,
                    showSubtitle: showsSubtitle,
                    showSeeAll: showsSeeAll && !items.isEmpty,
                    destination: destination
                )
                .padding(.horizontal)
                // Content
                if items.isEmpty {
                    Text("Nothing to show").foregroundColor(.gray)
                } else {
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
        } else {
            ProgressView().scaleEffect(1.5)
        }
    }
}

extension StandardSectionView where Item: Identifiable, Item.ID == ID {
    init(_ items: [Item]?, title: String, showsSubtitle: Bool = false, showsSeeAll: Bool = true, destination: Destination, viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \.id, title: title, showsSubtitle: showsSubtitle, showsSeeAll: showsSeeAll, destination: destination, viewForItem: viewForItem)
    }
}

struct StandardGridView<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items) { item in
                viewForItem(item)
            }
        }
    }
}

// HCard Type 1
struct StandardCardView1: View {
    private let defaultSize: CGFloat = 70
    
    var title: String
    var desciption: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image.soobinThumbnail(width: defaultSize, height: defaultSize)
            Text("1")
                .font(.callout)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 5) {
                Text(title.isEmpty ? "Spittin' Chiclets Episode 347: Featuring Kevin Weekes + HockeyFest Recap With Matt Murley" : title)
                Text(desciption.isEmpty ? "Tuesday - 3 hrs, 4 min." : desciption)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

// HCard Type 2
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
                Text("Added: \(modified)")
                    .font(.footnote)
                    .foregroundColor(.purple)
            }
        }
        .frame(width: size)
    }
}

// Regular VCard which depends on the assigned width of the parent view
struct CardView2: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                Image.soobinThumbnail(width: geometry.size.width, height: geometry.size.height)
            }
            Text(title)
                .font(.footnote)
                .lineLimit(1)
            Text(description)
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
            StandardCardView1(title: "Title", desciption: "Description")
            Divider()
            StandardCardView1(title: "Title", desciption: "Description")
            Divider()
            StandardCardView1(title: "Title", desciption: "Description")
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
        StandardSectionView(items, id: \.self, title: title, showsSeeAll: false, destination: Text("Destination")) { item in
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

struct SeeAllDemoView1<Item>: View where Item: Identifiable {
    var items: [Item]
    var titleKey: KeyPath<Item, String>
    var descriptionKey: KeyPath<Item, String>
    
    init(_ items: [Item], titleKey: KeyPath<Item, String>, descriptionKey: KeyPath<Item, String>) {
        self.items = items
        self.titleKey = titleKey
        self.descriptionKey = descriptionKey
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            StandardGridView(items: items) { item in
                CardView2(title: item[keyPath: titleKey], description: item[keyPath: descriptionKey].isEmpty ? "Default Description" : item[keyPath: descriptionKey])
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SeeAllDemoView2<Item>: View where Item: Identifiable {
    var items: [Item]
    var titleKey: KeyPath<Item, String>
    var descriptionKey: KeyPath<Item, String>
    
    init(_ items: [Item], titleKey: KeyPath<Item, String>, descriptionKey: KeyPath<Item, String>) {
        self.items = items
        self.titleKey = titleKey
        self.descriptionKey = descriptionKey
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                StandardCardView1(title: item[keyPath: titleKey], desciption: item[keyPath: descriptionKey])
                    .padding(.vertical)
            }
        }
    }
}

// MARK: - Default Search Result View (Categories)

//struct DefaultSearchResultView: View {
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            VStack(alignment: .leading, spacing: 10) {
//                Divider().padding(.horizontal)
//
//                StandardHeaderView(title: "Categories Browse", showSubtitle: false, showSeeAll: false, destination: Text("Destination"))
//                    .padding(.horizontal)
//
//                StandardGridView {
//                    GeometryReader { geometry in
//                        Image.soobinThumbnail(width: geometry.size.width, height: geometry.size.height)
//                            .overlay(text, alignment: .bottomLeading)
//                    }
//                    .aspectRatio(1.5, contentMode: .fill)
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//
//    var text: some View {
//        Text("Soobin")
//            .font(.system(size: 15, weight: .medium))
//            .foregroundColor(.white)
//            .padding(5)
//    }
//}

struct SectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
//        SectionDemoView2(Category.allCases.map { $0.rawValue.capitalized }, title: "Categories")
        StandardCardView2()
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
