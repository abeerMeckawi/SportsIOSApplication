//
//  TeamViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 3/2/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TeamViewController: UIViewController {

    var teamId : String = ""
    @IBOutlet weak var teamBadgeImg: UIImageView!
    
    @IBOutlet weak var teamNameLal: UILabel!
    
    @IBOutlet weak var teamLeagueLbl: UILabel!
    
    @IBOutlet weak var teamStadiumName: UILabel!
    @IBOutlet weak var teamStadiumImg: UIImageView!
    var teamArrayDetails : [Team] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Team Details"
}
    
    override func viewWillAppear(_ animated: Bool) {
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=\(teamId)").validate().responseJSON {(responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let resData = swiftyJsonVar["teams"]
                
                for i in resData.arrayValue{
                    self.teamNameLal.text = i["strTeam"].stringValue
                    self.teamLeagueLbl.text = i["strLeague"].stringValue
                    self.teamStadiumName.text = i["strStadium"].stringValue
                    self.teamBadgeImg?.sd_setImage(with: URL(string: i["strTeamBadge"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
                    self.teamStadiumImg?.sd_setImage(with: URL(string: i["strStadiumThumb"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }else{
                print("error")
                print(responseData.error as Any)
            }
        }
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
