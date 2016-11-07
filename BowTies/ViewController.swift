//
//  ViewController.swift
//  BowTies
//
//  Created by Vladimir Nevinniy on 07.11.16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
    }
   

    @IBAction func wear(_ sender: Any) {
    }

}

