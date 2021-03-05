//
//  YoutubeVideoViewController.swift
//  SportsApplication
//
//  Created by MacOSSierra on 2/27/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubeVideoViewController: UIViewController {
    var leagueVideo : String = " "
    

    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            print(leagueVideo)
  
/*    let myVideoURL = NSURL(string: leagueVideo)
    videoPlayer.loadVideoURL(myVideoURL! as URL)*/
    
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
