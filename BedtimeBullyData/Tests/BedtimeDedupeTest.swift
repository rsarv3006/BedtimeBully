
import XCTest
@testable import BedtimeBullyData

final class BedtimeDedupeTest: XCTestCase {

    func testExample() throws {
        let things = [
            VeryImportantThings(id: 1),
            VeryImportantThings(id: 2),
            VeryImportantThings(id: 3),
            VeryImportantThings(id: 1),
            VeryImportantThings(id: 2),
            VeryImportantThings(id: 3),
        ]
        
        let dedupedThings = deduplicateThings(things: things)
        
        XCTAssertEqual(dedupedThings.count, 3)

    }    
    
    func testExample1() throws {
        let things = [
            VeryImportantThings(id: 1),
            VeryImportantThings(id: 2),
            VeryImportantThings(id: 3),
            VeryImportantThings(id: 1),
            VeryImportantThings(id: 2),
            VeryImportantThings(id: 3),
        ]
        
        let dedupedThings = deduplicateThingsSet(things: things)
        
        XCTAssertEqual(dedupedThings.count, 3)

    }

    func testPerformanceExample() throws {
        var things: [VeryImportantThings] = []
        
        for i in 0...14_400_000 {
            if i % 2 == 0 {
                things.append(VeryImportantThings(id: TimeInterval(i - 1)))
            }
            things.append(VeryImportantThings(id: TimeInterval(i)))
        }
        
        self.measure {
            print(things.count)
            // let _ = deduplicateThings(things: things) // 1.120 - 5800
//            let _ = deduplicateThingsSet(things: things) // .00272 - 5800
            let _ = deduplicateThingsSet(things: things) // 1.229 - 6000002
        }
    }

}
