import BedtimeBullyData
import Notifications
import SwiftUI

public struct RequestNotificationsPermissionView: View {
    @Environment(\.appDatabase) private var appDatabase
    @ObservedObject private var viewModel: RequestNotificationPermissionsVM
    @Binding public var isModalPresented: Bool
    public let onAccept: () -> Void
    public var config: GRDBConfig?

    public init(isModalPresented: Binding<Bool>,
                config: GRDBConfig?,
                onAccept: @escaping () -> Void)
    {
        viewModel = RequestNotificationPermissionsVM()
        _isModalPresented = isModalPresented
        self.onAccept = onAccept
        self.config = config
    }

    public var body: some View {
        VStack {
            Spacer()

            Text(viewModel.explanationString)
                .padding()

            Button("Accept") {
                NotificationService.requestAuthorization { isAuthorized, error in
                    DispatchQueue.main.async {
                        viewModel.error = error
                        
                        do {
                        if isAuthorized {
                            try appDatabase.updateConfig(isNotificationsEnabled: true, hasSetBedtime: true)
                            isModalPresented = false
                            onAccept()
                        }
                        } catch {
                            viewModel.error = error
                        }
                    }
                }
            }

            if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundStyle(.red)
            }

            Spacer()

            HStack {
                Spacer()
            }
        }
        .appBackground()
    }
}
