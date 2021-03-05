//
//  DetailsLeagueViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/27/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SDWebImage

class DetailsLeagueViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var upComingCollection: UICollectionView!
    @IBOutlet weak var letestCollection: UICollectionView!
    @IBOutlet weak var teamCollection: UICollectionView!
    
    var teamVC = TeamViewController()
    let upComingIdentifier = "UpComingCell"
    let latestIdentifier = "LatestCell"
    let teamIdentifier = "TeamCell"
    var leagueId : String = " "
    var leagueTitle : String = " "
    var leagueBadge : String = " "
    var leagueVideo : String = " "
    var eventIdArray: [String] = []
    var eventArray :[Event] = []
    var teamArray:[Team] = []
    var favoriteLeague = [NSManagedObject]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Details Leagues"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(favoriteTapped))
        teamVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamVC") as! TeamViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(leagueId)

        /*let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let month = components.month
        let day = components.day*/
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/eventsseason.php?id=\(leagueId)&s=2020-2021").validate().responseJSON {(responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                let resData = swiftyJsonVar["events"]
                
                for i in resData.arrayValue{
              // if ( "2021-\(month)-\(day)" <= i["dateEvent"].stringValue){
                    let id = i["idEvent"].stringValue
                    self.eventIdArray.append(id)
                    }
            //    }
               // print(self.eventIdArray)
                
                 for i in self.eventIdArray{
                 let id = i
                Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupevent.php?id=\(id)").validate().responseJSON {response in
                    switch response.result{
                    case .success:
                        let result = try? JSON(data: response.data!)
                        //print("Alamofire")
                        let events = result!["events"]
                        for j in events.arrayValue{
                            let event = Event()
                            event.eventName = j["strEvent"].stringValue
                            event.eventDate = j["dateEvent"].stringValue
                            event.eventTime = j["strTime"].stringValue
                            event.homeTeam = j["strHomeTeam"].stringValue
                            event.SecondTeam = j["strAwayTeam"].stringValue
                            event.HomeScore = j["intHomeScore"].stringValue
                            event.SecondScore = j["intAwayScore"].stringValue
                            self.eventArray.append(event)
                        }
                       // print(self.eventArray)
                         self.upComingCollection.reloadData()
                         self.letestCollection.reloadData()
                      
                        break
                    case .failure:
                        print("error")
                        print(response.error as Any)
                        break
                    }
                }
            }
                Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id=\(self.leagueId)").validate().responseJSON {(responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        let resData = swiftyJsonVar["teams"]
                        
                        for i in resData.arrayValue{
                            let team = Team()
                            team.teamId = i["idTeam"].stringValue
                            team.teamBadge = i["strTeamBadge"].stringValue
                            team.teamName = i["strTeam"].stringValue
                            self.teamArray.append(team)
                        }
                          self.teamCollection.reloadData()
                    }
                  //  print(self.teamArray)
                }
        }
        }
   
          // print(eventArray.count)
         //  print(teamBadgeArray.count)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            if(collectionView == letestCollection){
            return eventArray.count;
            
        }else if(collectionView == teamCollection){
            return teamArray.count;
        }
        
       return eventArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let upComingCell = upComingCollection.dequeueReusableCell(withReuseIdentifier: upComingIdentifier, for: indexPath) as! EventsCollectionViewCell
            upComingCell.lblEvent.text = eventArray[indexPath.row].eventName
            upComingCell.lbllDate.text = eventArray[indexPath.row].eventDate
            upComingCell.lblTime.text = eventArray[indexPath.row].eventTime
            //print(eventArray[indexPath.row].eventName)
            //print("hello")
        
        if(collectionView == letestCollection){
            let latestCell = letestCollection.dequeueReusableCell(withReuseIdentifier: latestIdentifier, for: indexPath) as! LatestEventCollectionViewCell
            
            latestCell.lblHomeT.text = eventArray[indexPath.row].homeTeam
            latestCell.lblSecondT.text = eventArray[indexPath.row].SecondTeam
            latestCell.lblHomeScore.text = eventArray[indexPath.row].HomeScore
            latestCell.lblSecondScore.text = eventArray[indexPath.row].SecondScore
            latestCell.lblDate.text = eventArray[indexPath.row].eventDate
            latestCell.lblTime.text = eventArray[indexPath.row].eventTime
            
            return latestCell
        }
      else if(collectionView == teamCollection){
        
       let teamCell = teamCollection.dequeueReusableCell(withReuseIdentifier: teamIdentifier, for: indexPath) as! TeamCollectionViewCell
         teamCell.lblTeamName.text = teamArray[indexPath.row].teamName
         teamCell.imgTeam?.sd_setImage(with: URL(string: teamArray[indexPath.row].teamBadge), placeholderImage: UIImage(named: "placeholder.png"))
        
            return teamCell

        }
        return upComingCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == teamCollection){
        teamVC.teamId = teamArray[indexPath.row].teamId
        self.navigationController?.pushViewController(teamVC, animated: true)
        }
    }
    
    @objc func favoriteTapped(){
        print("favorite")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let entityLeague = NSEntityDescription.entity(forEntityName: "FavoriteLeague", in: manageContext)
        
        let leagueData = NSManagedObject(entity: entityLeague!, insertInto: manageContext)
        
      
        leagueData.setValue(leagueId, forKey: "id")
        leagueData.setValue(leagueTitle, forKey: "name")
        leagueData.setValue(leagueBadge, forKey: "badge")
        leagueData.setValue(leagueVideo, forKey: "video")
    
        
        do{
            try manageContext.save()
            
        }catch let error {
            print(error)
        }
        favoriteLeague.append(leagueData)
       // self.tableView.reloadData()
        
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
