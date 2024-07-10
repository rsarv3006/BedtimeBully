import Foundation

public class PurchasesScreenViewModel: ObservableObject {
    @Published var isPurchased = false
    @Published var isLoading = false
    @Published var isShowingError = false
    @Published var errorTitle = ""
    @Published var showPurchaseSuccesModal = false
    @Published var isRestorePurchasesLoading = false
}
