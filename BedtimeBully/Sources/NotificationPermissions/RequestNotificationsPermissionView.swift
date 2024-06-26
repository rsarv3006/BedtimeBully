import BedtimeBullyData
import Notifications
import SwiftUI

public struct RequestNotificationsPermissionView: View {
    @ObservedObject private var viewModel: RequestNotificationPermissionsVM
    @Binding public var isModalPresented: Bool
    public let onAccept: () -> Void
    public var config: Config?

    public init(isModalPresented: Binding<Bool>,
                config: Config?,
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
                        if isAuthorized {
                            isModalPresented = false
                            config?.isNotificationsEnabled = true
                            config?.hasSetBedtime = true
                            onAccept()
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
