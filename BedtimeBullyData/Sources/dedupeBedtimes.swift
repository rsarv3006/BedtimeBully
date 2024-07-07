import Foundation

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
public func deduplicateBedtimes(things: [Bedtime]) -> [Bedtime] {
    var bedtimes: [Bedtime] = []
    var idsFound: [TimeInterval] = []
    
    for bedtime in things {
        let idInList = idsFound.firstIndex(of: bedtime.id)
        
        if idInList == nil {
            idsFound.append(bedtime.id)
            bedtimes.append(bedtime)
        }
    }
    
    return bedtimes
}

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
public func deduplicateThings(things: [VeryImportantThings]) -> [VeryImportantThings] {
    var bedtimes: [VeryImportantThings] = []
    var idsFound: [TimeInterval] = []
    
    for bedtime in things {
        let idInList = idsFound.firstIndex(of: bedtime.id)
        
        if idInList == nil {
            idsFound.append(bedtime.id)
            bedtimes.append(bedtime)
        }
    }
    
    return bedtimes
}

public struct VeryImportantThings {
    let id: TimeInterval
}

public func deduplicateThingsSet(things: [VeryImportantThings]) -> [VeryImportantThings] {
    var veryImportantThings: [VeryImportantThings] = []
    var idsFound = Set<TimeInterval>()
    
    for thing in things {
        let idInList = idsFound.insert(thing.id).inserted
        
        if idInList {
            veryImportantThings.append(thing)
        }
    }
    
    return veryImportantThings
}
