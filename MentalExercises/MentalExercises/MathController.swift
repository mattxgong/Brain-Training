//
//  ViewController.swift
//  MentalExercises
//
//  Created by Grace Chen on 2022-07-01.
//

import UIKit

class MathController: UIViewController {

    @IBOutlet var firstNumber: UILabel!
    @IBOutlet var secondNumber: UILabel!
    @IBOutlet var mathOperator: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var userAnswer: UITextField!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var timeButton: UIButton!
    @IBOutlet var infiniteButton: UIButton!
    
    var correctResponses: [String] = ["Correct!", "Congratulations!", "Excellent!", "Amazing!", "Great Job!"]
    var score: Int = 0
    var correctAnswer: Int = 0
    var usedOperator: [String] = ["+", "-"]
    var bounds: [Int] = [2, 100]
    var operatorIndex: Int = 0
    var myTimer: Timer?
    var timeAllotted: Int = 60
    var counter: Int = 60
    var messageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        timerLabel.text = String(timeAllotted)
        scoreLabel.text = NSLocalizedString("Score", comment: "") + ": 0"
        checkButton.setTitle(NSLocalizedString("Check", comment: ""), for: UIControl.State.normal)
        skipButton.setTitle(NSLocalizedString("Skip", comment: ""), for: UIControl.State.normal)
        timeButton.setTitle(NSLocalizedString("More Time", comment: ""), for: UIControl.State.normal)
        infiniteButton.setTitle(NSLocalizedString("Infinite Time", comment: ""), for: UIControl.State.normal)
        userAnswer.placeholder = NSLocalizedString("Answer", comment: "")
        userAnswer.keyboardType = .numberPad
        poseQuestion()
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func skipQuestion(_ sender: UIButton){
        poseQuestion()
    }
    
    @IBAction func addMoreTime(_ sender: UIButton){
        counter += 15
    }
    
    func factors(of n: Int) -> [Int] {
        precondition(n > 0, "n must be positive")
        let sqrtn = Int(Double(n).squareRoot())
        var factors: [Int] = []
        factors.reserveCapacity(2 * sqrtn)
        for i in 1...sqrtn {
            if n % i == 0 {
                factors.append(i)
            }
        }
        var j = factors.count - 1
        if factors[j] * factors[j] == n {
            j -= 1
        }
        while j >= 0 {
            factors.append(n / factors[j])
            j -= 1
        }
        return factors
    }
    
    func poseQuestion(){
        messageIndex = Int.random(in: 0..<correctResponses.count)
        var values: [Int] = getRandomsNumbersOnRange(customRange: bounds, amount: 2)
        
        if(usedOperator[operatorIndex] == "*"){
            mathOperator.text = "x"
        }
        else if(usedOperator[operatorIndex] == "/"){
            mathOperator.text = "÷"
            values[1] = max(values[0], values[1])
            
            var possibleFactors: [Int] = factors(of: values[1])
            
            if possibleFactors.count > 2 {
                var factorIndex: Int = Int.random(in: 1..<(possibleFactors.count-1))
                values[0] = possibleFactors[factorIndex]
            }
            else {
                values[0] = 1
            }
            
            correctAnswer = Int(values[1]/values[0])
        }
        else{
            mathOperator.text = usedOperator[operatorIndex]
        }
        
        firstNumber.text = String(values[0])
        secondNumber.text = String(values[1])
        
        startCountdown()
    }
    
    func startCountdown(){
        counter = timeAllotted
        myTimer?.invalidate()
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.counter -= 1
            if self?.counter == 0 {
                self?.timerLabel.text = NSLocalizedString("Time's up! The answer is", comment:"") + " " + String(self!.correctAnswer)
                self?.myTimer?.invalidate()
            }
            else if let seconds = self?.counter {
                self?.timerLabel.text = String(seconds)
            }
        }
    }
    
    @IBAction func stopCountdown(_ sender: UIButton){
        timerLabel.text = "999"
        myTimer?.invalidate()
    }
    
    @IBAction func answeredQuestion(_ sender: UIButton){
        if userAnswer.hasText {
            if let ans = userAnswer.text {
                if ans.isNumeric {
                    let answer: Int = Int(ans)!
                    if answer == correctAnswer {
                        self.timerLabel.text = NSLocalizedString(self.correctResponses[self.messageIndex], comment: "")
                        self.userAnswer.text = ""
                        self.score += 1
                        self.scoreLabel.text = NSLocalizedString("Score", comment: "") + ": " + String(self.score)
                        poseQuestion()
                    }
                    else {
                        self.timerLabel.text = NSLocalizedString("Sorry, that's wrong. Try Again", comment:"")
                    }
                }
            }
        }
    }
    
    func calculateResult(values: [Int]) -> Int {
        var ans: Int = 0
        if(usedOperator[operatorIndex] == "+"){
            for value in values {
                ans = ans + value
            }
        }
        else if(usedOperator[operatorIndex] == "*"){
            ans = 1
            for value in values {
                ans = ans * value
            }
        }
        else if(usedOperator[operatorIndex] == "-"){
            ans = values[1] - values[0]
        }
        else if(usedOperator[operatorIndex] == "/"){
            ans = Int(values[0] / values[1])
        }
        
        return ans
    }
    
    func getRandomsNumbersOnRange(customRange: [Int], amount: Int) -> [Int] {
        var nums: [Int] = []
        operatorIndex = Int.random(in: 0..<usedOperator.count)
        
        for _ in 0..<amount {
            let lowerBound = min(customRange[0], customRange[1])
            let upperBound = max(customRange[0], customRange[1])
            nums.append(Int.random(in: lowerBound..<upperBound))
        }
        correctAnswer = calculateResult(values: nums)
        
        return nums
    }
    
    deinit {
        myTimer?.invalidate()
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil
    }
    
    var isNumeric: Bool {
        return Double(self) != nil
    }
    
    func localize() -> String {
      return NSLocalizedString(
        self,
        tableName: "Localizable",
        bundle: .main,
        value: self,
        comment: self)
    }
     
    public func localize(with arguments: [CVarArg]) -> String {
      return String(format: self.localize(), locale: nil, arguments: arguments)
    }
}
