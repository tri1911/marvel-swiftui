//
//  Comic.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-25.
//

import CoreData

extension Comic {
    // A shared function to save an `ComicInfo` struct object
    // into the CoreData as a `Comic` class object.
    static func update(from info: ComicInfo, in context: NSManagedObjectContext) {
        // Look up Comic's id in Core Data
        let request = fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        // Update it if it does exist; otherwise, create a new object and add it to CoreData
        let comic = results.first ?? Comic(context: context)
        comic.id = info.id
        comic.title = info.title
        comic.desc = info.description
        comic.modified = info.modified
        comic.isbn = info.isbn
        comic.format = info.format
        comic.pageCount = Int16(info.pageCount)
        comic.urls = info.urls
        comic.thumbnail = info.thumbnail
        comic.images = info.images
        // comic.objectWillChange.send()
        do {
            try context.save()
        } catch {
            print("Couldn't save Comic to CoreData: \(error.localizedDescription)")
        }
    }
    
    // A shared function to delete a Comic object in CoreData
    static func delete(_ info: ComicInfo, in context: NSManagedObjectContext) {
        // Get the reference to object within CoreData based on its id
        let request =  fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        if let comic = results.first {
            context.delete(comic)
            do {
                try context.save()
            } catch {
                print("Couldn't delete character in CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    // A shared function to check whether the comic is in favourite list.
    static func contains(_ info: ComicInfo, in context: NSManagedObjectContext) -> Bool {
        let request = fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        return (results.first != nil)
    }
    
    // Helper function which takes a predicate as an argument and returns a NSFetchRequest instance.
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Comic> {
        let request = NSFetchRequest<Comic>(entityName: "Comic")
        // Sort the results by title as default.
        request.sortDescriptors = [NSSortDescriptor(key: "title_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    // Function to transform the Comic object into ComicInfo object
    func toComicInfo() -> ComicInfo {
        return ComicInfo(id: self.id, title: self.title, description: self.desc, modified: self.modified ?? "", isbn: self.isbn ?? "", format: self.format ?? "", pageCount: Int(self.pageCount), urls: self.urls, thumbnail: self.thumbnail, images: self.images)
    }
    
    // MARK: - Syntactic Sugar
    
    public var id: Int {
        get { Int(id_) }
        set { id_ = Int64(newValue) }
    }
    
    var title: String {
        get { title_ ?? "Unknown" }
        set { title_ = newValue }
    }
    
    var thumbnail: MarvelImage {
        get {
            let emptyImage = MarvelImage(path: "", extension: "")
            guard let data = thumbnail_ else { return emptyImage }
            return (try? JSONDecoder().decode(MarvelImage.self, from: data)) ?? emptyImage
        }
        set { thumbnail_ = try? JSONEncoder().encode(newValue) }
    }
    
    var urls: [MarvelURL] {
        get {
            guard let data = urls_ else { return [] }
            return (try? JSONDecoder().decode([MarvelURL].self, from: data)) ?? []
        }
        set { urls_ = try? JSONEncoder().encode(newValue) }
    }
    
    var images: [MarvelImage] {
        get {
            guard let data = images_ else { return [] }
            return (try? JSONDecoder().decode([MarvelImage].self, from: data)) ?? []
        }
        set { images_ = try? JSONEncoder().encode(newValue) }
    }
}
