//
//  NotificationsTests.swift
//  BedtimeBullyTests
//
//  Created by Robert J. Sarvis Jr on 5/4/24.
//

import XCTest

@testable import Notifications

class NotificationServiceTests: XCTestCase {
    var notificationCenter: UNUserNotificationCenter!

    override func setUp() {
        super.setUp()
        notificationCenter = UNUserNotificationCenter.current()
    }

    func testRequestAuthorization() {
        let expectation = self.expectation(description: "Authorization")

        NotificationService.requestAuthorization { (granted, error) in
            XCTAssertTrue(granted)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testScheduleNotification() {
        let id = "testId"
        let title = "testTitle"
        let body = "testBody"
        let timestamp = Date().addingTimeInterval(60) // 1 minute from now

        let returnedId = NotificationService.scheduleNotification(id: id, title: title, body: body, timestamp: timestamp)

        XCTAssertEqual(returnedId, id)
    }
    
    func testShouldNotScheduleInThePast() {
        let id = "testId"
        let title = "testTitle"
        let body = "testBody"
        let timestamp = Date().addingTimeInterval(-60) // 1 minute ago

        let returnedId = NotificationService.scheduleNotification(id: id, title: title, body: body, timestamp: timestamp)

        XCTAssertEqual(returnedId, "")
    }

    func testCancelNotifications() {
        let id = "testId"
        let title = "testTitle"
        let body = "testBody"
        let timestamp = Date().addingTimeInterval(60) // 1 minute from now

        _ = NotificationService.scheduleNotification(id: id, title: title, body: body, timestamp: timestamp)
        NotificationService.cancelNotifications(ids: [id])

        let expectation = self.expectation(description: "Get Notifications")

        notificationCenter.getPendingNotificationRequests { (requests) in
            XCTAssertTrue(requests.allSatisfy { $0.identifier != id })
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDebugGetAllNotifications() {
        // This test is a bit tricky because the debugGetAllNotifications function doesn't return anything.
        // It just prints to the console. You might want to consider refactoring it to return a value,
        // which would make it more testable.
    }
}
