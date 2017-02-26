//
//  DZPatternLock.swift
//  aPiP
//
//  Created by Dzung Nguyen on 3/21/16.
//  Copyright © 2016 DzungNguyen. All rights reserved.
//

import UIKit

protocol DZPatternLockDelegate: class {
    func didReceivePattern(pattern: [Int])
}

class DZPatternLock: UIView {

    // MARK: Declaration
    var arrayButton: [UIButton] = []
    var isDrawing = false
    var arrayPattern: [Int] = []
    var isFirst = true
    var drawView: UIView?
    var lastPoint: CGPoint!
    
    // For settings
    var imageNormal: UIImage!
    var imageSelected: UIImage!
    var strokeColor: CGColor!
    var strokeWidth: CGFloat = 5.0
    var ratio: Float = 0.2
    var canvasMargin: Float = 0
    
    weak var delegate:DZPatternLockDelegate?
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleDrag(sender:)))
        self.addGestureRecognizer(dragGesture)
    }
    
    // MARK: Draw views
    override func draw(_ rect: CGRect) {
        if (isFirst) {
            isFirst = false
         
            self.drawView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            
            
            self.addSubview(drawView!)
            
            // init 9 buttons for pattern code
            self.initButton()
            return;
        }
        
        self.resetDrawing()
        if arrayPattern.count < 1 {
            return
        }
        let path = UIBezierPath()
        
        
        let firstButton = arrayButton[arrayPattern.first!]
        let firstRect = firstButton.frame
        let firstPoint = CGPoint(x: firstRect.origin.x+firstRect.width/2, y: firstRect.origin.y+firstRect.height/2)
        
        path.move(to: firstPoint)
        
        for index in arrayPattern {
            let button = arrayButton[index]
            let rect = button.frame
            let point = CGPoint(x: rect.origin.x+rect.width/2, y: rect.origin.y+rect.height/2)
            path.addLine(to: point)
        }
        path.addLine(to: lastPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = strokeWidth
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.drawView?.layer.addSublayer(shapeLayer)
    }
    
    func initButton() {
        // initialize frames for buttons
        let canvasSize = Float(self.frame.height)
        let buttonSize = canvasSize * ratio
        
        let space = (canvasSize - buttonSize*3 - canvasMargin*2) / 2
        let firstX = canvasMargin
        let firstY = canvasMargin
        
        for i in 0...8 {
            let row = i / 3
            let column = i % 3
            
            let x = Int(firstX) + column * Int(buttonSize + space)
            let y = Int(firstY) + row * Int(buttonSize + space)
            
            let rect : CGRect = CGRect(x: x, y: y, width: Int(buttonSize), height: Int(buttonSize))
            
            // add UIButton
            let button = UIButton(frame: rect)
            button.backgroundColor = UIColor.clear
            button.setImage(imageNormal, for: .normal)
            
            button.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchDown)
            self.addSubview(button)
            
            self.arrayButton.append(button)
        }
    }
    
    func handleDrag(sender: UIPanGestureRecognizer?) {
        if (sender?.state == UIGestureRecognizerState.began) {
            // start dragging
            // do nothing, because it's has been caught in tapButton:
            return;
        }
        if (sender?.state == UIGestureRecognizerState.ended) {
            // end dragging
            self.endDragging(sender: sender)
            return;
        }

        // dragging
        self.dragging(sender: sender)
    }
    
    func dragging(sender: UIPanGestureRecognizer?) {
        let endPoint = sender?.location(in: self)
        
        // check if point inside a button
        for index in 0..<arrayButton.count {
            let button = arrayButton[index]
            let rect = button.frame
            
            if rect.contains(endPoint!) {
                // point inside a button
                if !arrayPattern.contains(index) {
                    // point not added to arrayPattern
                    arrayPattern.append(index)
                    button.setImage(imageSelected, for: .normal)
                } else {
                    // do nothing
                }
            }
        }
        
        lastPoint = endPoint
        self.setNeedsDisplay()
    }
    
    func endDragging(sender: UIPanGestureRecognizer?) {
        // end dragging
        self.delegate?.didReceivePattern(pattern: arrayPattern)
        self.reset()
    }
    
    func tapButton(sender: UIButton) {
        let index : Int = arrayButton.index(of: sender)!
        arrayPattern.append(index)

        DispatchQueue.main.async {
            sender.setImage(self.imageSelected, for: .normal)
        }
    }
    
    // MARK: Reset
    func resetDrawing() {
        if let sublayers = self.drawView?.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func reset() {
        resetDrawing()
        arrayPattern.removeAll()
        self.setNeedsDisplay()
        
        for button in arrayButton {
            button.setImage(imageNormal, for: .normal)
        }
    }
}
