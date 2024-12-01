//
//  MainView.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//
import SceneKit
import SwiftUI

struct MainView: View {
    @State private var isZoomingIn = false
    @State private var isExpandedView = false
    @EnvironmentObject private var selectedPlanet: SelectedPlanet
    @State private var showPlanetSelection = false
    @State private var currentScene: String = "Solar_System" 

    var currentPlanet: PlanetModel {
        PlanetModel.planets[selectedPlanet.selectePlanet]
    }

    func resetView() {
        withAnimation {
            isZoomingIn = false
        }
        currentScene = "Solar_System"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: currentPlanet.backgroundColor)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Text(currentPlanet.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text(currentPlanet.nickName)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    SCNModelView(scnFileName: $currentScene)
                        .frame(
                            width: isZoomingIn ? getScreenBounds().width : 500,
                            height: isZoomingIn ? .infinity : 500
                        )
                        .position(x: 200, y: 200)
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                        .animation(.easeInOut(duration: 0.5), value: isZoomingIn)
                }

                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    PlanetPropertiesView()
                    .padding(EdgeInsets(top: 60, leading: 8, bottom: 0, trailing: 0))
                    .frame(width: getScreenBounds().width, height: getScreenBounds().height * 0.5)
                    .background(
                        Color.black.opacity(1)
                    )
                    .clipShape(InwardCurvedShape())
                    .opacity(isZoomingIn ? 0 : 1)
                    .offset(y: isZoomingIn ? 300 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isZoomingIn)
                }
                .animation(.bouncy(duration: 2), value: isZoomingIn)

                Button(
                    action: {
                        withAnimation {
                            isZoomingIn.toggle()
                        }
                    }
                ) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.up.left")
                            Image(systemName: "arrow.up.right")
                        }
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.down.left")
                            Image(systemName: "arrow.down.right")
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color(hex: 0xe5cba1))
                    .clipShape(Circle())
                }
                .position(x: 50, y: 450)

                Button(action: {
                    showPlanetSelection.toggle()
                }) {

                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)

                        Image(systemName: "square.grid.3x3.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: currentPlanet.backgroundColor))
                            .zIndex(1000)
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 20))
                    }
                    .frame(width: 60, height: 60)
                }
                .position(x: getScreenBounds().width - 30, y: 0)

                Button(action: {
                    resetView()
                }) {
                    Image(systemName: "arrow.up.forward.and.arrow.down.backward")
                        .resizable()
                        .foregroundStyle(.background)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)


                }
                .position(x: 350, y: 450)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showPlanetSelection) {
            PlanetSelectionView(onPlanetSelect: { planetIndex in
                currentScene = PlanetModel.planets[planetIndex].name
                
                selectedPlanet.selectePlanet = planetIndex
                showPlanetSelection.toggle()
            })
        }
    }

}

#Preview {
    MainView()
        .environmentObject(SelectedPlanet())
}
