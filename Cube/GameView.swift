//
//  GameView.swift
//  Cube
//
//  Created by Pavel Kuzmin on 30/06/14.
//  Copyright (c) 2014 enterra-inc. All rights reserved.
//

import SceneKit

class GameView: SCNView {
    
    override func mouseDown(with theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        // check what nodes are clicked
        let p = self.convert(theEvent.locationInWindow, from: nil)
        let hitResults = self.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if (hitResults.count > 0) {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            let node = result.node!
            
            if (node.parent!.isKind(of: PrimitiveCube.self)) {
                let nodePrimitive = result.node!.parent as! PrimitiveCube
                
                if (!nodePrimitive.parent!.isKind(of: Layer.self)) {
                    let cube = nodePrimitive.parent as! Cube
                    
                    cube.selectSide(node)
                }
            }
        }
        
        super.mouseDown(with: theEvent)
    }

}
