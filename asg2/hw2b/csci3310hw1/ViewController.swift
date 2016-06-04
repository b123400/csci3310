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
    @IBOutlet weak var stackView: UILabel!
    
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
        stackView.text = ""
        reloadVariableButtons()
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
            if currentNumberInput != "" {
                calculator.pushNumber((currentNumberInput as NSString).doubleValue)
            }
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
        stackView.text = ""
    }
    
    func tryEvaluate () {
        if let result = calculator.evaluate() {
            displayLabel.text = "\(result)"
        }
        stackView.text = calculator.stackString()
    }
    
    @IBAction func variableButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            calculator.pushVariable(text)
            currentNumberInput = ""
            tryEvaluate()
        }
    }
    
    @IBAction func xInputPressed(sender: AnyObject) {
        getInputForVariableNamed("x")
    }
    
    @IBAction func aInputPressed(sender: AnyObject) {
        getInputForVariableNamed("a")
    }
    
    @IBAction func bInputPressed(sender: AnyObject) {
        getInputForVariableNamed("b")
    }
    
    func reloadVariableButtons () {
        if let value = calculator.valueForVariable("a") {
            aButton.setTitle("\(value)", forState: .Normal)
        }
        
        if let value = calculator.valueForVariable("b") {
            bButton.setTitle("\(value)", forState: .Normal)
        }
        
        if let value = calculator.valueForVariable("x") {
            xButton.setTitle("\(value)", forState: .Normal)
        }
    }
    
    @IBAction func aboutButtonPressed(sender: AnyObject) {
    }
    
    func getInputForVariableNamed(name:String) {
        let alertController = UIAlertController(title: "Enter a number", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let textAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                let value = (text as NSString).doubleValue
                self.calculator.setVariable(name, value: value)
                self.reloadVariableButtons()
            }
        }
        textAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Variable value"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                textAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(textAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

