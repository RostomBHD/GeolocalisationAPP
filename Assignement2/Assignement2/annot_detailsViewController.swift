//
//  annot_detailsViewController.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 10/12/2021.
//

import UIKit

class annot_detailsViewController: UIViewController {

    
    var information2 = ""
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var details2: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        details2.text = information2

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
