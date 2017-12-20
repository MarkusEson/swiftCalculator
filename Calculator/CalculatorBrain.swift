//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Markus Eriksson on 2017-12-17.
//  Copyright © 2017 Markus Eriksson. All rights reserved.
//

import Foundation
// we did not import UIKit here because we will NOT affect the UI here at all.
// This is 100% done in the "background"


func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}


struct CalculatorBrain{
    
    private var accumulator: Double?
    
    // new type that can handle doubles and functions
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    
    // hash table string = value
    private var operations: Dictionary<String, Operation> =
        [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt), //sqrt(Double)
            "sin" : Operation.unaryOperation(sin),
            "cos" : Operation.unaryOperation(cos),
            "tan" : Operation.unaryOperation(tan),
            "inv" : Operation.unaryOperation( { $0 / 100 } ),
            "±" : Operation.unaryOperation(changeSign),
            // can be ( { -$0 } )
            "×" : Operation.binaryOperation({(op1: Double, op2: Double) -> Double in return op1 * op2}),
            // can be beautified to ( { $0 * $1 } ) because types are inferred, and return is also inferred.
            "+" : Operation.binaryOperation( { $0 + $1 } ),
            "-" : Operation.binaryOperation( { $0 - $1 } ),
            "÷" : Operation.binaryOperation( { $0 / $1 } ),
            "x^2" : Operation.unaryOperation( { pow($0, 2) } ),
            "=" : Operation.equals
            
        ]
    
    // perform the operation and set accumulator
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // performs the op
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}
