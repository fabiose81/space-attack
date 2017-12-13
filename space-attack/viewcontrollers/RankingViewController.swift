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
    @IBOutlet weak var labelDate: UILabel!
    
}

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var tableViewRanking: UITableView!
    
    var users = [User]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var score = 0
    
    @IBAction func actionSaveScore(_ sender: UIButton)
    {
        let _user = String(describing: user.text!).trimmingCharacters(in: .whitespaces)
        
        if _user != ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.string(from: NSDate() as Date)
            
            let user = User(name: _user, score: String(score), date: date)
            users.append(user)
               
            let data = NSKeyedArchiver.archivedData(withRootObject: users);
            userDefaultsManager.setKey(theValue: data as AnyObject, key: "users")
            
            tableViewRanking.reloadData()
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ranking", for: indexPath) as! RankingTableViewCell
    
        let name = users[indexPath.row].name
        let score = users[indexPath.row].score
        let date = users[indexPath.row].date
        
        cell.labelUserName.text = name
        cell.labelScore.text = score
        cell.labelDate.text = date
        
        return cell
    }
    
    override func viewDidLoad() {
        if userDefaultsManager.doesKeyExist(theKey: "users")
        {
            let data = userDefaultsManager.getData(theKey: "users")
            users = (NSKeyedUnarchiver.unarchiveObject(with: data ) as? [User])!
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
