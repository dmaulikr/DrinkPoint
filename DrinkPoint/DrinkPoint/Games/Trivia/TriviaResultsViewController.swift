//
//  TriviaResultsViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/13/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class TriviaResultsViewController: UIViewController {

    var questionNumber: Int = 0
    var correctAnswer: Int = 0
    let ResultPic0: UIImage! = UIImage(named: "TriviaClass1.png")
    let ResultPic1: UIImage! = UIImage(named: "TriviaClass2.png")
    let ResultPic2: UIImage! = UIImage(named: "TriviaClass3.png")
    let ResultPic3: UIImage! = UIImage(named: "TriviaClass4.png")

    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var TextMessege: UITextView!
    @IBOutlet weak var ResultImage: UIImageView!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        let triviaScore: Double = Double(correctAnswer) / Double(questionNumber)
        
        print("Correct of Total Questions -> \(correctAnswer)/\(questionNumber), Score: \(triviaScore * 100)%")
        ResultLabel.text = String("\(triviaScore * 100)%")
        
        if triviaScore == 1 {
            TextMessege.text = String("😀\nBecause you correctly answered every question, you’re a DrinkPoint Trivia Senior.")
            ResultImage.image = ResultPic0
        } else if triviaScore >= 0.75 {
            TextMessege.text = String("🙂\nWith \(correctAnswer) of \(questionNumber) correct answers, you’re a DrinkPoint Trivia Junior.")
            ResultImage.image = ResultPic1
        } else if triviaScore >= 0.50 {
            TextMessege.text = String("😐\nWith only \(correctAnswer) of \(questionNumber) correct answers, you’re a DrinkPoint Trivia Sophomore.")
            ResultImage.image = ResultPic2
        } else {
            TextMessege.text = String("🙁\nWith only \(correctAnswer) of \(questionNumber) correct answers, you’re a DrinkPoint Trivia Freshman.")
            ResultImage.image = ResultPic3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}