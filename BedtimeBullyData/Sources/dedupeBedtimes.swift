import Foundation

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
