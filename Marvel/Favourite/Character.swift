//
//  Character.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-23.
//

import CoreData

extension Character {
    // A shared function to save an CharacterInfo struct object
    // into the CoreData as a Character class object.
    static func update(from info: CharacterInfo, in context: NSManagedObjectContext) {
//        // Look up character's id in Core Data
//        let request = fetchRequest(NSPredicate(format: "id_ = %@", info.id))
//        let results = (try? context.fetch(request)) ?? []
//        // Update it if it does exist; otherwise, create a new object and add it to CoreData
//        let character = results.first ?? Character(context: context)
        let character = Character(context: context)
        character.id = info.id
        character.name = info.name
        character.desc = info.description
        character.modified = info.modified
        character.urls = info.urls
        character.thumbnail = info.thumbnail.url
        character.objectWillChange.send()
        // Save changes.
        do {
            try context.save()
        } catch {
            print("Couldn't save character update to CoreData: \(error.localizedDescription)")
        }
    }
    
    // A shared function to delete a Character object in CoreData
    static func delete(_ character: Character, context: NSManagedObjectContext) {
        // Get the reference to object within CoreData based on its id
//        let request =  fetchRequest(NSPredicate(format: "id_ = %@", Int64(info.id)))
//        let results = (try? context.fetch(request)) ?? []
//        if let character = results.first {
            context.delete(character)
            do {
                try context.save()
            } catch {
                print("Couldn't delete character in CoreData: \(error.localizedDescription)")
            }
//        }
    }
    
    // Helper function which takes a predicate as an argument and returns a NSFetchRequest instance.
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Character> {
        let request = NSFetchRequest<Character>(entityName: "Character")
        // Sort the results by name as default.
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Syntactic Sugar
    
    public var id: Int {
        get { Int(id_) }
        set { id_ = Int64(newValue) }
    }
    
    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue }
    }
    
    var urls: [MarvelURL] {
        get {
            guard let data = urls_ else { return [] }
            return (try? JSONDecoder().decode([MarvelURL].self, from: data)) ?? []
        }
        set { urls_ = try? JSONEncoder().encode(newValue) }
    }
}
