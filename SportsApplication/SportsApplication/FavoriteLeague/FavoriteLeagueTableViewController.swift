//
//  FavoriteLeagueTableViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/28/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import Reachability

class FavoriteLeagueTableViewController: UITableViewController {

     var favoriteLeague = [NSManagedObject]()
    var favoriteLeagueId :[String] = []
     var videoLeagueVC = YoutubeVideoViewController()
     var data = CoreDataHandler.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorite League"
          videoLeagueVC = self.storyboard?.instantiateViewController(withIdentifier: "youtubeVideoVC") as! YoutubeVideoViewController

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteLeague")
        do {
            favoriteLeague = try manageContext.fetch(fetchRequest) as! [NSManagedObject]
         
            self.tableView.reloadData()
        }catch let error
        {
            print(error)
        }
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteLeague.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteLeagueTableViewCell

        cell.fName?.text = (favoriteLeague[indexPath.row].value(forKey: "name") as! String)
        cell.fImage?.sd_setImage(with: URL(string: (favoriteLeague[indexPath.row].value(forKey: "badge") as! String)), placeholderImage: UIImage(named: "pleaceholder.png"))
        cell.configure(with: favoriteLeague[indexPath.row].value(forKey: "video") as! String)
        cell.fDelegate = self

        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteLeagueSegue" {
            let favoriteVC = segue.destination as? DetailsLeagueViewController
            
           NetworkManager.isReachable { networkManagerInstance in
                print("Network is available")
                if let leagueIndex = self.tableView.indexPathForSelectedRow?.row
                {
                    favoriteVC?.leagueId = self.favoriteLeague[leagueIndex].value(forKey:"id") as! String
                    favoriteVC?.flag = 1
                }
            }
            NetworkManager.isUnreachable { networkManagerInstance in
                print("Network is Unavailable")
                
                let alert = UIAlertController(title: "Message", message: "You Are Offline, Please connect to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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

extension FavoriteLeagueTableViewController : FavoriteLeagueTableViewCellDelegate{
    
    func fPlayVideo(with fVideoUrl: String) {
        videoLeagueVC.leagueVideo = fVideoUrl
        print("youtube")
        self.navigationController?.pushViewController(videoLeagueVC, animated: true)
    }
}
