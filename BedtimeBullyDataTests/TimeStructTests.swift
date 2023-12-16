//
//  TimeStructTests.swift
//  BedtimeBullyDataTests
//
//  Created by Robert J. Sarvis Jr on 12/15/23.
//

import XCTest

final class TimeStructTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testInitHourAndMinute() throws {
        let time = try Time(hour: 15, minute: 30)
        XCTAssertEqual(time.hour, 15)
        XCTAssertEqual(time.minute, 30)
    }
    
    func testInitializationErrors() {
        XCTAssertThrowsError(try Time(hour: -1, minute: 30))
        XCTAssertThrowsError(try Time(hour: 24, minute: 30))
        XCTAssertThrowsError(try Time(hour: 15, minute: -1))
        XCTAssertThrowsError(try Time(hour: 15, minute: 60))
    }
    
    func testInitFromDate() throws {
        let now = Date()
        let time = try Time(date: now)
        let hour = Calendar.current.component(.hour, from: now)
        let minute = Calendar.current.component(.minute, from: now)
        XCTAssertEqual(time.hour, hour)
        XCTAssertEqual(time.minute, minute)
    }
    
    func testToDate() throws {
        let date = Date()
        let time = try Time(hour: 12, minute: 30)
       
        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 30)
        
        let converted = try time.toDate(baseDate: date)
        print(converted)
        XCTAssertEqual(Calendar.current.component(.hour, from: converted), 12)
        XCTAssertEqual(Calendar.current.component(.minute, from: converted), 30)
    }
    
    func testPerformanceDateConversion() throws {
        let baseDate = Date()
        let time = try! Time(hour: 12, minute: 30)
        
        measure {
            for _ in 1...10_000 {
                let _ = try! time.toDate(baseDate: baseDate)
            }
            
        }

    }
    
}
