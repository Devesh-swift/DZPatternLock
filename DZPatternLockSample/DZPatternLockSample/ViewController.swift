//
//  ViewController.swift
//  DZPatternLockSample
//
//  Created by Thanh-Dung Nguyen on 2/26/17.
//  Copyright © 2017 Dzung Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DZPatternLockDelegate {

    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var patternView: DZPatternLock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate for patternView
        patternView.delegate = self
        
        // must-have settings
        patternView.imageNormal = #imageLiteral(resourceName: "defaultBalloonNormal.png")
        patternView.imageSelected = #imageLiteral(resourceName: "defaultBalloonSelected.png")
        patternView.strokeColor = UIColor.black.cgColor
        
        // Optional settings
//        patternView.strokeWidth = 5.0
//        patternView.ratio = 0.2
//        patternView.canvasMargin = 40
    }

    // receive pattern
    func didReceivePattern(pattern: [Int]) {
        var resultText = ""
        for index in pattern {
            resultText += String(index)
        }
        
        self.lbResult.text = resultText
    }

}

