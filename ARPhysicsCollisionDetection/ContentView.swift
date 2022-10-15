//
//  ContentView.swift
//  ARPhysicsCollisionDetection
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import RealityKit
import SwiftUI

struct ContentView : View {
  var body: some View {
    ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
    context.coordinator.view = arView
    
    let floorAnchor = AnchorEntity(plane: .horizontal)
//    let floor = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.5), materials: [SimpleMaterial(color: .green, isMetallic: true)])
    let floor = ModelEntity(mesh: .generateBox(size: [1000, 0, 1000]), materials: [OcclusionMaterial()])
    floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
    floor.generateCollisionShapes(recursive: true)
    
    floorAnchor.addChild(floor)
    arView.scene.addAnchor(floorAnchor)
    
    return arView
  }
  
  func makeCoordinator() -> Coordinator {
    .init()
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
