import BackgroundTasks
import BedtimeBullyData
import Foundation
import Notifications
import SwiftUI

public class BackgroundRefresh: ObservableObject {
    private let appDb: AppDatabase
    private let notificationCenter = NotificationService.center
    static let backgroundTaskIdentifier = "rjs.app.dev.BedtimeBully.refreshBedtimeNotifications"

    init(appDb: AppDatabase) {
        self.appDb = appDb
    }

    func handleAppRefresh() throws {
        print("handleAppRefresh")
        let config = try appDb.getConfig()

        if config?.isNotificationsEnabled == true {
            try appDb.removeBedtimesAndNotificationsInThePast(currentDate: Date())
            try appDb.addBedtimesFromSchedule()
        }
    }

    func registerBackgroundRefresh() {
        print(UIApplication.shared.backgroundRefreshStatus.rawValue)
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BackgroundRefresh.backgroundTaskIdentifier, using: nil) { task in
            do {
                try self.handleAppRefresh()
            } catch {
                print("Could not handle background refresh: \(error.localizedDescription)")
            }

            print("Completed background refresh")
            task.expirationHandler = {
                print("Expired background refresh")
                task.setTaskCompleted(success: false)
            }
            task.setTaskCompleted(success: true)
        }
        scheduleBackgroundRefresh()
    }

    func scheduleBackgroundRefresh() {
        print(UIApplication.shared.backgroundRefreshStatus.rawValue)
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskIdentifier)
        // request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 2)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled background refresh")
        } catch {
            print("Could not schedule background refresh: \(error.localizedDescription)")
        }

        print(BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: { pendingTaskRequests in
            print("Pending task requests: \(pendingTaskRequests)")
        }))
    }
}
