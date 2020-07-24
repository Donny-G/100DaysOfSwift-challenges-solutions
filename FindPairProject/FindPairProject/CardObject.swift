//
//  CardObject.swift
//  FindPairProject
//
//  Created by DeNNiO   G on 20.04.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import UIKit
import SpriteKit


class CardObject: SKSpriteNode {
    
    var nameTexture: [String: SKTexture] = ["card1": SKTexture(imageNamed: "card1"), "card2": SKTexture(imageNamed: "card2"),"card3": SKTexture(imageNamed: "card3"), "card4": SKTexture(imageNamed: "card4")]
    
    var isOpen = false
    
    var hiddenTexture: SKTexture!
    
    func setup(at: CGPoint) {
      for (cardName, cardTexture) in nameTexture{
          switch Int.random(in: 0...3){
          case 0:
          texture = SKTexture(imageNamed: "back")
          hiddenTexture = cardTexture
          name = cardName
          case 1:
            texture = SKTexture(imageNamed: "back")
            hiddenTexture = cardTexture
            name = cardName
          case 2:
            texture = SKTexture(imageNamed: "back")
            hiddenTexture = cardTexture
            name = cardName
          case 3:
            texture = SKTexture(imageNamed: "back")
            hiddenTexture = cardTexture
            name = cardName
          default:
            break
           }
        }
       position = at
       size = CGSize(width: 150, height: 200)
    }
    
    func rotate() {
        let rotation1 = SKAction.scaleX(to: 0, duration: 0.4)
        let rotation2 = SKAction.scaleX(to: 1, duration: 0.4)
        if !isOpen {
            run(rotation1) {
                self.texture = self.hiddenTexture
                self.run(rotation2)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.run(rotation1) {
                self.texture = SKTexture(imageNamed: "back")
                self.run(rotation2)
                }
            }
        }
        isOpen = true
    }
        
    func rotateBack(){
        if isOpen {
            let delay = SKAction.animate(with: [hiddenTexture , SKTexture(imageNamed: "back")], timePerFrame: 2)
            self.run(delay)
        }
    }
    
    func win() {
        let rotation1 = SKAction.rotate(byAngle: 4, duration: 2)
        let rotation2 = SKAction.rotate(byAngle: -4, duration: 2)
        let sequence = SKAction.sequence([rotation1, rotation2])
        self.run(sequence)
    }
  

}
