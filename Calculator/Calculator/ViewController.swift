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
    // the exclamation point (!) while declaring means always automatically unwrap
    // "implicitly unwrapped optional"
    // mostly useful when a variable is set very early and stays set
    @IBOutlet weak var display: UILabel!
    
    // if a type can be inferred, let it (no need for ': Bool')
    var userIsInTheMiddleOfTypingANumber = false
    
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
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        // switch labels variables passed in as $n
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation {sqrt($0)}
        default: break
        }
    }
    
    // function type here "takes in two Doubles and returns a Double"
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
    }
    
    // "computed property" = instance variables that are computed rather than stored
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

