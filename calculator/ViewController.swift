//
//  ViewController.swift
//  calculator
//
//  Created by Елизавета Хворост on 16/11/2022.
//

import UIKit

class ViewController: UIViewController
{
    enum CalcOperation: Int
    {
        case divide = 0
        case muptiply
        case subtract
        case append
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var acButton: CalculatorButton!
    
    let maxDecimalsAmount = 9
    var tempNumber: NSNumber?
    var tempActionNumber: NSNumber?
    var tempActionButton: UIButton?
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func acPressed(_ sender: UIButton)
    {
        if self.tempActionButton == nil || self.tempActionNumber != nil
        {
            self.resultLabel.text = "0"
        }
        sender.setTitle("AC", for: .normal)
        if self.tempActionNumber != nil
        {
            self.tempActionNumber = nil
            self.tempActionButton = nil
            self.tempNumber = nil
        }
        else if self.tempActionButton?.isSelected == true
        {
            self.setButton(self.tempActionButton, selected: false)
            self.tempActionButton = nil
        }
        else
        {
            self.setButton(self.tempActionButton, selected: true)
        }
    }
    
    @IBAction func plusMinusPressed(_ sender: Any)
    {
        var currentText = self.resultLabel.text ?? "0"
        if currentText == "0,"
        {
            self.resultLabel.text = "0"
            currentText = "0"
        }
        if currentText != "0"
        {
            if currentText.hasPrefix("-")
            {
                self.resultLabel.text = currentText.replacingOccurrences(of: "-", with: "")
            }
            else
            {
                self.resultLabel.text = "-" + currentText
            }
        }
    }
    
    @IBAction func percentPressed(_ sender: Any)
    {
        if let text = self.resultLabel.text, let number = self.getNumberFrom(text)
        {
            let newValue = number.doubleValue * 0.01
            let newNumber = NSNumber(value: newValue)
            self.resultLabel.text = self.getStringFrom(newNumber)
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton)
    {
        self.initNewSessionIfNeeds()
        if self.getDecimalsAmount(from: self.resultLabel.text) >= self.maxDecimalsAmount
        {
            return
        }
        self.acButton.setTitle("C", for: .normal)
        if self.resultLabel.text == "0" || (self.tempActionButton != nil && self.tempActionButton?.isSelected == true)
        {
            self.setButton(self.tempActionButton, selected: false)
            self.resultLabel.text = sender.title(for: .normal)
        }
        else
        {
            let currentString = self.resultLabel.text ?? ""
            let curentNumber = sender.title(for: .normal) ?? ""
            self.resultLabel.text = currentString + curentNumber
        }
    }
    
    @IBAction func commaPressed(_ sender: Any)
    {
        self.initNewSessionIfNeeds()
        if self.getDecimalsAmount(from: self.resultLabel.text) >= self.maxDecimalsAmount
        {
            return
        }
        self.acButton.setTitle("C", for: .normal)
        if let text = self.resultLabel.text, text.contains(",") == false
        {
            if self.tempActionButton != nil && self.tempActionButton?.isSelected == true
            {
                self.setButton(self.tempActionButton, selected: false)
                self.resultLabel.text = "0,"
            }
            else
            {
                self.resultLabel.text = text + ","
            }
        }
    }
    
    @IBAction func zeroPressed(_ sender: UIButton)
    {
        self.initNewSessionIfNeeds()
        if self.getDecimalsAmount(from: self.resultLabel.text) >= self.maxDecimalsAmount
        {
            return
        }
        if let text = self.resultLabel.text, text != "0"
        {
            if self.tempActionButton != nil && self.tempActionButton?.isSelected == true
            {
                self.setButton(self.tempActionButton, selected: false)
                self.resultLabel.text = "0"
            }
            else
            {
                self.resultLabel.text = text + "0"
            }
        }
    }
    
    @IBAction func actionPressed(_ sender: UIButton)
    {
        if self.tempActionButton != nil
        {
            if let temp = self.tempNumber, let current = self.getNumberFrom(self.resultLabel.text ?? "0")
            {
                if temp.isEqual(to: current) == false
                {
                    self.calculate()
                }
            }
        }
        self.tempActionNumber = nil
        self.setButton(self.tempActionButton, selected: false)
        self.tempActionButton = sender
        self.setButton(sender, selected: true)
        self.tempNumber = self.getNumberFrom(self.resultLabel.text ?? "0")
    }
    
    @IBAction func getResultPressed(_ sender: Any)
    {
        self.setButton(self.tempActionButton, selected: false)
        self.calculate()
    }
    
    //MARK: - Helpers
    
    private func calculate()
    {
        if self.tempActionNumber == nil
        {
            self.tempActionNumber = self.getNumberFrom(self.resultLabel.text ?? "0")
        }
        if let firstNumber = self.tempNumber,
            let secondNumber = self.tempActionNumber,
            let actionButton = self.tempActionButton,
           let operation = CalcOperation(rawValue: actionButton.tag)
        {
            let newNumber = self.getNumberFrom(operation: operation, first: firstNumber, second: secondNumber)
            self.resultLabel.text = self.getStringFrom(newNumber)
            self.tempNumber = newNumber
        }
    }
    
    private func initNewSessionIfNeeds()
    {
        if self.tempActionNumber != nil
        {
            self.resultLabel.text = "0"
            self.tempNumber = nil
            self.tempActionNumber = nil
            self.tempActionButton = nil
        }
    }
    
    private func getDecimalsAmount(from text: String?) -> Int
    {
        if let textString = text
        {
            return textString.replacingOccurrences(of: ",", with: "").count
        }
        return 0
    }
    
    private func getNumberFrom(_ text: String) -> NSNumber?
    {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.minusSign = "-"
        return formatter.number(from: text)
    }
    
    private func getStringFrom(_ number: NSNumber) -> String?
    {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.minusSign = "-"
        formatter.maximumFractionDigits = 10
        if number.int64Value > 999999999 || (number.doubleValue < 0.000000001 && number.doubleValue > 0)
        {
            formatter.numberStyle = .scientific
        }
        else
        {
            formatter.numberStyle = .none
        }
        return formatter.string(from: number)
    }
    
    private func setButton(_ button: UIButton?, selected: Bool)
    {
        if selected
        {
            button?.isSelected = true
            button?.setTitleColor(.systemOrange, for: .selected)
            button?.backgroundColor = .white
        }
        else
        {
            button?.isSelected = false
            button?.backgroundColor = .systemOrange
            button?.setTitleColor(.white, for: .normal)
        }
    }
    
    func getNumberFrom(operation: CalcOperation, first: NSNumber, second: NSNumber) -> NSNumber
    {
        switch operation {
        case .divide:
            return NSNumber(value: first.doubleValue / second.doubleValue)
        case .muptiply:
            return NSNumber(value: first.doubleValue * second.doubleValue)
        case .subtract:
            return NSNumber(value: first.doubleValue - second.doubleValue)
        case .append:
            return NSNumber(value: first.doubleValue + second.doubleValue)
        }
    }
}

