//
//  UtilityViews.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-20.
//

import SwiftUI
import Combine

protocol InfoRequest {
    associatedtype Filter
    associatedtype Info: Identifiable, Hashable
    var results: CurrentValueSubject<[Info], Never> { get }
    static func create(_ filter: Filter, limit: Int?) -> Self
}

struct MarvelSectionView<Request>: View where Request: InfoRequest {
    
    // MARK: - Predicate
    
    let filter: Request.Filter
    let request: Request
    
    // MARK: - Header
    
    let title: String
    let subtitle: String?
    
    // MARK: - Content
    
    let rowCount: Int?
    let seeAllDestination: AnyView?
    let viewForItem: (Request.Info) -> AnyView
    
    @State private var infos = [Request.Info]()
    
    init(_ filter: Request.Filter, title: String, subtitle: String? = nil, rowCount: Int? = nil, seeAllDestination: AnyView? = nil, viewForItem: @escaping (Request.Info) -> AnyView) {

        self.filter = filter
        self.request = Request.create(filter, limit: nil)
        _infos = .init(initialValue: [])

        self.title = title
        self.subtitle = subtitle
        self.rowCount = rowCount
        self.seeAllDestination = seeAllDestination
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        VStack {
            Divider().padding(.horizontal)
            
            StandardHeaderView(title: title, subtitle: subtitle, seeAllDestination: seeAllDestination)
                .padding(.horizontal)
            
            if let rowCount = rowCount {
                StandardSectionView(infos.dividesToGroup(of: rowCount), id: \.self) { group in
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(group) { info in
                            viewForItem(info)
                            if let index = group.firstIndex { $0.id == info.id }, index != group.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            } else {
                StandardSectionView(infos, viewForItem: viewForItem)
            }
        }
        .onReceive(request.results) { results in
            infos = results
        }
    }
}

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
    var subtitle: String?
    var seeAllDestination: AnyView?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if let destination = seeAllDestination {
                NavigationLink(destination: destination.navigationTitle(title)) {
                    Text("See All")
                }
            }
        }
    }
}

struct StandardSectionView<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    var items: [Item]?
    var id: KeyPath<Item, ID>
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item]?, id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        if let items = items {
            if items.isEmpty {
                Text("Empty Results")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 10) { // Spacing: 10 or 15
                        ForEach(items, id: id) { item in
                            viewForItem(item)
                        }
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
            }
        } else {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
        }
    }
}

extension StandardSectionView where Item: Identifiable, Item.ID == ID {
    init(_ items: [Item]?, viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \.id, viewForItem: viewForItem)
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


// MARK: - SeeAllDestination View(s)

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
        ScrollView {
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
                CardView3(title: item[keyPath: titleKey], description: item[keyPath: descriptionKey])
                    .padding(.vertical)
            }
        }
    }
}

// MARK: - Card View(s)

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

// HCard 1
struct CardView3: View {
    private let defaultSize: CGFloat = 70
    
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image.soobinThumbnail(width: defaultSize, height: defaultSize)
            Text("1")
                .font(.callout)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 5) {
                Text(title.isEmpty ? "Spittin' Chiclets Episode 347: Featuring Kevin Weekes + HockeyFest Recap With Matt Murley" : title)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(description.isEmpty ? "Tuesday - 3 hrs, 4 min." : description)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .padding(.trailing)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

// HCard 2
struct CardView4: View {
    var modified: String
    var title: String
    var startYear: Int?
    var rating: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Image.soobinThumbnail(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text((modified.isEmpty ? "July 9" : modified).uppercased())
                    .foregroundColor(.gray)
                    .font(.caption2)
                Spacer()
                Text(title.isEmpty ? "Swipe Right for The Climate (with Dr Ayana Elizabeth Johnson)" : title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                HStack {
                    Image(systemName: "lasso.sparkles")
                    Text(String(startYear ?? -1))
                        .font(.caption)
                }
                .foregroundColor(.purple)
                Text(rating ?? "")
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 110)
    }
}

// Introduction Card on very top (Custom section view)
struct CardView5: View {
    var body: some View {
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

// Bottom Banner (Shows Subtitle)
struct CardView6: View {
    var defaultSize: (CGFloat, CGFloat) {
        let width = UIScreen.main.bounds.width * 0.6
        let height = width * 1.3
        return (width, height)
    }
    
    var title: String
    
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
            Text(title.isEmpty ? "One of a  kind podcasts featuring the funny and the fascinating." : title)
                .font(.footnote)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
        }
    }
}

// Card View for Creators
struct CardView7: View {
    let name: String
    
    var body: some View {
        VStack {
            Image.soobinThumbnail(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.trailing, 10)
            Text(name)
        }
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
