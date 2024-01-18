//
//  MemorySettingController.swift
//  MentalExercises
//
//  Created by Grace Chen on 2024-01-05.
//

import Foundation
import UIKit

class MemorySettingController: UIViewController {
    @IBOutlet var timeSelector: UISlider!
    @IBOutlet var chancesField: UITextField!
    @IBOutlet var wordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        timeSelector.minimumValue = 1
        timeSelector.maximumValue = 180
        chancesField.keyboardType = .numberPad
        wordField.keyboardType = .numberPad
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let memoryGameController: MemoryController = segue.destination as? MemoryController {
            
            if chancesField.text == "" || chancesField.text == nil {
                memoryGameController.timeAllotted = 5
            }
            else {
                memoryGameController.chancesPerWord = Int(chancesField.text!)!
            }
            
            if wordField.text == "" || wordField.text == nil {
                memoryGameController.numOfWords = 3
            }
            else {
                memoryGameController.numOfWords = Int(wordField.text!)!
            }
            
            memoryGameController.timeAllotted = Int(timeSelector.value)
        }
    }
}
