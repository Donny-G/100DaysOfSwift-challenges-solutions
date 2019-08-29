//
//  GameScene.swift
//  Project 14
//
//  Created by Donny G on 28/08/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var numRounds = 0
    var slots = [WhackSlot]()
    var gamescore: SKLabelNode!
    var score = 0 {
        didSet{
            gamescore.text = "Score: \(score)"
        }
    }
    var popupTime = 0.85
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gamescore = SKLabelNode(fontNamed: "Chalkduster")
        gamescore.text = "Score: 0"
        gamescore.position = CGPoint(x: 8, y: 8)
        gamescore.horizontalAlignmentMode = .left
        gamescore.fontSize = 48
        addChild(gamescore)
        
        for i in 0 ..< 5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
        }
        for i in 0 ..< 4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
        }
        for i in 0 ..< 5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        for i in 0 ..< 4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                [weak self] in
                self?.createEnemy()
            }
        }
    }
    
    func createSlot(at position: CGPoint)  {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy () {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            run(SKAction.playSoundFileNamed("gameover.m4a", waitForCompletion: false))
            let gameOverLabel = SKLabelNode(text: "Score is: \(score)")
            gameOverLabel.fontSize = 48
            gameOverLabel.fontName = "Helvetica-Bold"
            gameOverLabel.position = CGPoint(x: 512, y: 250)
            gameOverLabel.zPosition = 1
            addChild(gameOverLabel)
            return
        }
        
        popupTime *= 0.991
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else {continue}
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}
            whackSlot.hit()
            
            if node.name == "charFriend" {
               score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.yScale = 0.85
                if let particles = SKEmitterNode(fileNamed: "Hit") {
                    particles.position = whackSlot.position
                    addChild(particles)
                }
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
        }
    }
    }
}
