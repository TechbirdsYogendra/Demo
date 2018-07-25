//
//  ViewController.swift
//  Demo
//
//  Created by Yogendra on 6/15/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- @IBOutlets
    @IBOutlet weak var myScrollView: UIScrollView!
    
    
    
    //MARK:- @Variables
    var textChecker = UITextChecker()
    let availableLanguages = UITextChecker.availableLanguages
    
    
    var tagger: NSLinguisticTagger!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        
        var language: String? = "en"
        let word = "making"
        print(setOfWords(from: word, with: &language))
        getLanguageOfSentence()
    }
    
    func setOfWords(from string: String, with language: inout String?) -> Set<String> {
        
        var wordSet = Set<String>()
        
        // note that we are able to use multiple schemes at the same time within a function
        tagger = NSLinguisticTagger(tagSchemes: [.lemma, .language], options: 0)
        let range = NSRange(location: 0, length: string.utf16.count)
        
        tagger.string = string
        
        // since language is an optional param we only set orthography if the language is provided, otherwise we ask tagger to do it for us
        if let language = language {
            tagger.setOrthography(NSOrthography.defaultOrthography(forLanguage: language), range: range)
        } else {
            language = tagger.dominantLanguage
        }
        
        tagger.enumerateTags(in: range, unit: NSLinguisticTaggerUnit.word, scheme: NSLinguisticTagScheme.lemma, options: NSLinguisticTagger.Options.init(rawValue: 0)) { (tag, tokenRange, _) in
            
            let token = (string as NSString).substring(with: tokenRange)
            
            // insert the root of the word into the collection
            wordSet.insert(token.lowercased())
            
            // detect lemmas and insert them into the collection
            if let lemma = tag?.rawValue {
                wordSet.insert(lemma.lowercased())
            }
        }
        return wordSet
    }
    
    func getLanguageOfSentence() {
        
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = "Hello How are you?"
        print(tagger.dominantLanguage)
        
    }
    
    func setupScrollView() {
        
        myScrollView.backgroundColor = UIColor.magenta
        myScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        myScrollView.contentSize = CGSize(width: myScrollView.frame.size.width, height: 2000)
        myScrollView.delegate = self
        
        let labelTop = UILabel()
        labelTop.text = "Hello Top"
        labelTop.frame = CGRect(x: myScrollView.frame.size.width/2 - 50, y: myScrollView.frame.minY + 20, width: 100, height: 20)
        myScrollView.addSubview(labelTop)
        
        let labelBottom = UILabel()
        labelBottom.text = "Hello Bottom"
        labelBottom.frame = CGRect(x: myScrollView.frame.size.width/2 - 50, y: myScrollView.contentSize.height - 50, width: 100, height: 20)
        myScrollView.addSubview(labelBottom)
  
    }
    
    func lastWordFromDocumentContext (text: String?) -> String? {
        
        guard let sentance = text else {
            return nil
        }
        var words = [String]()
        sentance.enumerateSubstrings(in: sentance.startIndex..<sentance.endIndex, options: .byWords) { (string, range1, range2, inoutValue) in
            guard let word = string else { return }
            words.append(word)
        }
        return words.last
    }
    
    func corret(_ word: String) -> String? {
        let preferredLanguage = self.availableLanguages.count > 0 ? self.availableLanguages[0] : "en-US"
        if let allGuess = textChecker.guesses(forWordRange: NSRange(0..<word.utf16.count), in: word, language: preferredLanguage) {
            return allGuess.count > 0 ? allGuess[0] : nil
        }
        return nil
    }
    
    

}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         print("scrollViewDidScroll")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView){
         print("scrollViewDidZoom")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
         print("scrollViewWillBeginDragging")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
         print("scrollViewWillEndDragging")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
         print("scrollViewDidEndDragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
         print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
         print("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
         print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?){
         print("scrollViewWillBeginZooming")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
         print("scrollViewDidEndZooming")
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.backgroundColor = UIColor.green
        print("scrollViewDidScrollToTop")
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView){
      print("scrollViewDidScrollToTop")
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        print(textField.text)
//        print(string)
//        print(range)
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            //print(textRange)
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
           print(updatedText)
            
            if string == " " {
                let lastword = lastWordFromDocumentContext(text: text)
                let lastwordRange = text.range(of: lastword!)
                if let correctWord = corret(text) {
                    textField.text = text.replacingCharacters(in: lastwordRange!, with: correctWord)
                }
            }
        }
        return true
    }
}


