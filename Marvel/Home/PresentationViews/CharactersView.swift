////
////  CharactersView.swift
////  Marvel
////
////  Created by Elliot Ho on 2021-08-10.
////
//
//import SwiftUI
//
//struct CharactersView: View {
//    // TODO: SectionView's onAppear() is called twice when putting CharactersView into TabView
//    var body: some View {
//        NavigationView {
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVStack {
//                    CharacterSectionView(title: "First 10", filterSet: CharacterFilter())
////                    SectionView(title: "Thor Search", filterSet: CharacterFilterSet(nameStartsWith: "Thor"))
////                    SectionView(title: "Spider Search", filterSet: CharacterFilterSet(nameStartsWith: "Spider"))
////                    SectionView(title: "Captain Search", filterSet: CharacterFilterSet(nameStartsWith: "Captain"))
//                }
//            }
//            .navigationTitle("Characters")
//        }
//        .ignoresSafeArea()
//    }
//}
//
//struct CharacterSectionView: View {
//    @EnvironmentObject var store: CharacterStore
//    let title: String
//    let filterSet: CharacterFilterSet
//    
//    private var characters: Array<CharacterInfo>? { store.characters[filterSet] }
//  
//    var body: some View {
//        // Section
//        VStack(spacing: 10) {
//            Divider()
//            
//            // Header
//            HStack {
//                Text(title)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                Spacer()
//                Button("See All") {}
//            }
//            .padding(.leading)
//            
//            // Body
//            if let characters = characters {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(alignment: .top) {
//                        ForEach(Array(characters)) { character in
//                            NavigationLink(destination: CharacterDetailsView(character: character)) {
//                                CardView(info: character)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .buttonStyle(PlainButtonStyle())
//            } else {
//                ProgressView().scaleEffect(1.5)
//            }
//        }
//        .onAppear {
//            print("\(title) Section appeared")
//            store.fetch(filterSet)
//        }
//    }
//}
//
//struct CardView: View {
//    let info: CharacterInfo
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Image("soobin")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 150, height: 150)
//                .cornerRadius(10.0)
//            Text(info.name)
//        }
//        .frame(width: 150)
//    }
//}
//
//struct CharactersView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharactersView()
//    }
//}
