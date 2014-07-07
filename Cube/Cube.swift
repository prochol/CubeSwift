//
//  Cube.swift
//  SceneKit-Swift
//
//  Created by Pavel Kuzmin on 18/06/14.
//  Copyright (c) 2014 enterra-inc. All rights reserved.
//

import QuartzCore
import SceneKit

var defaultPositionComponent = SCNVector3(x: 0.5, y: 0.5, z: 0.5)

var widthComponent:Int = 3
var heightComponent:Int = 3
var lengthComponent:Int = 3

class Cube: SCNNode {
    
    var selectComponent1:PrimitiveCube?
    var selectComponent2:PrimitiveCube?
    var selectComponent3:PrimitiveCube?
    
    var layerRotate:Layer = Layer()
    
    var selectSide1:SCNNode?
    var pointCenterSide1:SCNVector3?
    
    var selectSide2:SCNNode?
    var pointCenterSide2:SCNVector3?
    
    init(){
        super.init()

        if (widthComponent % 2 > 0 || widthComponent < 2)
        {
            defaultPositionComponent.x -= 0.5
        }
        
        if (heightComponent % 2 > 0 || heightComponent < 2)
        {
            defaultPositionComponent.y -= 0.5
        }
        
        if (lengthComponent % 2 > 0 || lengthComponent < 2)
        {
            defaultPositionComponent.z -= 0.5
        }
        
        layerRotate.position = SCNVector3(x: 0, y: 0, z: 0)
        
        self.addChildNode(layerRotate)
        
        for indexWidth in 0..widthComponent {
            
            let offsetIndexWidthComponent:Int = widthComponent/2
            let offsetWidth:CGFloat = (CGFloat)(indexWidth - offsetIndexWidthComponent)
            let xCoordinate:CGFloat = defaultPositionComponent.x+offsetWidth
            
            for indexHeight in 0..heightComponent {
                
                let offsetIndexHeightComponent:Int = heightComponent/2
                let offsetHeight:CGFloat = (CGFloat)(indexHeight - offsetIndexHeightComponent)
                let yCoordinate:CGFloat = defaultPositionComponent.y+offsetHeight
                
                for indexLength in 0..lengthComponent {
                    
                    let offsetIndexLengthComponent:Int = lengthComponent/2
                    let offsetLength:CGFloat = (CGFloat)(indexLength - offsetIndexLengthComponent)
                    let zCoordinate:CGFloat = defaultPositionComponent.z+offsetLength
                    
                    let boxNode = PrimitiveCube()
                    boxNode.name = "componentCube"
                    
                    let position = SCNVector3(x: xCoordinate, y: yCoordinate, z: zCoordinate)
                    
                    boxNode.position = position
                    
                    self.addChildNode(boxNode)
                }
            }
        }
    }
    
    convenience init(widthComponentCube: Int, heightComponentCube: Int, lengthComponentCube: Int) {
        
        widthComponent = widthComponentCube
        heightComponent = heightComponentCube
        lengthComponent = lengthComponentCube
        
        self.init()
    }
    
    func resetComponents ()
    {
        // get its material
        let material1 = selectComponent1?.geometry.firstMaterial
        let material2 = selectComponent2?.geometry.firstMaterial
        let material3 = selectComponent3?.geometry.firstMaterial
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.01)
        
        if (material1)
        {
            material1!.emission.contents = NSColor.blackColor()
        }
        
        if (material2)
        {
            material2!.emission.contents = NSColor.blackColor()
        }
        
        if (material3)
        {
            material3!.emission.contents = NSColor.blackColor()
        }
        
        SCNTransaction.commit()
        
        selectComponent1 = nil
        selectComponent2 = nil
        selectComponent3 = nil
        
        //layerRotate.rotation = SCNVector4Zero
        layerRotate.rotation = SCNVector4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
        
        selectSide1 = nil
        selectSide2 = nil
    }
    
    func selectSide(sideNode:SCNNode)
    {
        if (!self.selectSide1(sideNode))
        {
            self.selectSide2(sideNode)
        }
    }
    
    func selectSide1 (sideNode:SCNNode) -> Bool
    {
        if (!selectSide1)
        {
            selectSide1 = sideNode
            
            pointCenterSide1 = selectSide1!.convertPosition(selectSide1!.position, toNode: self)
            
            println("pointCenterSide1: \(pointCenterSide1!.x) \(pointCenterSide1!.y) \(pointCenterSide1!.z)")
            
            self.selectComponent(selectSide1!.parentNode as PrimitiveCube)
            
            return true
        }
        else if (sideNode == selectSide1)
        {
            self.resetComponents()
            return true
        }
        
        return false
    }
    
    func selectSide2 (sideNode:SCNNode)
    {
        if (!selectSide2)
        {
            selectSide2 = sideNode
            
            pointCenterSide2 = selectSide2!.convertPosition(selectSide2!.position, toNode: self)
            
            println("pointCenterSide2: \(pointCenterSide2!.x) \(pointCenterSide2!.y) \(pointCenterSide2!.z)")
            
            let layerPosition = self.layerPosition()
            let angle = self.angleRotate(pointCenterSide1!, vectorEnd: pointCenterSide2!, component: layerPosition.1)
            
            self.layerRotate(layerPosition.0, components:layerPosition.1, angle:angle)
            
            self.rotation(SCNVector4(x: layerPosition.1.x, y: layerPosition.1.y, z: layerPosition.1.z, w: angle))
        }
    }
    
    func summPosition(onePosition:SCNVector3, twoPosition:SCNVector3) -> SCNVector3
    {
        let result:SCNVector3 = SCNVector3(
            x: onePosition.x+twoPosition.x,
            y: onePosition.y+twoPosition.y,
            z: onePosition.z+twoPosition.z)
        
        return result
    }
    
    func layerPosition() -> (SCNVector3, SCNVector3)
    {
        var xComponent:CGFloat = 0.0
        var yComponent:CGFloat = 0.0
        var zComponent:CGFloat = 0.0
        
        var xPosition:CGFloat = 0.0
        var yPosition:CGFloat = 0.0
        var zPosition:CGFloat = 0.0
        
        //if ((selectComponent1!.position.x == pointCenterSide1!.x) &&
        //(selectComponent1!.position.x == pointCenterSide2!.x))
        if (((selectComponent1!.position.x - pointCenterSide1!.x) < 0.01) &&
            ((selectComponent1!.position.x - pointCenterSide1!.x) > -0.01) &&
            ((selectComponent1!.position.x - pointCenterSide2!.x) < 0.01) &&
            ((selectComponent1!.position.x - pointCenterSide2!.x) > -0.01) )
        {
            xPosition = selectComponent1!.position.x
            xComponent = 1
        }

        //if ((selectComponent1!.position.y == pointCenterSide1!.y) &&
        //(selectComponent1!.position.y == pointCenterSide2!.y))
        if (((selectComponent1!.position.y - pointCenterSide1!.y) < 0.01) &&
            ((selectComponent1!.position.y - pointCenterSide1!.y) > -0.01) &&
            ((selectComponent1!.position.y - pointCenterSide2!.y) < 0.01) &&
            ((selectComponent1!.position.y - pointCenterSide2!.y) > -0.01) )
        {
            yPosition = selectComponent1!.position.y
            yComponent = 1
        }

        //if ((selectComponent1!.position.z == pointCenterSide1!.z) &&
        //(selectComponent1!.position.z == pointCenterSide2!.z))
        if (((selectComponent1!.position.z - pointCenterSide1!.z) < 0.01) &&
            ((selectComponent1!.position.z - pointCenterSide1!.z) > -0.01) &&
            ((selectComponent1!.position.z - pointCenterSide2!.z) < 0.01) &&
            ((selectComponent1!.position.z - pointCenterSide2!.z) > -0.01) )
        {
            zPosition = selectComponent1!.position.z
            zComponent = 1
        }
        
        let resultLayerPosition = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        println("LayerPosition: \(resultLayerPosition.x) \(resultLayerPosition.y) \(resultLayerPosition.z)")
        
        let resultLayerComponent = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        println("LayerComponent: \(resultLayerComponent.x) \(resultLayerComponent.y) \(resultLayerComponent.z)")
        
        return (resultLayerPosition, resultLayerComponent)
    }
    
    func layerRotate(position:SCNVector3, components:SCNVector3, angle:CGFloat)
    {
        for component:AnyObject in self.childNodes
        {
            if (component.isKindOfClass(PrimitiveCube))
            {
                var componentObj = component as PrimitiveCube
                
                if ( (componentObj.position.x == position.x) && (components.x == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    if (angle > 0)
                    {
                        componentObj.newPosition = SCNVector3(x: componentObj.position.x, y: -componentObj.position.z, z: componentObj.position.y)
                    }
                    else
                    {
                        componentObj.newPosition = SCNVector3(x: componentObj.position.x, y: componentObj.position.z, z: -componentObj.position.y)
                    }
                }
                
                if ( (componentObj.position.y == position.y) && (components.y == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    if (angle > 0)
                    {
                        componentObj.newPosition = SCNVector3(x: componentObj.position.z, y: componentObj.position.y, z: -componentObj.position.x)
                    }
                    else
                    {
                        componentObj.newPosition = SCNVector3(x: -componentObj.position.z, y: componentObj.position.y, z: componentObj.position.x)
                    }
                }
                
                if ( (componentObj.position.z == position.z) && (components.z == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    if (angle > 0)
                    {
                        componentObj.newPosition = SCNVector3(x: -componentObj.position.y, y: componentObj.position.x, z: componentObj.position.z)
                    }
                    else
                    {
                        componentObj.newPosition = SCNVector3(x: componentObj.position.y, y: -componentObj.position.x, z: componentObj.position.z)
                    }
                }
            }
        }
    }
    
    func angleRotate(vectorBegin:SCNVector3, vectorEnd:SCNVector3, component:SCNVector3) -> CGFloat
    {
        let vectorAngleRotate = SCNVector3(
                x: vectorEnd.x-vectorBegin.x,
                y: vectorEnd.y-vectorBegin.y,
                z: vectorEnd.z-vectorBegin.z)
        
        var isRight = true
        
        if (component.x == 1)
        {
            if(vectorAngleRotate.z > 0)
            {
                if(vectorBegin.y < 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.z < 0)
            {
                if(vectorBegin.y > 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.z == 0)
            {
                if((vectorBegin.z) > 0 && (vectorAngleRotate.y > 0))
                {
                    isRight = false
                }
                
                if((vectorBegin.z) < 0 && (vectorAngleRotate.y < 0))
                {
                    isRight = false
                }
            }
        }
        else if (component.y == 1)
        {
            if(vectorAngleRotate.x > 0)
            {
                if(vectorBegin.z < 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.x < 0)
            {
                if(vectorBegin.z > 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.x == 0)
            {
                if((vectorBegin.x > 0) && (vectorAngleRotate.z > 0))
                {
                    isRight = false
                }
                
                if((vectorBegin.x < 0) && (vectorAngleRotate.z < 0))
                {
                    isRight = false
                }
            }
        }
        else
        {
            if(vectorAngleRotate.x > 0)
            {
                if(vectorBegin.y > 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.x < 0)
            {
                if(vectorBegin.y < 0)
                {
                    isRight = false
                }
            }
            
            if(vectorAngleRotate.x == 0)
            {
                if((vectorBegin.x > 0) && (vectorAngleRotate.y < 0))
                {
                    isRight = false
                }
                
                if((vectorBegin.x < 0) && (vectorAngleRotate.y > 0))
                {
                    isRight = false
                }
            }
        }
        
        if (isRight)
        {
            println("angle: \(Float(M_PI)/2)")
            return CGFloat(M_PI)/2
        }
        else
        {
            println("angle: \(-Float(M_PI)/2)")
            return -CGFloat(M_PI)/2
        }
        
    }
    
    
    
    
    func selectComponent1 (component:PrimitiveCube) -> Bool
    {
        if (!selectComponent1)
        {
            selectComponent1 = component
            
            println("selectComponent1.position: \(selectComponent1!.position.x) \(selectComponent1!.position.y) \(selectComponent1!.position.z)")
            
            selectComponent1!.mark()
            
            return true
        }
        else if (component == selectComponent1)
        {
            self.resetComponents()
            return true
        }
        
        return false
    }
    
    func selectComponent2 (component:PrimitiveCube) -> Bool
    {
        if (!selectComponent2)
        {
            selectComponent2 = component
            
            selectComponent2!.mark()
            
            return true
        }
        else if (component == selectComponent2)
        {
            self.resetComponents()
            return true
        }
        
        return false
    }
    
    func selectComponent3 (component:PrimitiveCube)
    {
        if (!selectComponent3)
        {
            selectComponent3 = component
            
            selectComponent3!.mark()
            
            var vector = self.rotationVector()
            
            let sqrLengthVector = vector.0.x*vector.0.x + vector.0.y*vector.0.y + vector.0.z*vector.0.z
            
            if (sqrLengthVector == 0)
            {
                self.resetComponents()
            }
            else
            {
                self.rotationVector(vector.0, components: vector.1)
            }
        }
        else if (component == selectComponent3)
        {
            self.resetComponents()
        }
    }
    
    func selectComponent (component:PrimitiveCube)
    {
        if (!self.selectComponent1(component))
        {
            if (!self.selectComponent2(component))
            {
                self.selectComponent3(component)
            }
        }
    }
    
    func rotationVector() -> (SCNVector4, SCNVector3)
    {
        var xComponent:CGFloat = 0.0
        var yComponent:CGFloat = 0.0
        var zComponent:CGFloat = 0.0
        
        var xPosition:CGFloat = 0.0
        var yPosition:CGFloat = 0.0
        var zPosition:CGFloat = 0.0
        
        if (selectComponent1!.position.x == selectComponent2!.position.x && selectComponent1!.position.x == selectComponent3!.position.x)
        {
            xPosition = selectComponent1!.position.x
            if (xPosition == 0)
            {
                xPosition = 0.1
            }
            xComponent = 1
        }
        
        if (selectComponent1!.position.y == selectComponent2!.position.y && selectComponent1!.position.y == selectComponent3!.position.y)
        {
            yPosition = selectComponent1!.position.y
            if (yPosition == 0)
            {
                yPosition = 0.1
            }
            yComponent = 1
        }
        
        if (selectComponent1!.position.z == selectComponent2!.position.z && selectComponent1!.position.z == selectComponent3!.position.z)
        {
            zPosition = selectComponent1!.position.z
            if (zPosition == 0)
            {
                zPosition = 0.1
            }
            zComponent = 1
        }
        
        if (xComponent + yComponent + zComponent > 1)
        {
            xComponent = 0.0
            yComponent = 0.0
            zComponent = 0.0
            
            xPosition = 0.0
            yPosition = 0.0
            zPosition = 0.0
        }
        
        let resultRotateVector = SCNVector4(x: xPosition, y: yPosition, z: zPosition, w: CGFloat(M_PI)/2)
        
        let resultComponentVector = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        
        return (resultRotateVector, resultComponentVector)
    }
    
    func rotationVector(rotate:SCNVector4, components:SCNVector3)
    {
        var layer = SCNVector3(x: rotate.x, y: rotate.y, z: rotate.z)
        
        if (layer.x == 0.1)
        {
            layer.x = 0
            layer.y = 0.1
            layer.z = 0.1
        }
        else if (layer.y == 0.1)
        {
            layer.x = 0.1
            layer.y = 0
            layer.z = 0.1
        }
        else if (layer.z == 0.1)
        {
            layer.x = 0.1
            layer.y = 0.1
            layer.z = 0
        }
        
        for component:AnyObject in self.childNodes
        {
            if (component.isKindOfClass(PrimitiveCube))
            {
                var componentObj = component as PrimitiveCube
                
                if ( (componentObj.position.x == layer.x) && (components.x == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    componentObj.newPosition = SCNVector3(x: componentObj.position.x, y: -componentObj.position.z, z: componentObj.position.y)
                }
                
                if ( (componentObj.position.y == layer.y) && (components.y == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    componentObj.newPosition = SCNVector3(x: componentObj.position.z, y: componentObj.position.y, z: -componentObj.position.x)
                }
                
                if ( (componentObj.position.z == layer.z) && (components.z == 1) )
                {
                    layerRotate.addChildNode(componentObj)
                    
                    componentObj.newPosition = SCNVector3(x: -componentObj.position.y, y: componentObj.position.x, z: componentObj.position.z)
                }
            }
        }
        
        self.rotation(SCNVector4(x: components.x, y: components.y, z: components.z, w: rotate.w))
    }
    
    func rotation(rotate:SCNVector4)
    {
        SCNTransaction.begin()
        
        let count = layerRotate.childNodes.count
        let durationAnimation =  0.1 * (CDouble)(count)
        
        SCNTransaction.setAnimationDuration(durationAnimation)
        
        layerRotate.rotation = SCNVector4(x: rotate.x, y: rotate.y, z: rotate.z, w: rotate.w)
        
        SCNTransaction.setCompletionBlock {
            
            for component:AnyObject in self.layerRotate.childNodes
            {
                var componentObj = component as PrimitiveCube
                
                //componentObj.transform = SCNMatrix4Mult(componentObj.transform, self.layerRotate.transform)
                componentObj.transform = CATransform3DConcat(componentObj.transform, self.layerRotate.transform)
                
                componentObj.position = componentObj.newPosition!
                
                self.addChildNode(componentObj)
            }
            
            println(">> rotation end <<")
            
            self.resetComponents()
        }
        
        SCNTransaction.commit()        
    }
}