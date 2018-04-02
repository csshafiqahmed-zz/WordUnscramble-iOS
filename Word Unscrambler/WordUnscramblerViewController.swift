//
//  WordUnscramblerViewController.swift
//  Word Unscrambler
//
//  Created by Satish Boggarapu on 3/22/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class WordUnscramblerViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    // MARK: UIElements
    var textField: UITextField!
    var goButton: UIButton!
    var resultsLabel: UILabel!
    var noteLabel: UILabel!
    var tableView: UITableView!
    var adBannerView: GADBannerView!

    // MARK: Attributes
    var allWords: [String] = []
    var similarWords: [String] = []
    var possibleWords: [[String]] = [[]]
    var wordsDict: [String: [String]] = [String: [String]]()
    var headerExpanded: [Bool] = []
    var points: [String: Int] = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Word Unscrambler"
        let moreButton = UIButton()
        moreButton.setTitle("", for: .normal)
        moreButton.setImage(UIImage(named: "ic_settings"), for: .normal)
        moreButton.addTarget(self, action: #selector(settingsButtonAction(_:)), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)

        setGradientBackground()
        setupView()
        myfunc()
        parseWordList()
        
        adBannerView.load(GADRequest())
        logFirebaseAnalyticsEvent()
        
    }

    private func setupView() {
        initializeTextField()
        initializeGoButton()
        initializeResultsLabel()
        initializeNoteLabel()
        initializeTableView()
        initializeAdBanner()

        let topView = UIView()
        topView.clipsToBounds = true
        topView.addSubview(textField)
        topView.addSubview(goButton)
        topView.addConstraintsWithFormat(format: "V:|[v0]|", views: textField)
        topView.addConstraintsWithFormat(format: "V:|[v0]|", views: goButton)
        topView.addConstraintsWithFormat(format: "H:|[v0][v1(90)]|", views: textField, goButton)

        self.view.addSubview(topView)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: topView)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: resultsLabel)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: noteLabel)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: adBannerView)

        let topConstraint = (navigationController?.navigationBar.frame.height)! + 20 + 34
        view.addConstraintsWithFormat(format: "V:|-\(topConstraint)-[v0(60)]-16-[v1(>=45)][v2(30)]-16-[v3]-[v4(65)]|", views: topView, resultsLabel, noteLabel, tableView, adBannerView)
        
    }

    func setGradientBackground() {
        let colorTop =  UIColor(red: 33.0/255.0, green: 112.0/255.0, blue: 143.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 52.0/255.0, green: 167.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        //        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)

    }

    private func initializeTextField() {
        textField = UITextField()
        textField.placeholder = "Enter a scrambled word"
        textField.textColor = UIColor.white
        textField.clearButtonMode = .always
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = true
        textField.tintColor = UIColor(hex: 0xDB376F)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 60))
        textField.leftViewMode = .always

        // set textField font size based on screenSize
        let screenWidth = self.view.frame.size.width

        switch screenWidth {
        case 320: // iPhone 4 and iPhone 5
            textField.font = UIFont(name: "Helvetica Neue", size: 14)
        case 375: // iPhone 6
            textField.font = UIFont(name: "Helvetica Neue", size: 18)
        case 414: // iPhone 6 Plus
            textField.font = UIFont(name: "Helvetica Neue", size: 22)
        case 768: // iPad
            textField.font = UIFont(name: "Helvetica Neue", size: 26)
        default: // iPad Pro
            textField.font = UIFont(name: "Helvetica Neue", size: 28)
        }
    }

    private func initializeGoButton() {
        goButton = UIButton()
        goButton.setTitle("Go", for: .normal)
        goButton.layer.borderWidth = 1
        goButton.layer.borderColor = UIColor.white.cgColor
        goButton.backgroundColor = UIColor(white: 1.0, alpha: 0.25)
        goButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 28)
        goButton.addTarget(self, action: #selector(goButton(_:)), for: .touchUpInside)
    }

    private func initializeResultsLabel() {
        resultsLabel = UILabel()
        resultsLabel.text = "0 matched found"
        resultsLabel.textColor = UIColor.white
        resultsLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        self.view.addSubview(resultsLabel)
    }

    private func initializeNoteLabel() {
        noteLabel = UILabel()
        noteLabel.text = "*tap on the word for definition"
        noteLabel.textColor = UIColor.white
        noteLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        self.view.addSubview(noteLabel)
    }

    private func initializeTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = true
        tableView.separatorColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView = footerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
    }
    
    private func initializeAdBanner() {
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = "ca-app-pub-6364543110450580/1349792967"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        self.view.addSubview(adBannerView)
    }
    
    private func logFirebaseAnalyticsEvent() {
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: [:])
    }

    @objc func goButton(_ sender: UIButton) {
        possibleWords.removeAll()
        headerExpanded.removeAll()
        textField.resignFirstResponder()
        let scrambledWord = (textField.text?.lowercased())!
        let length = scrambledWord.count
        if length > 0 {
            similarworddFunc(length)
            resultsFunc(scrambledWord)
            tableView.reloadData()
            resultsLabel.text = "\(getTotalPossibleWordsCount()) matches found"
            noteLabel.text = "*tap on the word for definition"
        }
    }

    func getTotalPossibleWordsCount() -> Int {
        var count = 0
        for words in possibleWords {
            count += words.count
        }
        return count
    }

    func myfunc() {
        /*
         let fileContent = try? NSString(contentsOfFile: location as String, encoding: NSUTF8StringEncoding)
         let line = fileContent as? String*/
        let location = Bundle.main.url(forResource: "items", withExtension: "txt")!
        let fileContent = try! String(contentsOf: location)
        allWords = fileContent.components(separatedBy: "\r\n")
        setupLetterValues()
    }

    func setupLetterValues() {
        let str = "abcdefghijklmnopqrstuvwxyz"
        let characterArray = Array(str)
        for letter in characterArray {
            var value = 1
            let value2 = ["l", "s", "u", "n", "r", "t", "o", "a", "i", "e"]
            let value3 = ["g", "d"]
            let value4 = ["f", "h", "v", "w", "y"]
            let value5 = ["k"]
            let value8 = ["j", "k"]
            let value10 = ["q", "z"]
            if value2.contains(String(letter)) {
                points[String(letter)] = 2
            } else if value3.contains(String(letter)) {
                points[String(letter)] = 3
            } else if value4.contains(String(letter)) {
                points[String(letter)] = 4
            } else if value5.contains(String(letter)) {
                points[String(letter)] = 5
            } else if value8.contains(String(letter)) {
                points[String(letter)] = 8
            } else if value10.contains(String(letter)) {
                points[String(letter)] = 10
            } else {
                points[String(letter)] = 0
            }
        }
    }

    func computeWordScore(_ word: String) -> Int {
        let wordArray = Array(word.sorted())
        var score = 0
        for word in wordArray {
            score += points[String(word)]!
        }
        return score
    }

    func parseWordList() {
        for word in allWords {
            let sortedWord = String(word.sorted())
            if wordsDict.keys.contains(sortedWord) {
                wordsDict[sortedWord]?.append(word)
            } else {
                wordsDict[sortedWord] = [word]
            }
        }
    }

    func similarworddFunc(_ length: Int) {
        similarWords.removeAll()
        for word in allWords {
            if word.count == length {
                similarWords.append(word.lowercased())
            }
        }
    }

    func resultsFunc(_ scrambledWord: String) {
        let sortedWord = Array(scrambledWord)
        for i in stride(from: 2, to: scrambledWord.count+1, by: 1) {
            possibleWords.append([])
            headerExpanded.append(true)
            let words = Combinatorics.combinationsWithoutRepetitionFrom(sortedWord, taking: i)
            for word in words {
                getSimilarWords(String(word), index: i-2)
            }
        }
    }

    func getSimilarWords(_ word: String, index: Int) {
        let sortedWord = String(word.sorted())
        if wordsDict[sortedWord] != nil {
            for word in wordsDict[sortedWord]! {
                if !possibleWords[index].contains(word) {
                    possibleWords[index].append(word)
                }
            }
        }
    }

    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")

        let section = button.tag

        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in 0...possibleWords[section].count-1 {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }

        let isExpanded = headerExpanded[section]
        headerExpanded[section] = !headerExpanded[section]

        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }

    @objc func settingsButtonAction(_ button: UIBarButtonItem) {

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return possibleWords.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (headerExpanded.count > 0) {
            return (headerExpanded[section]) ? possibleWords[section].count : 0
        }
        return possibleWords[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(white: 1, alpha: 0.25)
        cell.textLabel?.text = possibleWords[indexPath.section][indexPath.row] + "         " + String(computeWordScore(possibleWords[indexPath.section][indexPath.row]))
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        cell.isOpaque = true
        cell.clipsToBounds = true
        
//        let scoreLabel = UILabel(frame: CGRect(x: cell.frame.width - 50, y: 0, width: 50, height: cell.frame.height))
//        scoreLabel.text = String(computeWordScore(possibleWords[indexPath.section][indexPath.row]))
//        scoreLabel.font = UIFont(name: "Helvetica Neue", size: 22)
//        scoreLabel.textColor = UIColor.white
//        scoreLabel.textAlignment = .right
//        cell.addSubview(scoreLabel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = WebViewController()
        newController.word = possibleWords[indexPath.section][indexPath.row]
        navigationController?.pushViewController(newController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (possibleWords[section].count > 0) ? 36 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if possibleWords[0].count > 0 {
            let header = UIView()
            let button = UIButton(type: .system)
            button.setTitle("Words of length \(section+2)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.backgroundColor = UIColor(white: 1, alpha: 1)
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            button.tag = section
            header.addSubview(button)

            let seperator = UIView()
            seperator.backgroundColor = UIColor.white
            header.addSubview(seperator)

            header.addConstraintsWithFormat(format: "H:|[v0]|", views: button)
            header.addConstraintsWithFormat(format: "H:|[v0]|", views: seperator)
            header.addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: button, seperator)
            return header
        }
        return nil

    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to recieve ads")
        print(error)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {

    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(),
                metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {

    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
                red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat((hex & 0x0000FF) >> 0) / 255.0,
                alpha: alpha
        )
    }
}
