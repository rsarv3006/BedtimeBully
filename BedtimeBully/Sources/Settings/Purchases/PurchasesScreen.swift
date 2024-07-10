import StoreKit
import SwiftUI

struct PurchasesScreen: View {
    @EnvironmentObject() private var storekitStore: StorekitStore

    @StateObject private var viewModel: PurchasesScreenViewModel

    public init() {
        _viewModel = StateObject(wrappedValue: PurchasesScreenViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    Button(action: {
                        Task {
                            if let product = storekitStore.unlockBedtimeSchedule {
                                viewModel.isLoading = true
                                await buy(product: product)
                                viewModel.isLoading = false
                                viewModel.showPurchaseSuccesModal = true
                            } else {
                                viewModel.errorTitle = "Product not found"
                                viewModel.isShowingError = true
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Unlock Weekly Bedtime Schedule")
                        }
                    }
                    .padding(.vertical)

                    Button(action: {
                        Task {
                            viewModel.isRestorePurchasesLoading = true
                            try? await AppStore.sync()
                            viewModel.isRestorePurchasesLoading = false
                        }
                    }) {
                        if viewModel.isRestorePurchasesLoading {
                            ProgressView()
                        } else {
                            Text("Restore Purchases")
                        }
                    }
                    .padding(.bottom)
                }
                .alert(isPresented: $viewModel.isShowingError, content: {
                    Alert(title: Text(viewModel.errorTitle), message: nil, dismissButton: .default(Text("Okay")))
                })
                .alert(isPresented: $viewModel.showPurchaseSuccesModal, content: {
                    Alert(title: Text("Purchase Successful"), message: nil, dismissButton: .default(Text("Okay")))
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
                    viewModel.isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            viewModel.errorTitle = "Your purchase could not be verified by the App Store."
            viewModel.isShowingError = true
        } catch {
            print("Failed purchase for \(String(describing: product.id)): \(error)")
        }
    }
}
