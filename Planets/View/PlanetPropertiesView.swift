//
//  PlanetPropertiesView.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//
import SwiftUI


struct PlanetPropertiesView: View {
    @EnvironmentObject private var selectedPlanet: SelectedPlanet

    var currentPlanet: PlanetModel {
        PlanetModel.planets[selectedPlanet.selectePlanet]
    }

    var body : some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(label: "Radius", value: currentPlanet.properties.radius)
            InfoRow(
                label: "Distance from Sun",
                value: currentPlanet.properties.distanceFromSun)
            InfoRow(label: "Moons", value: currentPlanet.properties.moons)
            InfoRow(label: "Gravity", value: currentPlanet.properties.gravity)
            InfoRow(label: "Tilt of Axis", value: currentPlanet.properties.tiltOfAxis)
            InfoRow(
                label: "Length of Year", value: currentPlanet.properties.lengthOfYear)
            InfoRow(label: "Length of Day", value: currentPlanet.properties.lengthofDay)
            InfoRow(label: "Temperature", value: currentPlanet.properties.temperature)
        }
    }
}

struct PlanetPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetPropertiesView()
            .environmentObject(SelectedPlanet())
    }
}
