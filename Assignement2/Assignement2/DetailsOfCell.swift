//
//  DetailsOfCell.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 03/12/2021.
//

import UIKit

class DetailsOfCell: UITableViewCell {

    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var TitleOfArtwork: UILabel!
    @IBOutlet weak var Author: UILabel! 
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
