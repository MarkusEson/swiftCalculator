//
//  ViewController.swift
//  Calculator
//
//  Created by Markus Eriksson on 2017-12-15.
//  Copyright © 2017 Markus Eriksson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsCurrentlyTyping = false
    
    
    // Lets user touch digit to add it to the display
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsCurrentlyTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
            userIsCurrentlyTyping = true
        }
    }
    
    
    // Gets or Sets a value to / from display. Set takes the value from the right side of = and sets it.
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    // performOperation sends mathematical operations on your display to calc brain and returns result.
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsCurrentlyTyping{
            brain.setOperand(displayValue)
            userIsCurrentlyTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

