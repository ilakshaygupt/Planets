//
//  PlanetsApp.swift
//  Planets
//
//  Created by Lakshay Gupta on 26/11/24.
//

import SwiftUI

@main
struct PlanetsApp: App {
    @State var currentPlanet =  SelectedPlanet()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(currentPlanet)
        }
    }
}
