//
//  GameScene.swift
//  FindPairProject
//
//  Created by DeNNiO   G on 20.04.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var cardNameSet = Set<String>()
    
    var card1: CardObject!
    var card2: CardObject!
    var card3: CardObject!
    var card4: CardObject!
    var temp: String = ""
    var tempLocation: CGPoint!
    var touchesCounter = 0

    var nodes = [CardObject]()
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -3
        background.isUserInteractionEnabled = false
        addChild(background)
        
        startGame()
        check()
    
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location  = touch.location(in: self)
        print(location)
        if let touchedCard = self.atPoint(location) as? CardObject {
            guard let name = touchedCard.name else {return}
            touchedCard.rotate()
            checkPairs(name: name, counter: touchesCounter, node: touchedCard, nodeLocation: location)
            }
        touchesCounter += 1
        guard let magic = SKEmitterNode(fileNamed: "Magic") else { return  }
        magic.position = location
        addChild(magic)
        }

    func startGame() {
        //generate card objects and add its name to Set
        card1 = CardObject()
        card1.setup(at: CGPoint(x: 150, y: 384))
        card1.zPosition = 1
        cardNameSet.insert("\(card1.name)")
        nodes.append(card1)
        print(card1.name)
        
        card2 = CardObject()
        card2.setup(at: CGPoint(x: 350, y: 384))
        card2.zPosition = 1
        cardNameSet.insert("\(card2.name)")
        print(card2.name)
        
        card3 = CardObject()
        card3.setup(at: CGPoint(x: 550, y: 384))
        card3.zPosition = 1
        cardNameSet.insert("\(card3.name)")
        print(card3.name)
        
        card4 = CardObject()
        card4.setup(at: CGPoint(x: 750, y: 384))
        card4.zPosition = 1
        cardNameSet.insert("\(card4.name)")
        print(card4.name)
       
    }
    
    func addCard() {
        //add card nodes to scene
        addChild(card1)
        addChild(card2)
        addChild(card3)
        addChild(card4)
    }
    
    func check(){
        //check of duplicating names
        switch cardNameSet.count {
        case 0:
            cardNameSet = []
            startGame()
            check()
        case 1:
            cardNameSet = []
            startGame()
            check()
        case 2:
            cardNameSet = []
            startGame()
            check()
        case 3:
            cardNameSet = []
            addCard()
        case 4:
            cardNameSet = []
            startGame()
            check()
        default:
            print("unknown")
        }
    }
    
    
    func checkPairs(name: String, counter: Int, node: CardObject, nodeLocation: CGPoint){
        switch counter {
        case 0:
                temp = name
                tempLocation = nodeLocation
        case 1:
            print(tempLocation)
            if name == temp{
                print("pair")
                node.win()
                if let previousNode = atPoint(tempLocation) as? CardObject{
                    previousNode.win()
                }
            } else {
                print("not pair")
                temp = ""
                node.rotate()
                if let previousNode = atPoint(tempLocation) as? CardObject{
                    previousNode.rotate()
                }
                tempLocation = CGPoint(x: 0, y: 0)
            }
            
        case 2: temp = name
                tempLocation = nodeLocation
        case 3: if name == temp {
                print("pair")
                node.win()
                if let previousNode = atPoint(tempLocation) as? CardObject{
                previousNode.win()
                }
            } else {
                print("not pair")
                temp = ""
                node.rotate()
                if let previousNode = atPoint(tempLocation) as? CardObject{
                    previousNode.rotate()
                }
            }
            
        default:
                print("Gameover")
            
        }
    }
    
    
        
        
        
        
      
        
    
}
