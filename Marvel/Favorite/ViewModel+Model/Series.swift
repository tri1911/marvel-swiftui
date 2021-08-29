//
//  Series.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import CoreData

extension Series {
    // A shared function to save an `ComicInfo` struct object
    // into the CoreData as a `Comic` class object.
    static func update(from info: SeriesInfo, in context: NSManagedObjectContext) {
        // Look up Series's id in Core Data
        let request = fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        // Update it if it does exist; otherwise, create a new object and add it to CoreData
        let series = results.first ?? Series(context: context)
        series.id = info.id
        series.title = info.title
        series.desc = info.description
        series.urls = info.urls
        series.startYear = Int16(info.startYear)
        series.endYear = Int16(info.endYear)
        series.rating = info.rating
        series.modified = info.modified
        series.thumbnail = info.thumbnail
        series.next = info.next
        series.previous = info.previous
        // series.objectWillChange.send()
        do {
            try context.save()
        } catch {
            print("Couldn't save Series to CoreData: \(error.localizedDescription)")
        }
    }

    // A shared function to delete a Series object in CoreData
    static func delete(_ info: SeriesInfo, in context: NSManagedObjectContext) {
        // Get the reference to object within CoreData based on its id
        let request =  fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        if let series = results.first {
            context.delete(series)
            do {
                try context.save()
            } catch {
                print("Couldn't delete character in CoreData: \(error.localizedDescription)")
            }
        }
    }

    // A shared function to check whether the comic is in favourite list.
    static func contains(_ info: SeriesInfo, in context: NSManagedObjectContext) -> Bool {
        let request = fetchRequest(NSPredicate(format: "id_ == %d", Int64(info.id)))
        let results = (try? context.fetch(request)) ?? []
        return (results.first != nil)
    }

    // Helper function which takes a predicate as an argument and returns a NSFetchRequest instance.
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Series> {
        let request = NSFetchRequest<Series>(entityName: "Series")
        // Sort the results by title as default.
        request.sortDescriptors = [NSSortDescriptor(key: "title_", ascending: true)]
        request.predicate = predicate
        return request
    }

    // Function to transform the Comic object into ComicInfo object
    func toSeriesInfo() -> SeriesInfo {
        return SeriesInfo(id: self.id, title: self.title, description: self.desc, urls: self.urls, startYear: Int(self.startYear), endYear: Int(self.endYear), rating: self.rating ?? "", modified: self.modified ?? "", thumbnail: self.thumbnail, next: self.next, previous: self.previous)
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
    
    var next: SeriesInfo.SeriesSummary? {
        get {
            guard let data = next_ else { return nil }
            return (try? JSONDecoder().decode(SeriesInfo.SeriesSummary.self, from: data)) ?? nil
        }
        set { next_ = try? JSONEncoder().encode(newValue) }
    }
    
    var previous: SeriesInfo.SeriesSummary? {
        get {
            guard let data = previous_ else { return nil }
            return (try? JSONDecoder().decode(SeriesInfo.SeriesSummary.self, from: data)) ?? nil
        }
        set { previous_ = try? JSONEncoder().encode(newValue) }
    }
}
