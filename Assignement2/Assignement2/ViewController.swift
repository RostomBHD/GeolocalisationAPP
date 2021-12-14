//
//  ViewController.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 29/11/2021.
//

import UIKit


class ViewController: UIViewController {
    
   
    var informationIndex : Int = 0
    var headline_at_cell : unicampusart?
    
    var Arts:AllCampusArts? = nil
    
    @IBOutlet weak var Author: UILabel!
    @IBOutlet weak var Photo: UIImageView!
    @IBOutlet weak var titleOfArt: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var information: UITextView!
    
 
    
    override func viewDidLoad() {
        
        Author.text = (headline_at_cell?.artist)
        
        let base_url = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/"
        var img_url = base_url + ((headline_at_cell?.ImagefileName)!)
        img_url = img_url.replacingOccurrences(of: " ", with: "%20")

        
        if headline_at_cell?.ImagefileName != nil {
            let image_url = URL(string: img_url)
            Photo.load(url: image_url!)
            
        }
        
        titleOfArt.text = headline_at_cell?.title
        date.text = headline_at_cell?.yearOfWork
        information.text = headline_at_cell?.Information
        
    }
    
    
}

