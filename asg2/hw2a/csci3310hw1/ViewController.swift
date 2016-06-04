//
//  ViewController.swift
//  csci3310hw1
//
//  Created by b123400 on 2/11/2015.
//  Copyright © 2015 b123400. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    private var currentNumberInput : String = ""
    private let calculator : Calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func numberPressed(sender: UIButton) {
        let _text = sender.titleLabel?.text
        guard let text = _text else { return }
        
        currentNumberInput += text
        displayLabel.text = currentNumberInput
    }
    
    @IBAction func operatorPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            calculator.pushNumber((currentNumberInput as NSString).doubleValue)
            currentNumberInput = ""
            calculator.pushOperator(text)
            tryEvaluate()
        }
    }
    
    @IBAction func enterPressed(sender: AnyObject) {
        if currentNumberInput != "" {
            calculator.pushNumber((currentNumberInput as NSString).doubleValue)
            currentNumberInput = ""
            tryEvaluate()
        }
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        calculator.clear()
        currentNumberInput = ""
        displayLabel.text = "0"
    }
    
    func tryEvaluate () {
        if let result = calculator.evaluate() {
            displayLabel.text = "\(result)"
        }
    }
}

