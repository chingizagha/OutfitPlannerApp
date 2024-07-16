//
//  SettingsView.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 07.07.24.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewViewModel
    
    init(viewModel: SettingsViewViewModel) {
        self.viewModel = viewModel
        
    }
    
    
    var body: some View {
        List(viewModel.cellViewModels) {viewModel in
            HStack{
                if let image = viewModel.image{
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}


