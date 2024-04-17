// RequestNotificationPermissionsVM.swift
import Foundation
import Notifications

public class RequestNotificationPermissionsVM: ObservableObject {
    @Published public var isAuthorized: Bool = false
    @Published public var error: Error?

    public let explanationString = """
    As the name of this app implies, this app is intended to bug you until you go to bed.

    If you don't want these notifications. Then you should probably delete this app.

    If you do want these notifications, please tap the accept button below to grant permission.
    """

    public func requestAuthorization() {
        NotificationService.requestAuthorization { [weak self] isAuthorized, error in
            DispatchQueue.main.async {
                self?.isAuthorized = isAuthorized
                self?.error = error
            }
        }
    }
}

