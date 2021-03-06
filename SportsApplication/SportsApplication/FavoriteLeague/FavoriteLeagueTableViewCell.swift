//
//  FavoriteLeagueTableViewCell.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/28/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit

protocol FavoriteLeagueTableViewCellDelegate : AnyObject {
    func fPlayVideo(with fVideoUrl: String)
}

class FavoriteLeagueTableViewCell: UITableViewCell {
    
    var fDelegate : FavoriteLeagueTableViewCellDelegate?
    @IBOutlet weak var fImage: UIImageView!
    
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var fVideoBtn: UIButton!
    
    var fVideoUrl : String = ""
    

    @IBAction func fPlayVideo(_ sender: Any) {
        
         fDelegate?.fPlayVideo(with: fVideoUrl)
    }
    
    func configure(with fVideoUrl:String){
        self.fVideoUrl = fVideoUrl
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fImage.layer.cornerRadius = fImage.frame.size.width / 2
        fImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



