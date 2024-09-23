//
//  BottomSheetWithSearch.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 08/09/2024.
//

import SwiftUI

struct BottomSheetWithSearch: View {
    let items: [BaseModel]
    let onSelect: (BaseModel) -> Void
    
    @State private var searchText: String = ""
    
    
    var filteredItems: [BaseModel] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            // Search bar
            TextField("Search", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 8)
            
            // List of items
            List(filteredItems, id: \.name) { item in
                Button(action: {
                    onSelect(item)
                }) {
                    Text(item.name)
                        .foregroundStyle(.black)
                        .listRowBackground(Color.green)
                        
                }
            }.listStyle(.plain)
            
        
        }.background(.white)
    
    }
}


#Preview {
    BottomSheetWithSearch(items: [BaseModel(name: "Hello"),BaseModel(name: "Just")], onSelect: { base in
        print(base.name)
    })
}
