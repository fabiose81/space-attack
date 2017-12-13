//
//  User.swift
//  space-attack
//
//  Created by eleves on 2017-12-12.
//  Copyright © 2017 Fabio Estrela. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var name: String!
    var score: String!
    var date: String!
   
    
    init(name: String!, score: String!, date: String!) {
        self.name = name
        self.score = score
        self.date = date
    }
    
    //Fonction pour la decodification de la structure pour l'utilisation de UserDefaults
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "name") as? String
        score = decoder.decodeObject(forKey: "score") as? String
        date = decoder.decodeObject(forKey: "date") as? String
    }
    
    //Fonction pour la codification de la structure pour l'utilisation de UserDefaults
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(score, forKey: "score")
        coder.encode(date, forKey: "date")
    }
}
