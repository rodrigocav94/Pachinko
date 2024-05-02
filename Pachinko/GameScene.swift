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
        background.position = CGPoint(x: 590, y: 410) // Place image in the center of the screen.
        background.blendMode = .replace // Ignore alpha, complete solid. Makes it faster.
        background.zPosition = -1 // Place it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // This physicsBody comes from SKScene, it's a property of the main thing
        
        for i in 0...4 {
            let distanceBetweenBouncers = 1180 / 4
            makeBouncer(at: CGPoint(x: i * distanceBetweenBouncers, y: 0))
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When you touch the screen somehow.
        guard let touch = touches.first else { return } // If the user has touched with 2 or 3 fingers at the same time, get the first.
        let location = touch.location(in: self) // Find where this touch was in my whole game scene.
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2) // Behave like circle instead of Square
        ball.physicsBody?.restitution = 0.4 // Bounciness, 0 not bouncy at all and 1 is super bouncy.
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false // The object will not move based on gravity and collisions because this property is set to false
        addChild(bouncer)
    }
}
