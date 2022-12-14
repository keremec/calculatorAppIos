//
//  ViewController.swift
//  calculatorApp
//
//  Created by Kerem Safa Dirican on 13.08.2022.
//


import UIKit

let listOfNumbers : [Character] = ["1","2","3","4","5","6","7","8","9","0"]

class ViewController: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var tLabel: UILabel!
    
    @IBOutlet weak var bLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tLabel.text = ""
        bLabel.text = "0"
        
    }
    
    
    //    Actions
    
    @IBAction func buttonDel(_ sender: Any) {
        
        //first overflow check
        _ = overflowProtect(s: &bLabel.text!, t: &tLabel.text!, w: &warningLabel.text!)
        
        _ = bLabel.text?.popLast()
        var exp = bLabel.text!
        
        //Auto add 0 to main label and clear secondary label if main label empty
        if(bLabel.text?.count == 0){
            bLabel.text = "0"
            tLabel.text = ""
        }
        // prevent calculation when deleting if - remain as a result of a negative calculation
        else if(bLabel.text == "-"){
            tLabel.text = ""
        }
        // do calculation when deleting characters also if exp.last is a operator, this deletes tge last operator from calculation string
        else if(exp.contains("+")||exp.contains("-")||exp.contains("×")||exp.contains("÷")||exp.contains("%")){
            if(!listOfNumbers.contains(exp.last!)){
                _ = exp.popLast()
            }
            tLabel.text = calculateResult(s: exp).cleanValue
        }
        
        //last overflow check after operation
        _ = overflowProtect(s: &bLabel.text!, t: &tLabel.text!, w: &warningLabel.text!)
        
        
    }
    
    @IBAction func buttonClear(_ sender: Any) {
        tLabel.text = ""
        bLabel.text = "0"
    }
    
    
    @IBAction func buttonPercentage(_ sender: Any) {
        buttonClick(b: "%", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonDiv(_ sender: Any) {
        buttonClick(b: "÷", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonMul(_ sender: Any) {
        buttonClick(b: "×", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonSub(_ sender: Any) {
        buttonClick(b: "-", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonAdd(_ sender: Any) {
        buttonClick(b: "+", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonEqual(_ sender: Any) {
        bLabel.text = tLabel.text == "" ? bLabel.text : tLabel.text
        tLabel.text = ""
    }
    
    
    //    Numpad
    
    @IBAction func buttonDecimal(_ sender: Any) {
        buttonClick(b: ".", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonZero(_ sender: Any) {
        buttonClick(b: "0", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonOne(_ sender: Any) {
        buttonClick(b: "1", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonTwo(_ sender: Any) {
        buttonClick(b: "2", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonThree(_ sender: Any) {
        buttonClick(b: "3", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonFour(_ sender: Any) {
        buttonClick(b: "4", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonFive(_ sender: Any) {
        buttonClick(b: "5", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonSix(_ sender: Any) {
        buttonClick(b: "6", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonSeven(_ sender: Any) {
        buttonClick(b: "7", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonEight(_ sender: Any) {
        buttonClick(b: "8", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
    
    @IBAction func buttonNine(_ sender: Any) {
        buttonClick(b: "9", s: &bLabel.text!, t:&tLabel.text!, w:&warningLabel.text!)
    }
}

func buttonClick(b:String, s:inout String, t:inout String, w:inout String){
    
    // if there is a overflow or an error, input buttons will not work
    if(overflowProtect(s: &s, t: &t, w: &w)){
        return
    }
    
    switch b {
        
    case ".":
        if(s.last == "."){
            break
        }
        else if(!listOfNumbers.contains(s.last!)){
            s += "0."
        }
        else{
            // guard prevents writing ip adresses on the calculator
            let splits = s.components(separatedBy: ["+", "*", "-", "/", "%"])
            guard (splits.last!.contains(".")) else {
                s += "."
                break
            }
            
        }
        
    case "+", "-", "÷", "×", "%":
        // allows using minus operator to use when writing negative numbers
        // user cant add + to the start because default is already positive
        if(s == "0" ){
            if(b == "-"){
                _ = s.popLast()
                s += b
            }
            break
        }
        //because minus button not acting as operator but as a negative symbol
        //this one simply change - to + (or revese) instead of just removing - for better feedback
        //+ will be removed when entering number
        else if((s == "-" || s == "+") && (b == "-" || b == "+")){
            _ = s.popLast()
            s += b
        }
        // turns this "2.+3" to this "2+3"
        else if(s.last == "."){
            _ = s.popLast()
            s += b
        }
        // prevents "+*", "÷-" etc situations. negative declaration via minus is only allowed in the first entry
        else if(!listOfNumbers.contains(s.last!)){
            break
        }
        else{
            s += b
        }
        
    default:
        //removes placeholder zero and +
        if(s == "0" || s == "+" || s == "-0"){
            _ = s.popLast()
        }
        s += b
    }
    
    
    
    
    //Making Calculation
    if(listOfNumbers.contains(s.last!) && (s.contains("+")||s.contains("-")||s.contains("×")||s.contains("÷")||s.contains("%"))){
        t = calculateResult(s: s).cleanValue
    }
    
    
}


// calculation function
func calculateResult(s:String) -> Double {
    
    
    var exp = s
    
    // change visual operators to real operators for nsexpression
    exp = exp.replacingOccurrences(of: "×", with: "*")
    exp = exp.replacingOccurrences(of: "÷", with: "/")
    exp = exp.replacingOccurrences(of: "%", with: "/100*")
    
    //to get a double result from NSEexpression, one of the input should be double. This function do that.
    exp = fixDecimalDivision(s: exp)
    
    let expression = NSExpression(format: exp)
    
    if var result = expression.expressionValue(with: nil, context: nil) as? Double{
        //round the decimal points and limit the decimal area. example: 10 = smaller decimal part. 100000 = bigger decimal part
        result = Double(round(1000000*result)/1000000)
        return result
    }
    else{
        //      LEBLEBI
        return -1837837
    }
    
}

func fixDecimalDivision(s:String) -> String {
    var exp = s
    //because only division operator can create a non Integer result
    //this function split the string by other operators and find the division operations
    //if division operations don't have decimal point they are adding to the toDel array
    //because having only one double operand is enough for gettin double result
    // this funcion adds .0 to the second operand of the divison operation
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

func overflowProtect(s:inout String, t:inout String, w:inout String) -> Bool{
    
    // auto clear results if a large number, x/0 result or somehow irrational etc received
    if (t.contains("e") || t.contains("i") ){
        w = "!"
        return true
    }
    //also delete button will act like clear button if a large number, x/0 result or somehow irrational etc received
    if (s.contains("e") || s.contains("i") ){
        t = ""
        s = "0"
    }
    
    //prevent overflow, not always reliable but thats the safe range for double, no e10,e11 etc support :(
    guard (t.count < 10) else{
        w = "!"
        return true
    }
    
    let splits = s.components(separatedBy: ["+", "*", "-", "/", "%"])
    guard (splits.last!.count < 10 && s.count < 30) else{
        w = "!"
        return true
    }
    
    w = ""
    return false
    
}


// cool extension for double. If decimal point is zero, it just removes it. also return it as a string
extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
}
