//
//  PrimitiveCube.swift
//  SceneKit-Swift
//
//  Created by Pavel Kuzmin on 18/06/14.
//  Copyright (c) 2014 enterra-inc. All rights reserved.
//

import Cocoa
import QuartzCore
import SceneKit

let RED:NSColor = NSColor(red: 0.1, green: 0.1, blue: 0.9, alpha:1)
let ORANGE:NSColor = NSColor(red: 0.1, green: 0.9, blue: 0.1, alpha:1)
let WHITE:NSColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha:1)
let YELLOW:NSColor = NSColor(red: 0.9, green: 0.9, blue: 0.1, alpha:1)
let BLUE:NSColor = NSColor(red: 0.9, green: 0.1, blue: 0.1, alpha:1)
let GREEN:NSColor = NSColor(red: 0.9, green: 0.5, blue: 0.1, alpha:1)

class PrimitiveCube: SCNNode {
    
    var newPosition:SCNVector3?
    
    init(){
        super.init()
        // create and add a 3d box to the scene
        self.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.05)
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = NSImage(named: "texture")
        material.specular.contents = NSColor.grayColor()
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        self.geometry.firstMaterial = material
        
        let sideNodeX1 = self.sideBoxNodeX(RED)
        let sideNodeX2 = self.sideBoxNodeX(ORANGE)
        
        let sideNodeY1 = self.sideBoxNodeY(WHITE)
        let sideNodeY2 = self.sideBoxNodeY(YELLOW)
        
        let sideNodeZ1 = self.sideBoxNodeZ(BLUE)
        let sideNodeZ2 = self.sideBoxNodeZ(GREEN)
        
        sideNodeX1.position =  SCNVector3(x: 0.5, y: 0, z: 0)
        sideNodeX2.position =  SCNVector3(x: -0.5, y: 0, z: 0)
        
        sideNodeY1.position =  SCNVector3(x: 0, y: 0.5, z: 0)
        sideNodeY2.position =  SCNVector3(x: 0, y: -0.5, z: 0)
        
        sideNodeZ1.position =  SCNVector3(x: 0, y: 0, z: 0.5)
        sideNodeZ2.position =  SCNVector3(x: 0, y: 0, z: -0.5)
        
        self.addChildNode(sideNodeX1)
        self.addChildNode(sideNodeX2)
        
        self.addChildNode(sideNodeY1)
        self.addChildNode(sideNodeY2)
        
        self.addChildNode(sideNodeZ1)
        self.addChildNode(sideNodeZ2)
    }
    
    func mark()
    {
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.1)
        
        geometry.firstMaterial.emission.contents = NSColor.redColor()
        
        SCNTransaction.commit()
    }
    
    func sideBoxNodeX(sideColor:NSColor) -> SCNNode{
        // create and add a 3d box to the scene
        var boxNode = self.sideBoxNodeX()
        
        boxNode.geometry.firstMaterial.diffuse.contents = sideColor
        boxNode.geometry.firstMaterial.multiply.contents = NSImage(named: "wood")

        return boxNode
    }
    
    func sideBoxNodeY(sideColor:NSColor) -> SCNNode{
        // create and add a 3d box to the scene
        var boxNode = self.sideBoxNodeY()
        
        boxNode.geometry.firstMaterial.diffuse.contents = sideColor
        boxNode.geometry.firstMaterial.multiply.contents = NSImage(named: "wood")
        
        return boxNode
    }
    
    func sideBoxNodeZ(sideColor:NSColor) -> SCNNode{
        // create and add a 3d box to the scene
        var boxNode = self.sideBoxNodeZ()
        
        boxNode.geometry.firstMaterial.diffuse.contents = sideColor
        boxNode.geometry.firstMaterial.multiply.contents = NSImage(named: "wood")
        
        return boxNode
    }
    
    func sideBoxNodeX() -> SCNNode{
        // create and add a 3d box to the scene
        
        var sideBoxNode = SCNNode(geometry:SCNBox(width: 0.1, height: 0.9, length: 0.9, chamferRadius: 0.05))
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.grayColor()
        material.specular.contents = NSColor.yellowColor()
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        sideBoxNode.geometry.firstMaterial = material
        
        sideBoxNode.name = "sideComponentCube"
        
        return sideBoxNode
    }
    
    func sideBoxNodeY() -> SCNNode{
        // create and add a 3d box to the scene
        
        var sideBoxNode = SCNNode(geometry:SCNBox(width: 0.9, height: 0.1, length: 0.9, chamferRadius: 0.05))
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.grayColor()
        material.specular.contents = NSColor.yellowColor()
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        sideBoxNode.geometry.firstMaterial = material
        
        sideBoxNode.name = "sideComponentCube"
        
        return sideBoxNode
    }
    
    func sideBoxNodeZ() -> SCNNode{
        // create and add a 3d box to the scene
        
        var sideBoxNode = SCNNode(geometry:SCNBox(width: 0.9, height: 0.9, length: 0.1, chamferRadius: 0.05))
        
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.grayColor()
        material.specular.contents = NSColor.yellowColor()
        material.locksAmbientWithDiffuse = true
        
        // set the material to the 3d object geometry
        sideBoxNode.geometry.firstMaterial = material
        
        sideBoxNode.name = "sideComponentCube"
        
        return sideBoxNode
    }
    
    func quaternionMultiply(quaternion1:SCNVector4, quaternion2:SCNVector4) -> SCNVector4
    {
        let result = SCNVector4(
            x: quaternion1.w*quaternion2.x + quaternion1.x*quaternion2.w + quaternion1.y*quaternion2.z - quaternion1.z*quaternion2.y,
            y: quaternion1.w*quaternion2.y - quaternion1.x*quaternion2.z + quaternion1.y*quaternion2.w + quaternion1.z*quaternion2.x,
            z: quaternion1.w*quaternion2.z + quaternion1.x*quaternion2.y - quaternion1.y*quaternion2.x + quaternion1.z*quaternion2.w,
            w: quaternion1.w*quaternion2.w - quaternion1.x*quaternion2.x - quaternion1.y*quaternion2.y - quaternion1.z*quaternion2.z)
        
        return result
    }
}