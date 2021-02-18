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

class SportsCollectionViewController: UICollectionViewController{
    

    var sprtArray = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_sports.php").validate().responseJSON {(responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["sports"].arrayObject {
                    self.sprtArray = resData as! [[String:AnyObject]]
 
                }
                if self.sprtArray.count > 0 {
                    self.collectionView.reloadData()
                }
            }
           
        }
        
     /*   request.responseJSON { (data) in
            print(data)
        }*/
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        
        var dict = sprtArray[indexPath.row]
        cell.lblSports.text = dict["strSport"] as? String
        cell.imageSports?.sd_setImage(with: URL(string: dict["strSportThumb"] as! String), placeholderImage: UIImage(named: "placeholder.png"))

    
        return cell
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
