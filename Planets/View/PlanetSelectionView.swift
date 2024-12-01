//
//  PlanetSelectionView.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//

import SwiftUI
struct PlanetSelectionView: View {
    @EnvironmentObject private var selectedPlanet: SelectedPlanet
    @Environment(\.dismiss) private var dismiss
    var onPlanetSelect: (Int) -> Void


    
    var body: some View {
        NavigationView {
            List(PlanetModel.planets.indices, id: \.self) { index in
                Button(action: {
                    onPlanetSelect(index)
                }) {
                    HStack {
                        Text(PlanetModel.planets[index].name)
                        Spacer()
                        if index == selectedPlanet.selectePlanet {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select a Planet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
