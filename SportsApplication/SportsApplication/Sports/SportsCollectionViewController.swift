//
//  SportsCollectionViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/16/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

private let reuseIdentifier = "Cell"
let kCellHeight : CGFloat = 150
let kLineSpacing : CGFloat = 0
let kInset : CGFloat = 0

class SportsCollectionViewController: UICollectionViewController{
    

   var sprtArray :[Sports] = []
    var leagueVC = LeagueTableViewController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.collectionView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 1, blue: 0, alpha: 1)
        leagueVC = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesVC") as! LeagueTableViewController

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_sports.php").validate().responseJSON {(responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                let resData = swiftyJsonVar["sports"]
                
                for i in resData.arrayValue{
                    let sport = Sports()
                    sport.sportName = i["strSport"].stringValue
                    sport.sportImage = i["strSportThumb"].stringValue
                    self.sprtArray.append(sport)
                }
                self.collectionView.reloadData()

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sprtArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SportsCollectionViewCell
        cell.lblSports.text = sprtArray[indexPath.row].sportName
        cell.imageSports?.sd_setImage(with: URL(string: sprtArray[indexPath.row].sportImage), placeholderImage: UIImage(named: "placeholder.png"))

    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        leagueVC.sportName = (sprtArray[indexPath.row].sportName)
        self.navigationController?.pushViewController(leagueVC, animated: true)
    }

 
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension SportsCollectionViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 2*kInset - kLineSpacing)/2, height: kCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return kLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: kInset, left: kInset, bottom: kInset, right: kInset)
    }
}
