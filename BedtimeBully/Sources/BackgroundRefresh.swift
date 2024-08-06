import BackgroundTasks
import BedtimeBullyData
import Foundation
import Notifications
import SwiftUI

public class BackgroundRefresh: ObservableObject {
    private let appDb: AppDatabase
    private let notificationCenter = NotificationService.center
    static let backgroundTaskIdentifier = "com.rjs.app.dev.BedtimeBully.refreshBedtimeNotifications"

    init(appDb: AppDatabase) {
        self.appDb = appDb
    }
    
    func handleAppRefresh() throws {
        let config = try appDb.getConfig()

        if config?.isNotificationsEnabled == true {
            try appDb.removeBedtimesAndNotificationsInThePast(currentDate: Date())
            try appDb.addBedtimesFromSchedule()
        }
    }

    func registerBackgroundRefresh() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BackgroundRefresh.backgroundTaskIdentifier, using: nil) { task in
            try? self.handleAppRefresh()
            task.setTaskCompleted(success: true)
            self.scheduleBackgroundRefresh()
        }
    }

    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 2)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background refresh: \(error.localizedDescription)")
        }
    }
}
