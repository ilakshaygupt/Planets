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
    class Coordinator: NSObject {
        var parent: SCNModelView

        init(_ parent: SCNModelView) {
            self.parent = parent
        }

        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // Get the SceneKit view
            guard let scnView = gestureRecognize.view as? SCNView else { return }

            // Get the location of the tap
            let location = gestureRecognize.location(in: scnView)

            // Perform hit test to find the tapped node
            let hitResults = scnView.hitTest(location, options: [:])

            // If a node is tapped
            if let result = hitResults.first {
                let node = result.node

                // Focus on the tapped node
                focusOnNode(node, in: scnView)
            }
        }

        func focusOnNode(_ node: SCNNode, in scnView: SCNView) {
            // Create a camera action to focus on the node
            let lookAtAction = SCNAction.rotate(toAxisAngle: SCNVector4(x: 0, y: 1, z: 0, w: 0), duration: 0.5)

            // Calculate the camera position to frame the node
            let (min, max) = node.boundingBox
            let center = SCNVector3(
                (min.x + max.x) / 2,
                (min.y + max.y) / 2,
                (min.z + max.z) / 2
            )

            // Get the bounding box size
            let size = SCNVector3(
                max.x - min.x,
                max.y - min.y,
                max.z - min.z
            )

            // Calculate an appropriate distance to view the entire node
            let maxDimension = [abs(size.x), abs(size.y), abs(size.z)].max() ?? 1.0
            let distance = maxDimension * 2

            // Create a new camera position
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(
                center.x,
                center.y,
                center.z + distance
            )

            // Set up the camera constraints
            let lookAtConstraint = SCNLookAtConstraint(target: node)
            lookAtConstraint.isGimbalLockEnabled = true
            cameraNode.constraints = [lookAtConstraint]

            // Animate the camera movement
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            scnView.pointOfView = cameraNode
            SCNTransaction.commit()
        }
    }


}
