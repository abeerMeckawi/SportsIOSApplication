//
//  LeagueTableViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/18/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class LeagueTableViewController: UITableViewController {
    
    var sportName : String = " "
    var leagueIdArray: [String] = []
    var leagueArray: [League] = []
    var favoriteLeague = [NSManagedObject]()
    var favorite = FavoriteLeagueTableViewController()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Leagues"
    }
 
    override func viewWillAppear(_ animated: Bool) {
         print(sportName)
Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_leagues.php").validate().responseJSON {(responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)

                let resData = swiftyJsonVar["leagues"]
                
                for i in resData.arrayValue{
                    // print(i)
                    if i["strSport"].stringValue == self.sportName {
                        let id = i["idLeague"].stringValue
                        self.leagueIdArray.append(id)
                    }
                }
            for i in self.leagueIdArray{
            let id = i
            Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=\(id)").validate().responseJSON {response in
                        switch response.result{
                        case .success:
                            let result = try? JSON(data: response.data!)
                            let leagues = result!["leagues"]
                            for j in leagues.arrayValue{
                                let league = League()
                                league.leagueImg = j["strBadge"].stringValue
                                league.leagueName = j["strLeague"].stringValue
                                league.leaguevid = j["strYoutube"].stringValue
                                self.leagueArray.append(league)
                            }
                            self.tableView.reloadData()
                            break
                        case .failure:
                            print("error")
                            print(response.error as Any)
                            break
                        }}}
            }else{
                print("error")
                print(responseData.error as Any)
              }}
}
    override func viewDidDisappear(_ animated: Bool) {
        leagueIdArray.removeAll()
        leagueArray.removeAll()
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leagueArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeagueTableViewCell
        

        cell.leagueName.text = leagueArray[indexPath.row].leagueName
        cell.leagueImage?.sd_setImage(with: URL(string:leagueArray[indexPath.row].leagueImg ), placeholderImage: UIImage(named: "placeholder.png"))
        cell.configure(with: leagueArray[indexPath.row].leaguevid)
        cell.delegate = self

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue" {
        let detailsVC = segue.destination as? DetailsLeagueViewController
            if let leagueIndex = tableView.indexPathForSelectedRow?.row
            {
               detailsVC?.leagueId = leagueIdArray[leagueIndex]
               detailsVC?.leagueTitle = leagueArray[leagueIndex].leagueName
               detailsVC?.leagueBadge = leagueArray[leagueIndex].leagueImg
               detailsVC?.leagueVideo = leagueArray[leagueIndex].leaguevid

            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 125
    }
}

extension LeagueTableViewController : LeagueTableViewCellDelegate{
    
    func playVideo(with videoUrl: String) {
       // print(videoUrl)
        if let url = URL(string: "https://\(videoUrl)") {
            UIApplication.shared.open(url)
        }
    }
}

