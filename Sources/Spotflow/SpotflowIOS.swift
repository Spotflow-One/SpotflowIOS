import SwiftUI


public struct SpotFlow: View {
     private var navigationVM: NavigationViewModel
     private var spotflowViewModel: SpotflowViewModel
    
    public init() {
        self.navigationVM = NavigationViewModel()
        self.spotflowViewModel =  SpotflowViewModel(paymentManager: examplePaymentManager)
    }
    
    public var body: some View {
        SpotflowContentView().environmentObject(navigationVM).environmentObject(spotflowViewModel)
    }
}
