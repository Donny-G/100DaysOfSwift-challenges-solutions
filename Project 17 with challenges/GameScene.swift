//
//  GameScene.swift
//  Project17
//
//  Created by Donny G on 14/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var newGameButton: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    
    //add hyper drive counter and label for hyper drive mode
    var hyperDriveCellLabel: SKLabelNode!
    var hyperDriveCell = 4 {
        willSet {
            hyperDriveCellLabel.text = "Hyper Drive Cell: \(hyperDriveCell - 1)"
        }
    }
    
    var enemiesGenerationInterval = 1.0 {
        didSet {
            print(enemiesGenerationInterval)
        }
    }
    
    var enemiesCounter = 0 {
        didSet {
            print(enemiesCounter)
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        //hyper drive cell label
        hyperDriveCellLabel = SKLabelNode(fontNamed: "Chalkduster")
        hyperDriveCellLabel.position = CGPoint(x: 16, y: 726)
        hyperDriveCellLabel.horizontalAlignmentMode = .left
        addChild(hyperDriveCellLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        newGame()
        }
    
    func newGame() {
        isGameOver = false
        hyperDriveCell = 4
        score = 0
       // var enemiesGenerationInterval = 1.0
      //  var enemiesCounter = 0
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        startTimer()
       
    }
    //Challenge 3
    func gameOver() {
        gameTimer?.invalidate()
        newGameButton = SKSpriteNode(imageNamed: "newgame")
        newGameButton.position = CGPoint(x: 500, y: 400)
        addChild(newGameButton)
    }
    
    func startTimer(){
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: enemiesGenerationInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else
        {return}
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        
        enemiesCounter += 1
        if enemiesCounter.isMultiple(of: 20) {
            enemiesGenerationInterval -= 0.1
            startTimer()
        }
        
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for  node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    
    //Challenge 1
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //hyper drive counter condition to avoid reverse count
        if !isGameOver {
            hyperDriveCell -= 1
        }
        //condition for using only 3 hyper drive cells and stop explosition if the ship was already destroyed
        if hyperDriveCell == 0 && children.contains(player) {
        let explosition = SKEmitterNode(fileNamed: "explosion")!
        explosition.position = player.position
        addChild(explosition)
        player.removeFromParent()
        isGameOver = true
        gameOver()
        } else {
            return
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosition = SKEmitterNode(fileNamed: "explosion")!
        explosition.position = player.position
        addChild(explosition)
        player.removeFromParent()
        isGameOver = true
        gameOver()
    }
    //new game button touch method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        newGameButton.position = location
        guard let ngb = newGameButton else {return}
        
            ngb.removeFromParent()
        newGame()
        }
    }
    
}
