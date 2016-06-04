//
//  Calculator.swift
//  csci3310hw1
//
//  Created by b123400 on 2/11/2015.
//  Copyright © 2015 b123400. All rights reserved.
//

import Foundation

class Calculator: NSObject {
    
    enum Op {
        case Operand(Double)
//        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private lazy var knownOps : [String:Op] = [
        "+": Op.BinaryOperation("+", +),
        "-": Op.BinaryOperation("-", { $1 - $0 }),
        "*": Op.BinaryOperation("*", *),
        "/": Op.BinaryOperation("/", { $1 / $0 })
    ]
    
    private var opStack : [Op] = []
    
    func evaluate (ops:[Op]) -> (Double?, [Op]) {
        if ops.isEmpty {
            return (nil, ops)
        }
        var remaining = ops
        let op = remaining.removeLast()
        
        switch (op) {
            
        case .Operand(let num):
            return (num, remaining)
            
        case .BinaryOperation(_, let operate):
            let (op1, remaining1) = evaluate(remaining)
            if let op1 = op1 {
                let (op2, remaining2) = evaluate(remaining1)
                if let op2 = op2 {
                    return (operate(op1, op2), remaining2)
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate () -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushNumber(num:Double) {
        opStack.append(Op.Operand(num))
    }
    
    func pushOperator(input:String) {
        if let op = knownOps[input] {
            opStack.append(op);
        }
    }
    
    func clear () {
        opStack = []
    }
}
