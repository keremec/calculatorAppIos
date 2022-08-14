//
//  ViewController.swift
//  calculatorApp
//
//  Created by Kerem Safa Dirican on 13.08.2022.
//


//TODO Birden fazla nokta eklenebilme sorununu.

import UIKit

let listOfNumbers : [Character] = ["1","2","3","4","5","6","7","8","9","0"]

class ViewController: UIViewController {
    

    @IBOutlet weak var tLabel: UILabel!
    
    @IBOutlet weak var bLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tLabel.text = ""
        bLabel.text = "0"
        
    }

    
    //    Actions
    
    @IBAction func buttonDel(_ sender: Any) {
        _ = bLabel.text?.popLast()
        var exp = bLabel.text!
        if(bLabel.text?.count == 0){
            bLabel.text = "0"
            tLabel.text = ""
        }
        else if (exp.contains("e")){
            tLabel.text = ""
            bLabel.text = "0"
        }
        else if(exp.contains("+")||exp.contains("-")||exp.contains("×")||exp.contains("÷")||exp.contains("%")){
            if(!listOfNumbers.contains(exp.last!)){
                _ = exp.popLast()
            }
            tLabel.text = calculateResult(s: exp).cleanValue
        }
        
        
    }
    
    @IBAction func buttonClear(_ sender: Any) {
        tLabel.text = ""
        bLabel.text = "0"
    }
    
    
    @IBAction func buttonPercentage(_ sender: Any) {
        buttonClick(b: "%", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonDiv(_ sender: Any) {
        buttonClick(b: "÷", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonMul(_ sender: Any) {
        buttonClick(b: "×", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonSub(_ sender: Any) {
        buttonClick(b: "-", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonAdd(_ sender: Any) {
        buttonClick(b: "+", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonEqual(_ sender: Any) {
        bLabel.text = tLabel.text == "" ? bLabel.text : tLabel.text
        // TODO BURADAN BASAMAK UZUNLUK KONTROLU YAP
        tLabel.text = ""
    }
    
    
    //    Numpad
    
    @IBAction func buttonDecimal(_ sender: Any) {
        buttonClick(b: ".", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonZero(_ sender: Any) {
        buttonClick(b: "0", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonOne(_ sender: Any) {
        buttonClick(b: "1", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonTwo(_ sender: Any) {
        buttonClick(b: "2", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonThree(_ sender: Any) {
        buttonClick(b: "3", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonFour(_ sender: Any) {
        buttonClick(b: "4", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonFive(_ sender: Any) {
        buttonClick(b: "5", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonSix(_ sender: Any) {
        buttonClick(b: "6", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonSeven(_ sender: Any) {
        buttonClick(b: "7", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonEight(_ sender: Any) {
        buttonClick(b: "8", s: &bLabel.text!, t:&tLabel.text!)
    }
    
    @IBAction func buttonNine(_ sender: Any) {
        buttonClick(b: "9", s: &bLabel.text!, t:&tLabel.text!)
    }
}

func buttonClick(b:String, s:inout String, t:inout String){

    
    switch b {
        
    case ".":
        //prevent adding more zeros to the start
        if(s.count == 0 ){
            s += "0."
        }
        else if(s.last == "."){
            break
        }
        else if(!listOfNumbers.contains(s.last!)){
            s += "0."
        }
        else{
            s += "."
        }
        
    case "+", "-", "÷", "×", "%":
        if(s.count == 0 ){
           break
        }
        else if(s.last == "."){
            _ = s.popLast()
            s += b
        }
        else if(!listOfNumbers.contains(s.last!)){
            break
        }
        else{
            s += b
        }

        
    case "0":
        //prevent adding more zeros to the start
        guard(s.count == 1 && s.last == "0")else{
            s += b
            break
        }
        
    default:
        //remove unwanted zero
        if(s.count == 1 && s.last == "0"){
            _ = s.popLast()
        }
        s += b
    }
    
    
    //Preperaing for NSExpression
    

    
    //Making Calculation
    if(listOfNumbers.contains(s.last!) && (s.contains("+")||s.contains("-")||s.contains("×")||s.contains("÷")||s.contains("%"))){
        t = calculateResult(s: s).cleanValue
    }
    

}

func calculateResult(s:String) -> Double {
    
    
    var exp = s
    
    exp = exp.replacingOccurrences(of: "×", with: "*")
    exp = exp.replacingOccurrences(of: "÷", with: "/")
    exp = exp.replacingOccurrences(of: "%", with: "/100*")
    
    exp = fixDecimalDivision(s: exp)
    
    let expression = NSExpression(format: exp)
    
    if let result = expression.expressionValue(with: nil, context: nil) as? Double{
        return result
    }
    else{
        return -1
    }
    
}

func fixDecimalDivision(s:String) -> String {
    var exp = s
    let splits = exp.components(separatedBy: ["+", "*", "-"])
    var toDel: [String] = []
    for i in splits{
        if (i.contains("/") && !i.contains(".")){
            toDel.append(i)
        }
    }
    
    for i in toDel {
        exp = exp.replacingOccurrences(of: i, with: i + ".0")
    }
    
    return exp
}


extension Double {
    var cleanValue: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

}
