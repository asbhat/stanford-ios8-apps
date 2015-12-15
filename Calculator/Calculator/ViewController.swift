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
    @IBOutlet weak var history: UILabel!
    
    // if a type can be inferred, let it (no need for ': Bool')
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        // the exclamation point (!) unwraps the Optional (will crash if is Nil)
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if (digit == "." && display.text!.rangeOfString(".") == nil) || digit != "." {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func plusMinus() {
        if userIsInTheMiddleOfTypingANumber {
            displayValue! *= -1
        } else {
            performOperation {-1 * $0}
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        history.text = history.text!.stringByReplacingOccurrencesOfString("= ", withString: "")
        history.text = history.text! + " " + operation + "\n="
        // ** TODO ** fix history for multiple operations with no additons to the stack
        switch operation {
        // switch labels variables passed in as $n
            case "×": performOperation {$1 * $0}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$1 + $0}
            case "−": performOperation {$1 - $0}
            case "sin": performOperation {sin($0)}
            case "cos": performOperation {cos($0)}
            case "π": performOperation (M_PI)
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

    // Objective-C does not support method overloading (methods with the same name), but Swift does. Making this function private means the compiler will _not_ try to make sure it works with Obj-C
    // http://stackoverflow.com/questions/29457720/compiler-error-method-with-objective-c-selector-conflicts-with-previous-declara
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(constant: Double) {
        displayValue = constant
        enter()
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        history.text = history.text! + " " + display.text!
        operandStack.append(displayValue!)
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
    }
    
    // "computed property" = instance variables that are computed rather than stored
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = (newValue != nil ? "\(newValue!)" : "0")
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        history.text = ""
        operandStack = []
    }
    
    @IBAction func backspace() {
        if display.text!.characters.count > 1 {
            display.text = String(display.text!.characters.dropLast())
        } else {
            userIsInTheMiddleOfTypingANumber = false
            display.text = "0"
        }
    }
}

