//
//  EnterBillingAddressView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 06/09/2024.
//

import SwiftUI

struct EnterBillingAddressView: View {
    
    @EnvironmentObject  var spotflowVm: SpotflowViewModel

    @State private var creatingPayment = false
    @State private var address = ""
    @State private var country: Country? = nil
    @State private var countryState: CountryState? = nil
    @State private var city: City? = nil
    @State private var zipCode = ""
    @State private var buttonEnabled = false
    
    @State private var countryList: [Country] = []
    @State private var stateList: [CountryState] = []
    @State private var cityList: [City] = []
    

    
    @State private var isCountrySheetPresented = false
    @State private var isStateSheetPresented = false
    @State private var isCitySheetPresented = false

    
    var body: some View {
        if creatingPayment {
            // Show loading indicator when creating payment
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            VStack {
                PaymentOptionTile(
                    title: "Pay with Card", image: Image("pay-with-card-icon")
                ).padding([.leading,.bottom],19)
                PaymentCard()
                
                // Title
                Text("Fill in Your Billing Address")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("tone70"))
                
                Spacer().frame(height: 34)
                
                // Address input field
                CardTextField(
                    username: $address,
                    label: "Address",
                    hintText: "Osapa London"
                )
                
//                TextField("Osapa London", text: $address, onEditingChanged: { _ in
//                    onAddressChanged()
//                })
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.default)
//                .padding()
                
                Spacer().frame(height: 28)
                
                // Country and State dropdowns
                HStack {
                    // Country dropdown
                    Button(action: {
                        showCountryDropdown()
                    }) {
                        Text(country?.name ?? "Enter country")
                            .foregroundColor(.gray)
                            
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.leading,.trailing], 8)
                    .padding(.vertical,8)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 2))
                       
                    
                    Spacer()
                        .frame(maxWidth:32)
                    
                    // State dropdown
                    Button(action: {
                        showStateDropDown()
                    }) {
                        Text(countryState?.name ?? "Enter state")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.leading,.trailing], 8)
                    .padding(.vertical,8)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 2))
                }
                .padding()
                
                Spacer().frame(height: 28)
                
                // City and Zipcode input fields
                HStack {
                    // City dropdown
                    Button(action: {
                        showCityDropDown()
                    }) {
                        Text(city?.name ?? "Enter city")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.leading,.trailing], 8)
                    .padding(.vertical,8)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 2))
                       
                    
                    Spacer().frame(width: 32)
                    
//                    // Zipcode input field
//                    TextField("000 000", text: $zipCode, onEditingChanged: { _ in
//                        onAddressChanged()
//                    })
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.numberPad)
//                    .frame(maxWidth: .infinity)
                    CardTextField(
                        username: $address,
                        label: "Zip code",
                        hintText: "000 000"
                    )
                    
                }
                .padding()
                
                Spacer().frame(height: 28)
                
          
                
                Spacer().frame(height: 60)
                
                Button(action: {
                    Task {
                        await createPayment()
                    }
                          }) {
                              Text("Submit")
                                  .padding()
                                  .frame(maxWidth:.infinity)
                                  .background(!buttonEnabled ? Color(hex:"F4F4FF") : Color(hex: "01008E"))
                                  .foregroundStyle(!buttonEnabled ? Color(hex:"AAAAD9") : .white)
                                  .cornerRadius(4)
                                  .font(.system(size: 14,weight: .medium))
                          }
                          .disabled(!buttonEnabled)
                          .padding()
                
                HStack(spacing:12,content: {
                    CancelButton()
                    ChangePaymentButton()
                    
                })
                .padding([.leading,.trailing],16)
                .padding(.top,60)
                
                // PCI DSS Icon
                PciDssIcon()
                
                Spacer().frame(height: 38)
                
            }
            
            
        }
    }
        
        private func onAddressChanged() {
            
        }
         private func showCountryDropdown() {
            
        } 
    
        private func showCityDropDown() {
            
        }
        private func showStateDropDown() {
            
        }
    
    
        
    
    private func createPayment() async {
        
    }
}

#Preview {
    EnterBillingAddressView().environmentObject(NavigationViewModel()).environmentObject(SpotflowViewModel(paymentManager: examplePaymentManager))
}
