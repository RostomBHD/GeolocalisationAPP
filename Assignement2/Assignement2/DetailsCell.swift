//
//  DetailsCell.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 03/12/2021.
//

import UIKit

class DetailsCell: UITableViewCell {

    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var author: UITextField!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
