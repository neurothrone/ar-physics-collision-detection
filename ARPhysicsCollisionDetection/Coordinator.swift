//
//  Coordinator.swift
//  ARGravity
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import ARKit
import Combine
import Foundation
import RealityKit

final class Coordinator {
  weak var view: ARView?
  var collisionSubscriptions: [Cancellable] = []
  
  @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
    guard let view = view else { return }
    
    let tapLocation = recognizer.location(in: view)
    let raycastResults = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
    
    if let result = raycastResults.first {
      let anchorEntity = AnchorEntity(raycastResult: result)
      
      let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .purple, isMetallic: true)])
      box.position = simd_make_float3(0, 0.7, 0)
      box.generateCollisionShapes(recursive: true)
      box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic)
      box.collision = CollisionComponent(shapes: [.generateBox(size: [0.2, 0.2, 0.2])], mode: .trigger, filter: .sensor)
      
      collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Began.self) { event in
        box.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
      })
      
      collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
        box.model?.materials = [SimpleMaterial(color: .purple, isMetallic: true)]
      })
      
      anchorEntity.addChild(box)
      view.scene.addAnchor(anchorEntity)
    }
  }
}
