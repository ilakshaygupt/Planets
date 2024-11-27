//
//  SCNModelView.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//


import SwiftUI
import SceneKit

func getAllNodes(from node: SCNNode) -> [SCNNode] {
    var nodes = [node] // Start with the current node
    for child in node.childNodes {
        nodes.append(contentsOf: getAllNodes(from: child)) // Recursively add child nodes
    }
    return nodes
}


struct SCNModelView: UIViewRepresentable {

    let scnFileName: String

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        // Load the SCN file
        if let scene = SCNScene(named: "\(scnFileName).scn") {
            sceneView.scene = scene
            sceneView.allowsCameraControl = true

            sceneView.autoenablesDefaultLighting = true
            sceneView.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            sceneView.addGestureRecognizer(tapGesture)
            var nodses = getAllNodes(from: scene.rootNode)
            for node in nodses {
//                print(node.name)
            }

           
        } else {
            print("Failed to load SCN file.")
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Handle updates to the SCNView if needed
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func resetSystemView(in scnView: SCNView) {
        guard let rootNode = scnView.scene?.rootNode else { return }

        // Show all nodes
        for node in getAllNodes(from: rootNode) {
            node.isHidden = false
        }

        // Reset camera position
        guard let cameraNode = scnView.pointOfView else { return }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        cameraNode.worldPosition = SCNVector3(0, 0, 50) // Adjust as needed
        cameraNode.constraints = nil // Remove look-at constraints

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

            // Perform hit test on the scene
            let hitResults = scnView.hitTest(location, options: [:])

            // Check if any nodes are hit
            guard !hitResults.isEmpty else {
                print("No nodes detected at tap location.")
                return
            }

            // Find the closest node based on calculated distance
            var closestNode: SCNNode?
            var closestDistance: Float = Float.greatestFiniteMagnitude

            for hit in hitResults {
                let node = hit.node

                // Calculate the node's world position
                let nodeWorldPosition = node.convertPosition(SCNVector3Zero, to: nil)

                // Calculate the camera's world position
                let cameraWorldPosition = cameraNode.position

                // Compute Euclidean distance
                let distance = sqrt(
                    pow(cameraWorldPosition.x - nodeWorldPosition.x, 2) +
                    pow(cameraWorldPosition.y - nodeWorldPosition.y, 2) +
                    pow(cameraWorldPosition.z - nodeWorldPosition.z, 2)
                )

                // Update the closest node if this one is nearer
                if distance < closestDistance {
                    closestNode = node
                    closestDistance = distance
                }
            }

            // Focus on the closest node
            if let closestNode = closestNode {
                print("Closest node: \(closestNode.name ?? "Unnamed") at distance \(closestDistance)")
                focusOnNode(closestNode, in: scnView)
            }
        }

        func focusOnNode(_ node: SCNNode, in scnView: SCNView) {
            guard let currentCamera = scnView.pointOfView else { return }

            // Get the bounding box of the node
            let (min, max) = node.boundingBox

            // Calculate the node's center in its local coordinate space
            let nodeCenter = SCNVector3(
                (min.x + max.x) / 2,
                (min.y + max.y) / 2,
                (min.z + max.z) / 2
            )

            // Transform the node's center to world coordinates
            let worldCenter = node.convertPosition(nodeCenter, to: nil)

            // Calculate the distance to position the camera
            let size = SCNVector3(
                max.x - min.x,
                max.y - min.y,
                max.z - min.z
            )
            let maxDimension = [abs(size.x), abs(size.y), abs(size.z)].max() ?? 1.0
            let zoomDistance = maxDimension * 0.5

            // Calculate the new camera position along the forward vector
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

            // Animate the camera movement and apply the LookAt constraint
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
