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
    
    var currentBowtie: Bowtie!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertSampleData()
        
        let request = NSFetchRequest<Bowtie>(entityName: "Bowtie")
        let firstTitle = segmentedControl.titleForSegment(at: 0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        do {
            let result = try managerContext.fetch(request)
            
            currentBowtie = result.first!
            populate(bowtie: result.first!)
            
        } catch let error {
            print(error)
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        let request = NSFetchRequest<Bowtie>(entityName: "Bowtie")
        
        
        request.predicate = NSPredicate(format: "searchKey == %@", selectedValue!)
        
        do {
            let result = try managerContext.fetch(request)
            
            currentBowtie = result.first!
            populate(bowtie: result.first!)
            
        } catch let error {
            print(error)
        }
    }
   

    @IBAction func wear(_ sender: Any) {
        //let times = currentBowtie.timesWorn
        currentBowtie.timesWorn += 1
        
        currentBowtie.lastWorn = NSDate()
        
        do {
            try managerContext.save()
        }catch let error {
            print("Colud not save: \(error)")
        }
        
        populate(bowtie: currentBowtie)
    }
    
    @IBAction func rate(_ sender: Any) {
        let alert = UIAlertController(title: "New Rating", message: "Rate this bow tie", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
            let textField = alert.textFields![0] as UITextField
            
            self.updateRating(numbericString: textField.text!)
            
        })
        
        alert.addTextField { (text: UITextField) in
            text.keyboardType = .numberPad
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func updateRating(numbericString: String) {
        currentBowtie.rating = Double(numbericString)!
        
        do {
            try managerContext.save()
            self.populate(bowtie: self.currentBowtie)
        }catch let error as NSError {
            print("Colud not save: \(error)")
            
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError){
                rate(currentBowtie)
            }
        }
    }
    
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data: bowtie.photoData as! Data)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating)"
        
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        lastWornLabel.text = "Last worn: " + dateFormatter.string(from: bowtie.lastWorn as! Date)
        
        favoriteLabel.isHidden = !bowtie.isFavorite
        
        view.tintColor = bowtie.tintColor as! UIColor
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

