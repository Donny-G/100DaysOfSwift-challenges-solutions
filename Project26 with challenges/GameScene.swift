//
//  GameScene.swift
//  Project26
//
//  Created by Donny G on 15.10.2019.
//  Copyright © 2019 Donny G. All rights reserved.
//
import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portalIn = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var leveLabel: SKLabelNode!
    var level = 1 {
        didSet {
            leveLabel.text = "Level: \(level)"
        }
    }
    
    var isGameOver = false
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        loadBackground()
        createScoreLabel()
        createLevelLabel()
    
        loadLevel()
        createPlayer()
        physicsWorld.gravity = .zero
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        }
        
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch  = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch  = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else {return}
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
               scoreLabel.text = "Score: \(score)"
               scoreLabel.horizontalAlignmentMode = .left
               scoreLabel.position = CGPoint(x: 16, y: 16)
               scoreLabel.zPosition = 2
               addChild(scoreLabel)
    }
    
    func createLevelLabel() {
        leveLabel = SKLabelNode(fontNamed: "Chalkduster")
        leveLabel.text = "Level: \(level)"
        leveLabel.horizontalAlignmentMode = .right
        leveLabel.position = CGPoint(x: 990, y: 16)
        leveLabel.zPosition = 2
        addChild(leveLabel)
    }
    //Challenge 1
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not load level1.txt from the app bundle")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle")
        }
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
            
                switch letter {
                case "x":
                    createBlock(position: position)
                case "v":
                    createVortex(position: position)
                case "s":
                    createStar(position: position)
                case "f":
                    createFinish(position: position)
                //Challenge 3
                case "i":
                    portalIn(position: position)
                case "o":
                portalOut(position: position)
                case " ":
                    continue
                default:
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    //Challenge1
    func createBlock(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    //Challenge1
    func createVortex(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    //Challenge1
    func createStar(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    //Challenge1
    func createFinish(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    //Cgallenge3
    func portalIn(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portalIn")
        node.name = "portalIn"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.categoryBitMask = CollisionTypes.portalIn.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    //Challenge3
    func portalOut(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portalOut")
        node.name = "portalOut"
        node.position = position
        node.physicsBody?.isDynamic = false
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.portalIn.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        //Challenge2
        } else if node.name == "finish" {
            removeAllChildren()
            level += 1
            loadBackground()
            loadLevel()
            createScoreLabel()
            createLevelLabel()
            createPlayer()
        //Challenge 3
        } else if node.name == "portalIn" {
            print("whackhole")
            if let teleport2 =  self.childNode(withName: "portalOut"){
                teleport(from: node.position, to: teleport2.position)
            }
            }
        }
    //Challenge 3
    func teleport (from position1: CGPoint, to position2: CGPoint) {
        let moveToCenterOfPortal = SKAction.move(to: position1, duration: 0.25)
        let scaleIn = SKAction.scale(to: 0.0001, duration: 0.25)
        let moveToNewPosition = SKAction.move(to: position2, duration: 0)
        let scaleOut = SKAction.scale(to: 1, duration: 0.25)
        let sequence = SKAction.sequence([moveToCenterOfPortal, scaleIn, moveToNewPosition, scaleOut])
        player.run(sequence)
    }
    
}
