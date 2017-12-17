//
//  StatisticsViewController.swift
//  StillUndecided
//
//  Created by 16 on 13/12/2017.
//  Copyright © 2017 Anonim. All rights reserved.
//

import UIKit
import ConcentricProgressRingView
import LionheartExtensions
import MaterialComponents

class StatisticsViewController: UIViewController {
    
    var firstRing = 0.0
    var secondRing = 0.0
    var thirdRing = 0.0

    @IBOutlet weak var StatisticsContainer: UIView!
    var progressRingView: ConcentricProgressRingView!
    
    @IBOutlet weak var bookRatingLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var cafeRatingLabel: UILabel!
    
    
    override func viewDidLoad() {
        let margin: CGFloat = 1
        let radius: CGFloat = 125
        
        
        let rings = [
            ProgressRing(color: UIColor(.RGB(255, 255, 255)), backgroundColor: UIColor(.RGB(40, 40, 40))),
            ProgressRing(color: UIColor(.RGB(200, 200, 200)), backgroundColor: UIColor(.RGB(40, 40, 40))),
            ProgressRing(color: UIColor(.RGB(150, 150, 150)), backgroundColor: UIColor(.RGB(40, 40, 40)))
        ]
        
        progressRingView = try! ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings, defaultColor: UIColor.clear, defaultWidth: 28)
        
        
        setupRings()
        
        
        
        view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
        
        StatisticsContainer.insertSubview(progressRingView, at: 0)
        StatisticsContainer.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        progressRingView.center = CGPoint(x: StatisticsContainer.frame.width / 2, y: StatisticsContainer.frame.height / 2)
    }
    
    func setupRings() {
        getAverages()
        
        progressRingView[0].setProgress(CGFloat(0.0), duration: 0)
        progressRingView[1].setProgress(CGFloat(0.0), duration: 0)
        progressRingView[2].setProgress(CGFloat(0.0), duration: 0)
        
        progressRingView[0].setProgress(CGFloat(firstRing), duration: 1)
        progressRingView[1].setProgress(CGFloat(secondRing), duration: 1)
        progressRingView[2].setProgress(CGFloat(thirdRing), duration: 1)
        
        movieRatingLabel.text = String(firstRing*10)
        bookRatingLabel.text = String(secondRing*10)
        cafeRatingLabel.text = String(thirdRing*10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRings()
    }
    
    func getAverages() {
        var sum = 0.0
        var number = 0.0
        for element in Data.items
        {
            if (element.ItemCategory == "Movie"){
                sum+=Double(element.ItemRating!)!
                number += 1
            }
        }
        firstRing = (sum/number)/10
        
        
        sum = 0.0
        number = 0.0
        for element in Data.items
        {
            if (element.ItemCategory == "Book"){
                sum+=Double(element.ItemRating!)!
                number += 1
            }
        }
        secondRing = (sum/number)/10
        
        sum = 0.0
        number = 0.0
        for element in Data.items
        {
            if (element.ItemCategory == "Cafe"){
                sum+=Double(element.ItemRating!)!
                number += 1
            }
        }
        thirdRing = (sum/number)/10
        
        print(firstRing)
        print(secondRing)
        print(thirdRing)
        
    }
    
}
