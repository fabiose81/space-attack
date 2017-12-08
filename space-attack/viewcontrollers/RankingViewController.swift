//
//  RankingViewController.swift
//  space-attack
//
//  Created by Fabio Estrela on 17-12-08.
//  Copyright © 2017 Fabio Estrela. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
}

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var tableViewRanking: UITableView!
    
    var ranking = [String: String]()
    var rankingKeyAsList: Array<Any>!
    
    @IBAction func actionSaveScore(_ sender: UIButton)
    {
        let _user = String(describing: user.text!).trimmingCharacters(in: .whitespaces)
        
        if _user != ""
        {
            if (ranking[_user] != nil)
            {
                let alertController = UIAlertController(title: "Space-Attack", message: "Utilisateur deja exist", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
            else
            {
                ranking.updateValue("100", forKey: _user)
                rankingKeyAsList = Array(ranking.keys)
                
                tableViewRanking.reloadData()
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Space-Attack", message: "Composez un utilisateur", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ranking", for: indexPath) as! RankingTableViewCell
    
        cell.labelUserName.text = rankingKeyAsList[indexPath.row] as? String
        cell.labelScore.text = "100"
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
