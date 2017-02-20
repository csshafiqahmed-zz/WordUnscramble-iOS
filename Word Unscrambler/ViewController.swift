//
//  ViewController.swift
//  Word Unscrambler
//
//  Created by Satish Boggarapu on 9/14/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var enteredWord: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var definitionLabel: UILabel!

    //let location = "/Users/SatishBoggarapu/Desktop/dictionary2.txt"
    
    var allWords: [String] = []
    var similarWords: [String] = []
    var possibleWords: [String] = []
    
    //var gl: CAGradientLayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set textfield font size based on screensize
        let screenWidth = self.view.frame.size.width
        
        switch screenWidth {
        case 320: // iPhone 4 and iPhone 5
            enteredWord.font = UIFont(name: "Helvetica Neue", size: 16)
        case 375: // iPhone 6
            enteredWord.font = UIFont(name: "Helvetica Neue", size: 20)
        case 414: // iPhone 6 Plus
            enteredWord.font = UIFont(name: "Helvetica Neue", size: 24)
        case 768: // iPad
            enteredWord.font = UIFont(name: "Helvetica Neue", size: 26)
        default: // iPad Pro
            enteredWord.font = UIFont(name: "Helvetica Neue", size: 28)
        }

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.gray
        let alloc = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = alloc
        enteredWord.layer.borderWidth = 1
        enteredWord.layer.borderColor = UIColor.white.cgColor
        goButton.layer.borderWidth = 1
        goButton.layer.borderColor = UIColor.white.cgColor
        
        setGradientBackground()
        
        //        var frameRec = CGRect(origin: 100, size: 100)
        //        frameRec.size.height = 100
        //        enteredWord.frame = frameRec
        
        myfunc()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 33.0/255.0, green: 112.0/255.0, blue: 143.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 52.0/255.0, green: 167.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        //        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func myfunc() {
        /*
         let fileContent = try? NSString(contentsOfFile: location as String, encoding: NSUTF8StringEncoding)
         let line = fileContent as? String*/
        let location = Bundle.main.url(forResource: "items", withExtension: "txt")!
        let fileContent = try! String(contentsOf: location)
        allWords = fileContent.components(separatedBy: "\r\n")
    }
    
    func similarworddFunc(_ length: Int) {
        similarWords.removeAll()
        var i = 0;
        repeat {
            if (allWords[i].characters.count == length){
                //allWords.removeAtIndex(i)
                similarWords.append(allWords[i].lowercased())
            }
            i += 1
        } while i < allWords.count
    }
    
    func resultsFunc(_ scrambledWord: String) {
        // Scrambled Word Array
        let scramWordList = Array(scrambledWord.characters)
        // Similar Words Array Index
        var i = 0
        repeat {
            // Array word array
            let string = similarWords[i]
            var wordfromlist = Array(string.characters)
            // scramWordList Index
            var j = 0
            repeat {
                // wordfromlist index
                var z = 0
                repeat {
                    if scramWordList[j] == wordfromlist[z]
                    {
                        wordfromlist.remove(at: z)
                        break
                    }
                    z += 1
                } while z < wordfromlist.count
                j += 1
            } while j < scramWordList.count
            if wordfromlist.count == 0 {
                print(similarWords[i])
                possibleWords.append(similarWords[i])
            }
            i += 1
        } while i < similarWords.count
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        possibleWords.removeAll()
        let scrambledWord = enteredWord.text?.lowercased()
        enteredWord.resignFirstResponder()
        let length = scrambledWord?.characters.count
        similarworddFunc(length!)
        resultsFunc(scrambledWord!)
        self.tableView.reloadData()
        textLabel.text = "\(possibleWords.count) matches found"
        definitionLabel.text = "*tap on the word for definition"
//        enteredWord.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = possibleWords[(indexPath as NSIndexPath).row]
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"
        {
            let newController = segue.destination as! WebViewController
            // Get the cell that generated this segue
            let indexPath = tableView.indexPathForSelectedRow
            newController.word = possibleWords[(indexPath?.row)!]
            
        }
    }
    
}



