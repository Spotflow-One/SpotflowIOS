import SwiftUI

struct ViewBanksUssdPage: View {
    @State private var bank: Bank? = nil
    @State private var loading: Bool = false
    @State private var banks: [Bank] = []
    
    @EnvironmentObject var spotflowVm : SpotflowViewModel
    @EnvironmentObject var navigationVm : NavigationViewModel
    
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            // Payment Options Tile
            PaymentOptionTile(
                title: "Pay with USSD", image: Image("pay-with-ussd-icon")
            ).padding([.leading,.bottom],19)
            PaymentCard()
            

            Spacer().frame(height: 70)
            
            // USSD Icon
            Image("ussdIcon")
            
            Spacer().frame(height: 9.0)
            
            if !loading {
                // Show loading indicator if loading is true
                Spacer()
                ProgressView()
                Spacer()
            } else {
                // Display content when not loading
                Text("Choose your bank to start the payment")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(hex: "55515B"))
                
                Spacer().frame(height: 70)
                
                // Bank selection container
                Button(action: {
                    showBanksDropDown()
                }) {
                    HStack {
                        Text(bank?.name ?? "Select bank")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(bank == nil ? Color.gray : Color.primary)
                        
                        Spacer()
                    
                    }
                
                }.padding().overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                .padding(.horizontal,20)
                
                Spacer()
                HStack(spacing:12,content: {
                    CancelButton()
                    ChangePaymentButton()
                    
                }).padding(.top,24)
                    .padding(.bottom,50)
            
                
                // PCI DSS Icon
                PciDssIcon()
                
                Spacer().frame(height: 38)
            }
        }.onAppear{
            Task.detached{
                await getUssdBanks()
            }
        }.sheet(isPresented: $isSheetPresented) {
            // Content of the bottom sheet
            BottomSheetWithSearch(items: banks, onSelect: setBank)
        }
    }
    
    
    // Placeholder functions for actions
    private func showBanksDropDown() {
        isSheetPresented.toggle()
    }
    
    private func setBank(selectedBank: BaseModel?) {
        if selectedBank != nil {
           bank = selectedBank as? Bank
            isSheetPresented.toggle()
        }
    }
    
    @MainActor
    
    
    private func getUssdBanks() async {
        loading = true
        let paymentService = PaymentService(authToken: spotflowVm.spotflowUiState.paymentManager.key)
        let res = await paymentService.getUssdBanks()
        banks = res ?? []
        loading = false
    }
}


#Preview {
    ViewBanksUssdPage().environmentObject(SpotflowViewModel(paymentManager: examplePaymentManager))
        .environmentObject(NavigationViewModel())
}


