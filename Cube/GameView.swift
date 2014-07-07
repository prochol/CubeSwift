//
//  GameView.swift
//  Cube
//
//  Created by Pavel Kuzmin on 30/06/14.
//  Copyright (c) 2014 enterra-inc. All rights reserved.
//

import SceneKit

class GameView: SCNView {
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        // check what nodes are clicked
        let p = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        let hitResults = self.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if (hitResults.count > 0){
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            var node = result.node!
            
            if (node.parentNode.isKindOfClass(PrimitiveCube))
            {
                let nodePrimitive = result.node!.parentNode as PrimitiveCube
                
                if (!nodePrimitive.parentNode.isKindOfClass(Layer))
                {
                    var cube = nodePrimitive.parentNode as Cube
                    
                    if (!cube.selectSide2)
                    {
                        cube.selectSide(node)
                    }
                    
                    /*if (!cube.selectComponent3)
                    {
                    cube.selectComponent(nodePrimitive)
                    }*/
                }
            }
        }
        
        super.mouseDown(theEvent)
    }

}
