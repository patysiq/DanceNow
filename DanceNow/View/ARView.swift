//
//  ARView.swift
//  DanceNow
//
//  Created by PATRICIA S SIQUEIRA on 20/06/21.
//

import Foundation
import ARKit
import SwiftUI
import RealityKit
import Combine

var bodySkeleton: BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()

// MARK: - ARViewIndicator
struct ARViewIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = ARViewScene
   
   func makeUIViewController(context: Context) -> ARViewScene {
      return ARViewScene()
   }
    
   func updateUIViewController(_ uiViewController:ARViewIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<ARViewIndicator>) { }
}


class ARViewScene: UIViewController, ARSessionDelegate {
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    var arView: ARView {
         return self.view as! ARView
      }
      override func loadView() {
        self.view = ARView(frame: .zero)
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        arView.session.delegate = self
        //arView.scene = SCNScene()
     }
    
    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       let configuration = ARBodyTrackingConfiguration()//ARWorldTrackingConfiguration()
       arView.session.run(configuration)
        arView.session.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       arView.session.pause()
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
   
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }
    
//    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//        //bodySkeletonAnchor.addChild(skeleton)
//
//        for anchor in anchors {
//            if let bodyAnchor = anchor as? ARBodyAnchor {
//                //Create or update bodySkeleton
//                if let skeleton = bodySkeleton {
//                    //BodySkeleton  already exists, update pose os all joints
//                    skeleton.update(with: bodyAnchor)
//                } else {
//                    //Seeing body for the first time, create bodySkeleton
//                    let skeleton = BodySkeleton(for: bodyAnchor)
//                    bodySkeleton = skeleton
//                    bodySkeletonAnchor.addChild(skeleton)
//                }
//            }
//        }
//    }
    
}

// MARK: - NavigationIndicator
struct NavigationIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = ARViewScene
   func makeUIViewController(context: Context) -> ARViewScene {
      return ARViewScene()
   }
   func updateUIViewController(_ uiViewController:
   NavigationIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<NavigationIndicator>) { }
}
