//
//  ViewController.swift
//  Project27
//
//  Created by Donny G on 18.10.2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentDrawType = 0
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawEmoji()
        case 2:
           drawTwins()
        case 3:
            drawCircle()
        case 4:
            drawCheckerboard()
        case 5:
            drawRotatedSquares()
        case 6:
            drawLines()
        case 7:
            drawImagesAndText()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image {ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            
            ctx.cgContext.translateBy(x: 256, y: 256)
            let rotatitions = 16
            let amount = Double.pi / Double(rotatitions)
            for _ in 0 ..< rotatitions {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi/2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = img
    }
    
    //Challenge 3
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            //body
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //eye1
            let rectangleForEye1 = CGRect(x: 100, y: 160, width: 50, height: 50)
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            
            ctx.cgContext.addEllipse(in: rectangleForEye1)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //eye2
            let rectangleForEye2 = CGRect(x: 362, y: 160, width: 50, height: 50)
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
                       
            ctx.cgContext.addEllipse(in: rectangleForEye2)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //smile
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.move(to: CGPoint(x: 76, y: 390))
            ctx.cgContext.addLine(to: CGPoint(x: 436, y: 390))
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.move(to: CGPoint(x: 80, y: 390))
            ctx.cgContext.addLine(to: CGPoint(x: 256, y: 430))
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.move(to: CGPoint(x: 256, y: 430))
            ctx.cgContext.addLine(to: CGPoint(x: 436, y: 390))
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.strokePath()
            //cheeks
            let leftCheek = CGRect(x: 40, y: 250, width: 90, height: 90)
            ctx.cgContext.setFillColor(UIColor.purple.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            ctx.cgContext.addEllipse(in: leftCheek)
            ctx.cgContext.drawPath(using: .fillStroke)
            let rightCheek = CGRect(x: 362, y: 250, width: 90, height: 90)
            ctx.cgContext.setFillColor(UIColor.purple.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            ctx.cgContext.addEllipse(in: rightCheek)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    //Challenge 2
    func drawTwins() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            //T
            
            ctx.cgContext.move(to: CGPoint(x: 50, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 150, y: 200))
            ctx.cgContext.move(to: CGPoint(x: 100, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 300))
            
            //W
            ctx.cgContext.move(to: CGPoint(x: 160, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 170, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 200, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 230, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 240, y: 200))
            
            //I
            ctx.cgContext.move(to: CGPoint(x: 250, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 270, y: 200))
            ctx.cgContext.move(to: CGPoint(x: 260, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 260, y: 300))
            ctx.cgContext.move(to: CGPoint(x: 250, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 270, y: 300))
            
            //N
            ctx.cgContext.move(to: CGPoint(x: 280, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 280, y: 200))
            ctx.cgContext.addLine(to: CGPoint(x: 310, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 310, y: 200))
            
            ctx.cgContext.strokePath()
    }
        imageView.image = img
    }

}

