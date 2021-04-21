//
//  WorkoutNode.swift
//  Haraka-AR
//
//  Created by Njood Alhajery on 26/03/2021.
//

import Foundation
import ARKit

class WorkoutNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError() }
    

    init(hitResult: ARHitTestResult?, workout: String) {
        super.init()
        if let hitResult = hitResult {
            guard let workoutScene = SCNScene(named: "\(Model.path)\(workout)\(Model.extension)") else  {return}
            self.position = SCNVector3Make(
                hitResult.worldTransform.columns.3.x,
                hitResult.worldTransform.columns.3.y ,
                hitResult.worldTransform.columns.3.z
            )
            self.scale = SCNVector3(0.005, 0.005, 0.005)
            
            workoutScene.rootNode.childNodes.forEach { (node) in
                self.addChildNodes([node])
            }
        }
    }
    
    init(rayCast: ARRaycastResult?, workout: String){
        super.init()
        if let rayCast = rayCast {
            guard let workoutScene = SCNScene(named: "\(Model.path)\(workout)\(Model.extension)") else  {return}
            self.position = SCNVector3Make(
                rayCast.worldTransform.columns.3.x,
                rayCast.worldTransform.columns.3.y ,
                rayCast.worldTransform.columns.3.z
            )
            
            self.scale = SCNVector3(0.005, 0.005, 0.005)
            
            workoutScene.rootNode.childNodes.forEach { (node) in
                self.addChildNodes([node])
            }
        }
    }
    
    
}
extension SCNNode {
    
    func addChildNodes(_ nodes: SCNNode...) { addChildNodes(nodes) }
    
    func addChildNodes(_ nodes: [SCNNode]) { nodes.forEach { addChildNode($0) } }
    
}

