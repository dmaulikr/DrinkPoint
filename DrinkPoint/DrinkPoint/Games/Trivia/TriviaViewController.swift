//
//  TriviaViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/13/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class TriviaViewController: UIViewController {

    var questionNumber = 5
    var sum = 0
    var correctAnswer = 0
    var random = 0
    var quizArray = [NSMutableArray]()
    var count = 0
    var timer: NSTimer!
    var ansTrueAnimeArray: Array<UIImage> = []
    var ansFalseAnimeArray: Array<UIImage> = []
    let answerTrue: UIImage!  = UIImage(named: "true.png")
    let answerFalse: UIImage! = UIImage(named: "false.png")
    
    @IBOutlet var quizTextView: UITextView!
    @IBOutlet var choiceButtons: Array<UIButton>!
    @IBOutlet var answerMark: UIImageView!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        ansTrueAnimeArray.append(answerTrue)
        ansFalseAnimeArray.append(answerFalse)
        quizArray.append([
            "How do crickets hear?",
            "Through their wings",
            "Through their belly",
            "Through their knees",
            "Through their tongue",
            3, 1])

        quizArray.append([
            "Which American city invented plastic vomit?",
            "Chicago",
            "Detroit",
            "Columbus",
            "Baltimore",
            1, 2])

        quizArray.append([
            "In ‘Ben Hur,’ which modern object can be seen during the chariot scene?",
            "A waitress",
            "A car",
            "A mailbox",
            "A street lamp",
            2, 3])

        quizArray.append([
            "What was Karl Marx’s favorite color?",
            "Brown",
            "Blue",
            "Red",
            "Purple",
            3, 4])

        quizArray.append([
            "What’s the best way to stop crying while peeling onions?",
            "Lick almonds",
            "Suck lemons",
            "Eat cheese",
            "Chew gum",
            4, 5])
        
        quizArray.append([
            "How old was the youngest Pope?",
            "11",
            "17",
            "22",
            "29",
            1, 6])

        quizArray.append([
            "Which animal sleeps for only five minutes a day?",
            "A chameleon",
            "A koala",
            "A giraffe",
            "A beaver",
            3, 7])
        
        quizArray.append([
            "How many words in the English language end in “dous”?",
            "Two",
            "Four",
            "Six",
            "Eight",
            2, 8])

        quizArray.append([
            "One human hair can support how many kilograms?",
            "Three",
            "Five",
            "Seven",
            "Nine",
            1, 9])

        quizArray.append([
            "The bikini was originally called the what?",
            "Poke",
            "Range",
            "Half",
            "Atom",
            4, 10])

        quizArray.append([
            "Which European city is home to the Fairy Investigation Society?",
            "Poznan",
            "Dublin",
            "Bratislava",
            "Tallinn",
            2, 11])
        
        quizArray.append([
            "What’s a frog’s favorite color?",
            "Blue",
            "Orange",
            "Yellow",
            "Brown",
            1, 12])

        quizArray.append([
            "Which one of these planets rotates clockwise?",
            "Uranus",
            "Mercury",
            "Pluto",
            "Venus",
            4, 13])

        quizArray.append([
            "What perspires half a pint of fluid a day?",
            "Your scalp",
            "Your armpits",
            "Your feet",
            "Your buttocks",
            3, 14])
        
        quizArray.append([
            "Saint Stephen is the patron saint of who?",
            "Plumbers",
            "Bricklayers",
            "Roofers",
            "Carpenters",
            2, 15])

        quizArray.append([
            "Which country leads the world in cork production?",
            "Greece",
            "Australia",
            "Spain",
            "Mexico",
            3, 16])

        quizArray.append([
            "On average, what do you do 15 times a day?",
            "Laugh",
            "Burp",
            "Fart",
            "Lick your lips",
            1, 17])

        quizArray.append([
            "What color was Coca-Cola originally?",
            "Red",
            "Purple",
            "Beige",
            "Green",
            4, 18])

        quizArray.append([
            "Bubble gum contains what?",
            "Plastic",
            "Calcium",
            "Rubber",
            "Pepper",
            3, 19])

        quizArray.append([
            "The inventor of the paint roller was of which nationality?",
            "Hungarian",
            "Canadian",
            "Norwegian",
            "Argentinian",
            2, 20])
        
        delay(30, closure: { () -> () in
            self.answerMark.alpha = 0.0
        })
        choiceQuiz()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TriviaViewController.OnUpdate(_:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func choiceQuiz() {
        if quizArray.count == 0 {
            random = 0
        } else {
        random = Int(arc4random_uniform(UInt32(quizArray.count)))
        }
        quizTextView.text = quizArray[random][0] as! NSString as String
        for i in 0 ..< choiceButtons.count {
            choiceButtons[i].setTitle(quizArray[random][i+1] as! NSString as String, forState: .Normal)
            choiceButtons[i].tag = i + 1;
        }
    }
    
    @IBAction func choiceAnswer(sender: UIButton) {
        sum += 1
        print("\(sum) of \(questionNumber - sum + 1) questions remaining", terminator: "")
        print("Question #\(random)")
        print("The correct choice to \(quizArray[random][5] as! Int) is \(sender.tag)")
        answerMark.alpha = 1
        if quizArray[random][5] as! Int == sender.tag {
            correctAnswer += 1
            print("Player's choice is correct")
            let image = UIImage(named: "true.png")!
            answerMark.image = image
        } else {
            print("Player's choice is incorrect")
            let image = UIImage(named: "false.png")!
            answerMark.image = image
        }
        delay((2/3), closure: { () -> () in
            self.answerMark.alpha = 0
            self.answerMark.image = nil
            if self.sum == self.questionNumber {
                self.performSegueToResult()
            } else {
                self.quizArray.removeAtIndex(self.random)
                self.choiceQuiz()
            }
        })
        count = 5
        print("The answer is \(correctAnswer).")
    }
    
    func OnUpdate(timer: NSTimer){
        self.count -= 1
        print(self.count)
    }
    
    func performSegueToResult() {
        performSegueWithIdentifier("toResultsView", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toResultsView") {
            let ResultView: TriviaResultsViewController = segue.destinationViewController as! TriviaResultsViewController
            ResultView.questionNumber = self.questionNumber
            ResultView.correctAnswer  = self.correctAnswer
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}