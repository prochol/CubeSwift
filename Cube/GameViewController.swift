//
//  GameViewController.swift
//  Cube
//
//  Created by Pavel Kuzmin on 30/06/14.
//  Copyright (c) 2014 enterra-inc. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet var gameView: GameView!
    
    override func awakeFromNib() {
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        // create and add a light to the scene
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light!.type = SCNLight.LightType.ambient
        lightNode1.position = SCNVector3(x: 13, y: 13, z: 13)
        
        scene.rootNode.addChildNode(lightNode1)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLight.LightType.omni
        lightNode2.position = SCNVector3(x: -13, y: -13, z: -13)
        
        scene.rootNode.addChildNode(lightNode2)
        
        // create and add a 3d box to the scene
        let boxNode = self.boxContainer()
        boxNode.position = SCNVector3(x: 0, y: 0, z: 0)
        //SCNNode()
        //boxNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.02)
        scene.rootNode.addChildNode(boxNode)
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = NSImage(named: "texture")
        material.specular.contents = NSColor.white
        material.specular.intensity = 0.2
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        //boxNode.geometry.firstMaterial = material
        
        // animate the 3d object
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(scnVector4: SCNVector4(x: CGFloat(1), y: CGFloat(1), z: CGFloat(0), w: CGFloat(Float.pi)*2))
        animation.duration = 5
        animation.repeatCount = MAXFLOAT //repeat forever
        //boxNode.addAnimation(animation, forKey: "")
        
        // set the scene to the view
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.black
    }

    func boxContainer() -> Cube {
        // create and add a 3d box to the scene
        let boxContainer = Cube(widthComponentCube: 3, heightComponentCube: 3, lengthComponentCube: 3)
        
        return boxContainer
    }
}
