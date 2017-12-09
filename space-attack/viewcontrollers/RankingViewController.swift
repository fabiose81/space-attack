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
    var rankingSorted = [(key: String, value: String)]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var score = 0
    
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
                ranking.updateValue(String(score), forKey: _user)
                rankingSorted = ranking.sorted{ $0.value < $1.value }
                
                userDefaultsManager.setKey(theValue: ranking as AnyObject, key: "ranking")
                
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
    
        let key = rankingSorted[indexPath.row].key
        
        cell.labelUserName.text = key
        cell.labelScore.text = ranking[key]
        
        return cell
    }
    override func viewDidLoad() {
        if userDefaultsManager.doesKeyExist(theKey: "ranking")
        {
            ranking =  userDefaultsManager.getValue(theKey: "ranking") as! [String: String]
            rankingSorted = ranking.sorted{ $0.value < $1.value }
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
