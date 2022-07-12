//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Camilo Hernández Guerrero on 20/06/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var countries = Array<String>()
    var score = 0
    var highestScore = 0 {
        didSet {
            if highestScore == score {
                saveHighestScore()
                alertPopUp(title: "Congratulations!", message: "You have set a new high score, keep at it!")
            }
        }
    }
    
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "poland",
                      "russia", "spain", "uk", "us"]
        
        /*button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        
        
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.lightGray.cgColor
        
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.lightGray.cgColor*/ //Couldn't solve border problem once the new constrains are in place.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        askQuestion()
        
        let JSONDecoder = JSONDecoder()
        guard let savedScore = UserDefaults.standard.object(forKey: "highestScore") as? Data else { return }
        
        if let decodedScore = try? JSONDecoder.decode(Int.self, from: savedScore) {
            highestScore = decodedScore
        }
    }
    
    func askQuestion (action: UIAlertAction! = nil) {
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        animateFlags(x: 1, y: 1)

        title = "\(countries[correctAnswer].uppercased()), score: \(score)"
        
        questionsAsked += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Wrong :(, that's \(countries[sender.tag].uppercased()) flag"
            score -= 1
        }
        
        if questionsAsked < 10 {
            alertPopUp(title: title, message: "Your score is \(score)")
        } else {
            if highestScore <= score {
                highestScore = score
            }
            
            alertPopUp(title: title, message: "You have answered \(questionsAsked) questions, your final score is \(score)")
            score = 0
            questionsAsked = 0
        }
    }
    
    func alertPopUp(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
 
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        let viewController = UIActivityViewController(activityItems: ["Got an score of \(score)!"], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(viewController, animated: true)
    }
    
    func saveHighestScore() {
        let JSONEncoder =  JSONEncoder()
        
        if let savedScore = try? JSONEncoder.encode(highestScore) {
            UserDefaults.standard.set(savedScore, forKey: "highestScore")
        }
    }
    
    func animateFlags(x: CGFloat, y: CGFloat) {
        button1.transform = CGAffineTransform(scaleX: x, y: y)
        button2.transform = CGAffineTransform(scaleX: x, y: y)
        button3.transform = CGAffineTransform(scaleX: x, y: y)
        
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.2, initialSpringVelocity: 10) {
            self.button1.transform = CGAffineTransform(scaleX: x - 0.05, y: y - 0.05)
                self.button2.transform = CGAffineTransform(scaleX: x - 0.05, y: y - 0.05)
                self.button3.transform = CGAffineTransform(scaleX: x - 0.05, y: y - 0.05)
        }
    }
}
