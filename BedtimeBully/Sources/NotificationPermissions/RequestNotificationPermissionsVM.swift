import Foundation
import Notifications

public class RequestNotificationPermissionsVM: ObservableObject {
    @Published public var isAuthorized: Bool = false
    @Published public var error: Error?

    public let explanationString = """
    As the name of this app implies, this app is intended to bug you until you go to bed. 

    The idea is that you can use this app to help you get to bed on time.

    To do this, we need to be able to notify you when it's time to go to bed.

    If you don't want these notifications. Then you should probably delete this app.

    If you do want these notifications, please tap the accept button below to grant permission.
    """
}

