//
//  SCNModelView.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//

import SceneKit
import SwiftUI


func getAllNodes(from node: SCNNode) -> [SCNNode] {
    var nodes = [node]
    for child in node.childNodes {
        nodes.append(contentsOf: getAllNodes(from: child))
    }
    return nodes
}

struct SCNModelView: UIViewRepresentable {

    @EnvironmentObject private var selectedPlanet: SelectedPlanet

    @Binding var scnFileName: String

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()

        if let scene = SCNScene(named: "\(scnFileName).scn") {
            sceneView.scene = scene
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            sceneView.backgroundColor = .clear

            let tapGesture = UITapGestureRecognizer(
                target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            sceneView.addGestureRecognizer(tapGesture)
        } else {
            print("Failed to load SCN file.")
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        loadScene(in: uiView)
    }

    private func loadScene(in sceneView: SCNView) {
        if let scene = SCNScene(named: "\(scnFileName).scn") {
            sceneView.scene = scene
        } else {
            print("Failed to load SCN file: \(scnFileName)")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func resetSystemView(in scnView: SCNView) {
        guard let rootNode = scnView.scene?.rootNode else { return }

        for node in getAllNodes(from: rootNode) {
            node.isHidden = false
        }

        guard let cameraNode = scnView.pointOfView else { return }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        cameraNode.worldPosition = SCNVector3(0, 0, 50)
        cameraNode.constraints = nil

        SCNTransaction.commit()
    }

    class Coordinator: NSObject {
        var parent: SCNModelView

        init(_ parent: SCNModelView) {
            self.parent = parent
        }

        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            guard let scnView = gestureRecognize.view as? SCNView else { return }
            guard let cameraNode = scnView.pointOfView else {
                print("Camera node not found!")
                return
            }
            let location = gestureRecognize.location(in: scnView)

            let hitResults = scnView.hitTest(location, options: [:])

            guard !hitResults.isEmpty else {
                print("No nodes detected at tap location.")
                return
            }

            var closestNode: SCNNode?
            var closestDistance: Float = Float.greatestFiniteMagnitude

            for hit in hitResults {
                let node = hit.node

                let nodeWorldPosition = node.convertPosition(SCNVector3Zero, to: nil)

                let cameraWorldPosition = cameraNode.position

                let distance = sqrt(
                    pow(cameraWorldPosition.x - nodeWorldPosition.x, 2)
                        + pow(cameraWorldPosition.y - nodeWorldPosition.y, 2)
                        + pow(cameraWorldPosition.z - nodeWorldPosition.z, 2)
                )

                if distance < closestDistance {
                    closestNode = node
                    closestDistance = distance
                }
            }

            if let closestNode = closestNode {
                print(
                    "Closest node: \(closestNode.name ?? "Unnamed") at distance \(closestDistance)")

                if let planetName = closestNode.name {
                    self.focusOnNode(closestNode, in: scnView)

                    self.transitionToPlanetModel(named: planetName, in: scnView)
                }
            }
        }

        func transitionToPlanetModel(named planetID: String, in scnView: SCNView) {

            let objectToSceneMapping: [String: String] = [
                "Object_21": "Sun.scn",
                "Object_0": "Mercury.scn",
                "Object_1": "Venus.scn",
                "Object_10": "Moon.scn",
                "Object_2": "Earth.scn",
                "Object_3": "Mars.scn",
                "Object_4": "Jupiter.scn",
                "Object_5": "Saturn.scn",
                "Object_7": "Uranus.scn",
                "Object_8": "Neptune.scn",
            ]

            if let planetSceneName = objectToSceneMapping[planetID] {

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                    let sceneName = "\(planetSceneName)"


                    if let scene = SCNScene(named: sceneName) {

                        scnView.scene = scene
                        self.parent.scnFileName = planetSceneName
                        let searchString = planetSceneName.prefix(planetSceneName.count - 4)

                        if let index = PlanetModel.planets.firstIndex(where: {
                            $0.name.contains(searchString)
                        }) {
                            self.parent.selectedPlanet.selectePlanet = index
                            print("Planet \(searchString) found at index \(index)")
                        } else {
                            print("No planet found")
                        }
                        print("Transitioned to \(planetSceneName) scene.")
                    } else {
                        print("Scene for \(planetSceneName) not found.")
                    }
                }
            } else {
                print("Object \(planetID) not mapped to a scene.")
            }
        }

        func focusOnNode(_ node: SCNNode, in scnView: SCNView) {
            guard let currentCamera = scnView.pointOfView else { return }

            let (min, max) = node.boundingBox

            let nodeCenter = SCNVector3(
                (min.x + max.x) / 2,
                (min.y + max.y) / 2,
                (min.z + max.z) / 2
            )

            let worldCenter = node.convertPosition(nodeCenter, to: nil)

            let size = SCNVector3(
                max.x - min.x,
                max.y - min.y,
                max.z - min.z
            )
            let maxDimension = [abs(size.x), abs(size.y), abs(size.z)].max() ?? 1.0
            let zoomDistance = maxDimension * 0.5

            let direction = SCNVector3(
                currentCamera.worldPosition.x - worldCenter.x,
                currentCamera.worldPosition.y - worldCenter.y,
                currentCamera.worldPosition.z - worldCenter.z
            )
            let normalizedDirection = SCNVector3(
                direction.x / maxDimension,
                direction.y / maxDimension,
                direction.z / maxDimension
            )
            let newCameraPosition = SCNVector3(
                worldCenter.x + normalizedDirection.x * zoomDistance,
                worldCenter.y + normalizedDirection.y * zoomDistance,
                worldCenter.z + normalizedDirection.z * zoomDistance
            )

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            currentCamera.worldPosition = newCameraPosition
            let lookAtConstraint = SCNLookAtConstraint(target: node)
            lookAtConstraint.isGimbalLockEnabled = true
            currentCamera.constraints = [lookAtConstraint]

            SCNTransaction.commit()
        }
    }
}
