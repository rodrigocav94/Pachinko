//
//  GameScene.swift
//  Pachinko
//
//  Created by Rodrigo Cavalcanti on 02/05/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var tryAgainLabel: SKLabelNode!
    
    var ballsInGame = 0
    
    var ballsRemaining = 5 {
        didSet {
            ballsLabel.text = "Remaining: \(ballsRemaining) ball\(ballsRemaining == 1 ? "" : "s")"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var isGameOver = false {
        didSet {
            if isGameOver {
                displayGameOver()
            } else {
                tryAgain()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 590, y: 410) // Place image in the center of the screen.
        background.blendMode = .replace // Ignore alpha, complete solid. Makes it faster.
        background.zPosition = -1 // Place it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // This physicsBody comes from SKScene, it's a property of the main thing
        physicsWorld.contactDelegate = self
        
        for i in 0...4 {
            let distanceBetweenBouncers = 1180 / 4
            makeBouncer(at: CGPoint(x: i * distanceBetweenBouncers, y: 0))
        }
        
        for i in 1...4 {
            let distanceBetweenBouncers = 1180.0 / 4
            let halfwayPoint = distanceBetweenBouncers / 2
            let xCoordinate = (Double(i) * distanceBetweenBouncers) - halfwayPoint
            let isSlotGood = i % 2 != 0
            makeSlot(at: CGPoint(x: xCoordinate, y: 0), isGood: isSlotGood)
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 1136, y: 752)
        addChild(scoreLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Remaining: \(ballsRemaining) ball\(ballsRemaining == 1 ? "" : "s")"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 1136, y: 708)
        addChild(ballsLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 752)
        addChild(editLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 64
        gameOverLabel.fontColor = .red
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: 590, y: 410)
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        tryAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
        tryAgainLabel.text = "Tap to try again!"
        tryAgainLabel.position = CGPoint(x: 590, y: 346)
        tryAgainLabel.isHidden = true
        addChild(tryAgainLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When you touch the screen somehow.
        guard let touch = touches.first else { return } // If the user has touched with 2 or 3 fingers at the same time, get the first.
        let location = touch.location(in: self) // Find where this touch was in my whole game scene.
        
        let objects = nodes(at: location)
        
        if isGameOver {
            isGameOver.toggle()
            return
        }
        
        if objects.contains(editLabel) {
            editingMode.toggle()
            return
        }
        
        if editingMode {
            let size = CGSize(width: Int.random(in: 16...128), height: 16)
            let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
            box.zRotation = CGFloat.random(in: 0...3)
            box.position = location

            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            box.name = "box"

            addChild(box)
        } else if ballsRemaining > 0 {
            ballsRemaining -= 1
            // Create a ball
            let ballNames = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
            let ball = SKSpriteNode(imageNamed: ballNames.randomElement() ?? "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2) // Behave like circle instead of Square
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask // Notify all collisions
            ball.physicsBody?.restitution = 0.4 // Bounciness, 0 not bouncy at all and 1 is super bouncy.
            ball.position = location
            ball.position.y = 820
            ball.name = "ball"
            ballsInGame += 1
            addChild(ball)
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false // The object will not move based on gravity and collisions because this property is set to false
        
        bouncer.scale(to: CGSize(width: 147.5, height: 147.5))
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good" // Give a name to a SKSpriteNode before adding it as a child
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.scale(to: CGSize(width: 147.5, height: 16))
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) // Rotate 180º for 10 seconds
        let spinForever = SKAction.repeatForever(spin) // Repeat animation forever
        slotGlow.run(spinForever) // Add action to SKSpriteNode
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" { // Verifying if one of the two objects that collided is a slot.
            destroy(ball: ball)
            score += 1
            ballsRemaining += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            
            if ballsRemaining == 0 && ballsInGame == 0 {
                isGameOver = true
            }
        }
        // Does nothing if the collision object is also a ball.
        
        if object.name == "box" {
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ballsInGame -= 1
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return } // Avoiding ghost collisions.
        if nodeA.name == "ball" { // Verifying if one of the two objects that collided is a ball.
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func displayGameOver() {
        gameOverLabel.isHidden = false
        tryAgainLabel.isHidden = false
    }
    
    func tryAgain() {
        gameOverLabel.isHidden = true
        tryAgainLabel.isHidden = true
        ballsRemaining = 5
        score = 0
        enumerateChildNodes(withName: "box") { box,_ in
            box.removeFromParent()
        }
    }
}
