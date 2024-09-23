//
//  SuccessPage.swift
//  SpotFlowPlayground
//


import SwiftUI

struct SuccessPage: View {
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    
    var spotflowUiState: SpotFlowUIState  {
         spotflowVm.spotflowUiState
    }
    
    var paymentManager: SpotFlowPaymentManager {
        spotflowUiState.paymentManager
    }
    
    var rate: Rate? {
        spotflowUiState.rate
    }

    var body: some View {
        Text("successMessage")
    }
}


#Preview {
    SuccessPage()
}
