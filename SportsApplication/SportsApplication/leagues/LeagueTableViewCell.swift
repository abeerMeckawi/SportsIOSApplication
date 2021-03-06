//
//  LeagueTableViewCell.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/18/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit

protocol LeagueTableViewCellDelegate : AnyObject {
    func playVideo(with videoUrl: String)
}

class LeagueTableViewCell: UITableViewCell {
    
    var delegate : LeagueTableViewCellDelegate?

    @IBOutlet weak var leagueImage: UIImageView!
    
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var playVideoBtn: UIButton!
    
    var videoUrl : String = ""
    
    @IBAction func playVideo(_ sender: Any) {
      delegate?.playVideo(with: videoUrl)
    }
    
    func configure(with videoUrl:String){
        self.videoUrl = videoUrl
    }
    override func awakeFromNib() {
        super.awakeFromNib()
   
        leagueImage.layer.cornerRadius = leagueImage.frame.size.width/2
        leagueImage.clipsToBounds = true
        
    
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

