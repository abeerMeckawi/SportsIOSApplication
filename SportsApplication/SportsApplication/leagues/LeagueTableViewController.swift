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
    var videoLeagueVC = YoutubeVideoViewController()
    var favoriteLeague = [NSManagedObject]()
    var favorite = FavoriteLeagueTableViewController()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Leagues"
        videoLeagueVC = self.storyboard?.instantiateViewController(withIdentifier: "youtubeVideoVC") as! YoutubeVideoViewController
        
    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func// tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 125
    }
}

extension LeagueTableViewController : LeagueTableViewCellDelegate{
    
    func playVideo(with videoUrl: String) {
        print(videoUrl)
        if let url = URL(string: "https://\(videoUrl)") {
            UIApplication.shared.open(url)
        }
      /*  videoLeagueVC.leagueVideo = videoUrl
        self.navigationController?.pushViewController(videoLeagueVC, animated: true)*/
    }
}

