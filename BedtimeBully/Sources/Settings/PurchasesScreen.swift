import StoreKit
import SwiftUI

struct PurchasesScreen: View {
    @EnvironmentObject() private var storekitStore: StorekitStore

    @State private var isPurchased = true
    @State private var isLoading = false
    @State private var isShowingError = false
    @State private var errorTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    Button(action: {
                        Task {
                            if let product = storekitStore.unlockBedtimeSchedule {
                                isLoading = true
                                await buy(product: product)
                                isLoading = false
                            } else {
                                errorTitle = "Product not found"
                                isShowingError = true
                            }
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Unlock Weekly Bedtime Schedule")
                        }
                    }
                    .padding(.vertical)

                    Button(action: {
                        Task {
                            try? await AppStore.sync()
                        }
                    }) {
                        Text("Restore Purchases")
                    }
                    .padding(.bottom)
                }
                .alert(isPresented: $isShowingError, content: {
                    Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
                })

                .frame(maxWidth: 350)

                HStack {
                    Spacer()
                }
            }
            .appBackground()
            .navigationTitle("Purchases")
        }
    }

    func buy(product: Product) async {
        do {
            if try await storekitStore.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(String(describing: product.id)): \(error)")
        }
    }
}
