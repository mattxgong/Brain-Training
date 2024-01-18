//
//  MemoryController.swift
//  MentalExercises
//
//  Created by Grace Chen on 2024-01-03.
//

import Foundation
import UIKit

class MemoryController : UIViewController {
    @IBOutlet var inputText : UITextField!
    @IBOutlet var timerLabel : UILabel!
    @IBOutlet var elementLabel : UILabel!
    @IBOutlet var scoreLabel : UILabel!
    
    let possibleChoices: [String] = ["Phoenix", "Bagman", "Rooster", "Maverick", "Iceman", "Coyote", "Cobra", "Goose", "One", "Two", "Three", "Four", "Five"]
    
    var elementsChosen: [String] = ["Phoenix", "Bagman", "Rooster"]
    var timeRemaining: Int = 30
    var timeAllotted: Int = 30
    var timePerElement: Int = 20
    var myTimer: Timer?
    var counter: Int = 0
    var score: Int = 0
    var chancesRemaining: Int = 5
    var chancesPerWord: Int = 5
    var numOfWords: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        inputText.isEnabled = false
        counter = 0
        getElements(num: numOfWords)
        startTimer()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func getElements(num: Int){
        elementsChosen = []
        while elementsChosen.count < num {
            let index: Int = Int.random(in: 0..<possibleChoices.count)
            if !(elementsChosen.contains(possibleChoices[index])) {
                elementsChosen.append(possibleChoices[index])
            }
        }
        elementLabel.text = elementsChosen[0]
        print(elementsChosen)
        timePerElement = timeAllotted / num
    }
    
    func startTimer(){
        timeRemaining = timeAllotted
        chancesRemaining = chancesPerWord
        myTimer?.invalidate()
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.timeRemaining -= 1
            
            if (self!.timeAllotted - self!.timeRemaining) % self!.timePerElement == 0 && self?.timeRemaining != 0 {
                self?.elementLabel.text = self?.elementsChosen[(self!.timeAllotted - self!.timeRemaining) / self!.timePerElement]
            }
            
            if self?.timeRemaining == 0 {
                self?.timerLabel.text = "Time's up! Enter the words in the same order!"
                self?.myTimer?.invalidate()
                self?.inputText.isEnabled = true
                self?.elementLabel.text = "What is word #1? (" + String(self!.chancesRemaining) + " chances remaining)"
            }
            else if let seconds = self?.timeRemaining {
                self?.timerLabel.text = "Time Remaining: " + String(seconds)
            }
        }
    }
    
    @IBAction func answerQuestion(_ sender: UIButton){
        print(timeRemaining)
        if timeRemaining == 0 && counter < elementsChosen.count {
            if inputText.text == elementsChosen[counter] {
                chancesRemaining = chancesPerWord
                timerLabel.text = "Correct!"
                counter += 1
                elementLabel.text = "What is word #" + String(counter+1) + "? (" + String(chancesRemaining) + " chances remaining)"
                score += 1
                scoreLabel.text = "Score: " + String(score)
            }
            else {
                chancesRemaining -= 1
                if chancesRemaining <= 0 {
                    timerLabel.text = "Incorrect! The word was " + elementsChosen[counter]
                    counter += 1
                    chancesRemaining = chancesPerWord
                    elementLabel.text = "What is word #" + String(counter+1) + "? (" + String(chancesRemaining) + " chances remaining)"
                }
                else {
                    timerLabel.text = "Sorry, that's wrong! You have " + String(chancesRemaining) + " chances left."
                    elementLabel.text = "What is word #" + String(counter+1) + "? (" + String(chancesRemaining) + " chances remaining)"
                }
            }
            
            if counter >= elementsChosen.count {
                elementLabel.text = "You have reached the end! Congrats!"
            }
            
            inputText.text = ""
        }
    }
    
    @IBAction func moreChances(_ sender: UIButton){
        chancesRemaining += 3
        elementLabel.text = "What is word #" + String(counter+1) + "? (" + String(chancesRemaining) + " chances remaining)"
    }
    
    deinit {
        myTimer?.invalidate()
    }
}
