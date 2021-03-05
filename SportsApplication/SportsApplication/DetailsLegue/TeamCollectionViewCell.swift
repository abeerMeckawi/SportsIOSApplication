//
//  TeamCollectionViewCell.swift
//  SportsApplication
//
//  Created by MacOSSierra on 3/1/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgTeam: UIImageView!
    
    @IBOutlet weak var lblTeamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgTeam.layer.cornerRadius = imgTeam.frame.size.width/2
        imgTeam.clipsToBounds = true
    }
}
