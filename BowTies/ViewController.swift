//
//  ViewController.swift
//  BowTies
//
//  Created by Vladimir Nevinniy on 07.11.16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managerContext: NSManagedObjectContext!
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertSampleData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
    }
   

    @IBAction func wear(_ sender: Any) {
    }
    
    
    
    
    
    func colorFtomDict(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(colorLiteralRed: Float(red)/255.0, green: Float(green)/255.0, blue: Float(blue)/255.0, alpha: 1)
        
        return color
    }
    
    func insertSampleData() {
        let featchRequest = NSFetchRequest<Bowtie>(entityName: "Bowtie")
        
        featchRequest.predicate = NSPredicate(format: "searchKey != nil")
        
        let count = try! managerContext.count(for: featchRequest)
        
        if count > 0 {return}
        
        
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dict in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managerContext)
            
            let bowtie = Bowtie(entity: entity!, insertInto: managerContext)
            
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = (btDict["rating"] as? Double)!
            
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFtomDict(dict: tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named: imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData as NSData?
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = (btDict["timesWorn"] as? Int32)!
            bowtie.isFavorite = btDict["isFavorite"] as! Bool
            
        }
        
    }

}

