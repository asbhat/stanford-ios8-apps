//
//  ViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 2/17/15.
//  Copyright (c) 2015 Aditya Bhat. All rights reserved.
//

import UIKit

// this is a bad name for a controller, but keeping it at default for now...
class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        // the exclamation point (!) unwraps the Optional (will crash if is Nil)
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    

}

