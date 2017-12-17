//
//  CategoriesTableViewCell.swift
//  StillUndecided
//
//  Created by 16 on 17/12/2017.
//  Copyright © 2017 Anonim. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var starIcon: UIImageView!    
    @IBOutlet var labelRating: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelMonth: UILabel!


}
