//
//  SpotflowWebView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 06/09/2024.
//

import SwiftUI
import WebKit

struct SpotflowWebView: View {
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    @EnvironmentObject var navigationVm: NavigationViewModel
    
    @State private var loading:Bool = false


    var url: URL? {
        let redirectUrl = spotflowVm.spotflowUiState.paymentResponseBody?.authorization?.redirectUrl
        return URL(string: redirectUrl ?? "")
    }
    
    var body: some View {
        if loading {
            ProgressView()
        } else {
            WebView(url: url,onURLChange: onUrlChange)

        }
    }
    
    func onUrlChange(url: URL) {
        processUrl(url: url)
    }
    
    // Processes the URL for transaction completion
     private func processUrl(url: URL) {
         if checkHasAppendedWithResponse(url: url) {
             finish()
         } else {
             checkHasCompletedProcessing(url: url)
         }
     }
     
     private func checkHasCompletedProcessing(url: URL) {
         let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
         let status = components?.queryItems?.first(where: { $0.name == "status" })?.value
         let txRef = components?.queryItems?.first(where: { $0.name == "tx_ref" })?.value
         
         if status != nil && txRef != nil {
             finish()
         }
     }
     
     private func checkHasAppendedWithResponse(url: URL) -> Bool {
         let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
         let response = components?.queryItems?.first(where: { $0.name == "response" })?.value
         
         if let response = response, let jsonData = response.data(using: .utf8) {
             if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                 let status = json["status"] as? String
                 let txRef = json["txRef"] as? String
                 return status != nil && txRef != nil
             }
         }
         return false
     }
     
  
     private func finish() {
         Task {
             await checkPaymentStatus()
         }
         
     }
     
    private func checkPaymentStatus() async {
        loading = true
        await verifyPayment()
        loading = false
    }
    
    private func verifyPayment() async {
        let paymentManager = spotflowVm.spotflowUiState.paymentManager
        let paymentService = PaymentService(authToken: paymentManager.key)
        if let paymentReference = spotflowVm.spotflowUiState.paymentResponseBody?.reference {
            if let paymentResponse = await paymentService.verifyPayment(reference: paymentReference, merchantId: paymentManager.merchantId) {
                spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponse)
                if(paymentResponse.status == "successful") {
                    navigationVm.goToSuccess()
                } else if(paymentResponse.status == "failed") {
                    navigationVm.goToError()
                }
            } else {
                navigationVm.goToError()
            }
        }
       
    }
    
}
struct WebView: UIViewRepresentable {
    var url: URL?
    var onURLChange: (URL) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_
 uiView: WKWebView, context: Context) {
        if let url = url
 {
            uiView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView


        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
 {
            if let url = webView.url {
                parent.onURLChange(url)
            }
        }
    }
}

#Preview {
    SpotflowWebView().environmentObject(SpotflowViewModel(paymentManager: examplePaymentManager))
}
