import SwiftUI
import SceneKit

struct MainView: View {
    @State private var isZoomingIn = false
    @State private var isExpandedView = false
    @EnvironmentObject private var selectedPlanet: SelectedPlanet
    @State private var showPlanetSelection = false
    @State private var currentScene: String = "Solar_System" // Default to Solar System

    // Mapping object names (e.g., Object_5 -> Saturn) to scene files
    private let objectToSceneMapping: [String: String] = [
        "Object_21": "mars",
        "Object_0": "mars",
        "Object_1": "mars",
        "Object_10": "mars",
        "Object_2": "mars",
        "Object_3": "mars",
        "Object_4": "mars",
        "Object_5": "mars",  
        "Object_7": "mars",
        "Object_8": "mars"
    ]

    var currentPlanet: PlanetModel {
        PlanetModel.planets[selectedPlanet.selectePlanet]
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

                    SCNModelView(scnFileName: currentScene)
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
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Radius", value: currentPlanet.properties.radius)
                        InfoRow(label: "Distance from Sun", value: currentPlanet.properties.distanceFromSun)
                        InfoRow(label: "Moons", value: currentPlanet.properties.moons)
                        InfoRow(label: "Gravity", value: currentPlanet.properties.gravity)
                        InfoRow(label: "Tilt of Axis", value: currentPlanet.properties.tiltOfAxis)
                        InfoRow(label: "Length of Year", value: currentPlanet.properties.lengthOfYear)
                        InfoRow(label: "Length of Day", value: currentPlanet.properties.lengthofDay)
                        InfoRow(label: "Temperature", value: currentPlanet.properties.temperature)
                    }
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
                    Text("Select Planet")
                        .foregroundStyle(.black)
                        .zIndex(1000)
                }
                .position(x: 50, y: 400)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showPlanetSelection) {
            PlanetSelectionView( onPlanetSelect: { planetIndex in
                // Update the scene to the selected planet's model
                currentScene = PlanetModel.planets[planetIndex].name
                selectedPlanet.selectePlanet = planetIndex
                showPlanetSelection.toggle()
            })
        }
    }

    // This function is called when a planet or object is tapped
    func handleTapOnObject(named objectName: String) {
        // Check the object name and map it to the corresponding scene
        if let sceneFile = objectToSceneMapping[objectName] {
            withAnimation {
                isZoomingIn.toggle()
            }

            // After zooming in, change the scene
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                currentScene = sceneFile
                print(currentScene)
                print("-------------------------------------------------------------------------------------")
                isZoomingIn = false
            }
        } else {
            // Handle case where the scene file is not found
            print("Scene for \(objectName) not found.")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(SelectedPlanet())
}

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
