// RequestNotificationsPermissionView.swift
import BedtimeBullyData
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
            Text(viewModel.explanationString)
                .padding()

            Button("Accept") {
                viewModel.requestAuthorization()
            }

            if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
            }
        }
        .onReceive(viewModel.$isAuthorized) { isAuthorized in
            if isAuthorized {
                isModalPresented = false
                config?.isNotificationsEnabled = true
                config?.hasSetBedtime = true
                onAccept()
            }
        }
    }
}
