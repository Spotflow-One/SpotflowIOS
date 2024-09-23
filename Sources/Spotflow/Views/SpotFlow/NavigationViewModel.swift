import SwiftUI

// Define your navigation state in an ObservableObject
class NavigationViewModel: ObservableObject {
    // A simple navigation state
    @Published var navigationPath : [Destination] = [.home]
    
    // Enum to represent different views or destinations
    enum Destination : Hashable {
        case home
        case enterCardDetails
        case enterCardPin
        case enterCardOtp
        case transferHome
        case transferInfo
        case success
        case error
        case transferStatusCheck
        case spotflowWebView
        case viewBanksUssdView, enterBillingAddress
    }
    
    var currentPath: Destination {
        navigationPath.last ?? .home
    }
    
    // Navigation methods
    func goToHome() {
        self.navigationPath.removeLast()
        navigationPath.append(Destination.home)
        
    }
    
    func goToEnterCardDetails() {
            navigationPath.append(Destination.enterCardDetails)
        }

        func goToEnterCardPin() {
            navigationPath.append(Destination.enterCardPin)
        }

        func goToEnterCardOtp() {
            navigationPath.append(Destination.enterCardOtp)
        }

        func goToTransferHome() {
            navigationPath.append(Destination.transferHome)
        }

        func goToTransferInfo() {
            navigationPath.append(Destination.transferInfo)
        }

        func goToSuccess() {
            navigationPath.append(Destination.success)
        }

        func goToError() {
            navigationPath.append(Destination.error)
        }

        func goToTransferStatusCheck() {
            navigationPath.append(Destination.transferStatusCheck)
        }
    
    func goToSpotflowWebView() {
        navigationPath.append(Destination.spotflowWebView)
    }
    
    func goToViewBanksUssdView() {
        navigationPath.append(Destination.viewBanksUssdView)
    }
    
    
    func handleCardSuccessNavigation(paymentResponseBody:PaymentResponseBody) {
                if paymentResponseBody.status == "successful" {
                            goToSuccess()
                } else if paymentResponseBody.authorization?.mode == "pin" {
                   goToEnterCardPin()
                } else if paymentResponseBody.authorization?.mode == "otp" {
                        goToEnterCardOtp()
                } else if paymentResponseBody.authorization?.mode == "3DS" {
                    goToSpotflowWebView()
                } else if paymentResponseBody.authorization?.mode == "avs" {
                    goToEnterBillingAddress()
                }else {
                   goToError()
                }
    }
    
    private func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func goToEnterBillingAddress()
        {
            navigationPath.append(Destination.enterBillingAddress)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
}


struct DetailView: View {
    var body: some View {
        Text("Detail View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}
