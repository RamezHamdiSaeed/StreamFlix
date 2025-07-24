//
//  MovieEntity+CoreDataProperties.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//
//

import Foundation
import CoreData

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var poster: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var overview: String?
    @NSManaged public var language: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var sections: NSSet?

}

// MARK: Generated accessors for sections
extension MovieEntity {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: SectionEntity)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: SectionEntity)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}

extension MovieEntity: Identifiable {
}
