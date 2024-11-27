//
//  MainView.swift
//  Planets
//
//  Created by Lakshay Gupta on 26/11/24.
//

import SwiftUI
import SceneKit




struct MainView: View {
    @State private var isExpandedView = false
    @EnvironmentObject private var selectedPlanet : SelectedPlanet
    @State private var showPlanetSelection = false



    var currentPlanet: PlanetModel {
        PlanetModel.planets[selectedPlanet.selectePlanet]
    }

    var body: some View {
        NavigationStack {
        ZStack {
            Color(hex: currentPlanet.backgroundColor)
                .ignoresSafeArea()

            VStack(){
                Spacer()
                Text(currentPlanet.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(currentPlanet.nickName)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                SCNModelView( scnFileName: "Solar_System")
                    .frame(
                        width: isExpandedView ? getScreenBounds().width : 500,
                        height: isExpandedView ? .infinity : 500
                    )
                    
                    .position(x:200,y:200)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                    .animation(.easeInOut(duration: 0.5), value: isExpandedView)
            }

                VStack(alignment: .center, spacing: 16) {

                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Radius", value: currentPlanet.properties.radius)
                        InfoRow(label: "Distance from Sun", value: currentPlanet.properties.distanceFromSun)
                        InfoRow(label: "Moons", value: currentPlanet.properties.moons)
                        InfoRow(label: "Gravity", value:currentPlanet.properties.gravity)
                        InfoRow(label: "Tilt of Axis", value: currentPlanet.properties.tiltOfAxis)
                        InfoRow(label: "Length of Year", value: currentPlanet.properties.lengthOfYear)
                        InfoRow(label: "Length of Day", value: currentPlanet.properties.lengthofDay)
                        InfoRow(label: "Temperature", value: currentPlanet.properties.temperature)
                    }
                    .padding(EdgeInsets(top: 60, leading: 8, bottom: 0, trailing: 0))
                    .frame(width:getScreenBounds().width,height: getScreenBounds().height * 0.5)
                    .background(
                        Color.black.opacity(1)
                    )
                    .clipShape(InwardCurvedShape())
                    .opacity(isExpandedView ? 0 : 1) 
                    .offset(y: isExpandedView ? 300 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isExpandedView)


                }
                .animation(.bouncy(duration: 2), value: isExpandedView)


            Button(
                action: {
                    withAnimation {
                        isExpandedView.toggle()
                    }
                }
            )
            {
                VStack(spacing:0){
                    HStack(spacing:0){
                        Image(systemName: "arrow.up.left")
                        Image(systemName: "arrow.up.right")
                    }
                    HStack(spacing:0){
                        Image(systemName: "arrow.down.left")
                        Image(systemName: "arrow.down.right")
                    }
                }
                .foregroundStyle(.black)
                .padding()
                .background(Color(hex: 0xe5cba1))
                .clipShape(Circle())
            }
            .position(x:50,y: 450)
            Button(action: {
                showPlanetSelection.toggle()
            }) {
                Text("sakjasbdjkbasdb")
                    .foregroundStyle(.black)
                    .zIndex(1000)
            }
            .position(x:50,y: 400)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

        .sheet(isPresented: $showPlanetSelection) {
            PlanetSelectionView()
        }



    }
}


#Preview{
    MainView()
        .environmentObject(SelectedPlanet())

}
struct PlanetSelectionView: View {
    @EnvironmentObject private var selectedPlanet: SelectedPlanet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(PlanetModel.planets.indices, id: \.self) { index in
                Button(action: {
                    selectedPlanet.selectePlanet = index
                    dismiss()
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
