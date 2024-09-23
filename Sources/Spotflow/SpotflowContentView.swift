//
//  ContentView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct SpotflowContentView: View {
    @EnvironmentObject  var navigationVM: NavigationViewModel
    
    var body: some View {

        switch navigationVM.currentPath {
        case .enterCardDetails:
            EnterCardDetail()
                .navigationBarBackButtonHidden(true)
        case .enterCardOtp:
            EnterCardOtp()
                .navigationBarBackButtonHidden(true)
        case .enterCardPin:
            EnterCardPin()
                .navigationBarBackButtonHidden(true)
        case .home:
            HomeView()
                .navigationBarBackButtonHidden(true)
        case .error:
            ErrorPage()
                .navigationBarBackButtonHidden(true)
        case .success:
            SuccessPage()
                .navigationBarBackButtonHidden(true)
        case .transferHome:
            TransferHomeView()
                .navigationBarBackButtonHidden(true)
        case .transferInfo:
            TransferInfoView()
                .navigationBarBackButtonHidden(true)
        case .transferStatusCheck:
            TransferStatusCheckPage()
                .navigationBarBackButtonHidden(true)
        case .spotflowWebView:
            SpotflowWebView()
                .navigationBarBackButtonHidden(true)
        case .viewBanksUssdView:
            ViewBanksUssdPage().navigationBarBackButtonHidden(true)
        case .enterBillingAddress:
            EnterBillingAddressView().navigationBarBackButtonHidden(true)
            
        }
            
  
       
    }
}

#Preview {
    SpotflowContentView()
}
