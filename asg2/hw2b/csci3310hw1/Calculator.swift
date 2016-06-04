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
        case Variable(String)
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
    
    private var variables : [String:Double] = ["x":0, "a":0, "b":0]
    
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
        case .Variable(let name):
            if let num = variables[name] {
                return (num, remaining)
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
    
    func pushVariable(name:String) {
        opStack.append(Op.Variable(name))
    }
    
    func setVariable (name : String, value : Double) {
        variables[name] = value
    }
    
    func stackString () -> String {
        return opStack.map { (op : Op) -> String in
            switch op {
            case .Operand(let num):
                return "\(num)"
            case .BinaryOperation(let name, _):
                return name
            case .Variable(let name):
                return name
            }
        }
            .joinWithSeparator(" ")
    }
    
    func valueForVariable (name:String) -> Double? {
        return variables[name]
    }
    
    
    func clear () {
        opStack = []
        variables = ["x":0, "a":0, "b":0]
    }
}
