//
//  GameScene.swift
//  Pachinko
//
//  Created by Rodrigo Cavalcanti on 02/05/24.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384) // Place image in the center of the screen.
        background.blendMode = .replace // Ignore alpha, complete solid. Makes it faster.
        background.zPosition = -1 // Place it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // This physicsBody comes from SKScene, it's a property of the main thing
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When you touch the screen somehow.
        guard let touch = touches.first else { return } // If the user has touched with 2 or 3 fingers at the same time, get the first.
        let location = touch.location(in: self) // Find where this touch was in my whole game scene.
        
        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64)) // Create a new sprite node, a square.
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // Give this thing a physics body matching the size of the box itself.
        
        box.position = location //  Position the box at the location to see where the touch happened on the screen
        addChild(box) // Add to the screen
    }
}
