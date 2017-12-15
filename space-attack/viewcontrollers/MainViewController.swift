//
//  ViewController.swift
//  space-attack
//
//  Created by Fabio Estrela on 17-12-04.
//  Copyright © 2017 Fabio Estrela. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var ready: UILabel!
    @IBOutlet weak var timeRemains: UILabel!
    
    @IBOutlet weak var satellite: UIImageView!
    @IBOutlet weak var alien: UIImageView!
    @IBOutlet weak var explosion: UIImageView!
    @IBOutlet weak var comet: UIImageView!
    
    @IBOutlet weak var rotateLeft: UIButton!
    @IBOutlet weak var rotateRight: UIButton!
    @IBOutlet weak var shoot: UIButton!
    
    var rocket: UIImageView!
    
    var timerAlien: Timer!
    var timerRocket: Timer!
    var timerComet: Timer!
    var timerGameOver: Timer!
    
    var playerBeep: AVAudioPlayer?
    var playerBackground: AVAudioPlayer?
    var playerExplosion: AVAudioPlayer?
    
    var alienExploded = 0
    var controlRotation = 0
    var angle = -300
    var time = 30
    
    //Fonction pour faire la rotation du satellite à gauche
    @IBAction func actionRotateLeft(_ sender: UIButton)
    {
        if controlRotation >= 0
        {
            satellite.transform =  satellite.transform.rotated(by: CGFloat(-45))
            rocket.transform =  rocket.transform.rotated(by: CGFloat(-45))
            controlRotation -= 1
            if controlRotation == 0
            {
                angle = -300
            }
            else
            {
                angle = 45
            }
        }
    }
    
    //Fonction pour faire la rotation du satellite à droit
    @IBAction func actionRotateRight(_ sender: UIButton)
    {
        if controlRotation <= 0
        {
            satellite.transform =  satellite.transform.rotated(by: CGFloat(45))
            rocket.transform =  rocket.transform.rotated(by: CGFloat(45))
            controlRotation += 1
            if controlRotation == 0
            {
                angle = -300
            }
            else
            {
                angle = 90
            }
        }
    }
    
    //Fonction pour lancer le rocket
    @IBAction func actionShot(_ sender: UIButton)
    {
        sender.titleLabel?.text = "attendez"
        sender.isEnabled = false
        rocket.isHidden = false
        rotateLeft.isEnabled = false
        rotateRight.isEnabled = false
        
        timerRocket =  Timer.scheduledTimer(timeInterval: 0.005,
                                        target: self,
                                        selector: #selector(animationRocket),
                                        userInfo: nil,
                                        repeats: true)
    }
    
    //Fonction pour créer l'alien et lui mettre sur l'écran
    func createAlien()
    {
        let viewHeight = round(UIScreen.main.bounds.height / 2)
        let alienWidth = alien.frame.width
        let alienHeight = alien.frame.height
        let positionX = CGFloat(Int(UIScreen.main.bounds.width))
        let positionY = CGFloat(Int(arc4random_uniform(UInt32(viewHeight))))
        
        alien.frame = CGRect(x: positionX, y: positionY, width: alienWidth, height: alienHeight)
        
        let timeInterval = 0.003 * Double(Int(arc4random_uniform(UInt32(2)))+1)
        
        timerAlien =  Timer.scheduledTimer(timeInterval: timeInterval,
                                       target: self,
                                       selector: #selector(animationAlien),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    //Fonction pour créer le rocket
    func createRocket()
    {
        let imagem = UIImage(named: "rocket")
        rocket = UIImageView(image:imagem)
        rocket.frame = CGRect(x: 0, y: 0, width: 19, height: 50)
        view.addSubview(rocket)
        rocket.center = satellite.center
        rocket.transform = satellite.transform
        rocket.isHidden = true
    }
    
    //Fonction pour commencer l'animation du comet
    func beginAnimationComet()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.timerComet =  Timer.scheduledTimer(timeInterval: 0.002,
                                               target: self,
                                               selector: #selector(self.animationComet),
                                               userInfo: nil,
                                               repeats: true)
        })
    }
    
    //Fonction pour faire l'animation d'alien
    @objc func animationAlien()
    {
        alien.frame.origin.x = alien.frame.origin.x - 1
        
        let alienPosition = alien.frame.width * -1
        
        if(alien.frame.origin.x < alienPosition)
        {
            timerAlien.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.createAlien()
            })
        }
    }
    
     //Fonction pour faire l'animation du rocket et de la collision avec l'alien
    @objc func animationRocket()
    {
        let cos = __cospi(Double(angle)/Double.pi)
        let sin = __sinpi(Double(angle)/Double.pi)
        
        rocket.center.x -= CGFloat(cos)
        rocket.center.y -= CGFloat(sin)
        
        let rocketPositionX = rocket.frame.width * -1
        let rocketPositionY = rocket.frame.height * -1
        
        if(rocket.frame.origin.x < rocketPositionX || rocket.frame.origin.y < rocketPositionY)
        {
            timerRocket.invalidate()
            rocket.isHidden = true
            rocket = nil
            createRocket()
            shoot.isEnabled = true
            shoot.titleLabel?.text = "shoot"
            rotateLeft.isEnabled = true
            rotateRight.isEnabled = true
        }
        
        if(rocket.frame.intersects(alien.frame))
        {
            playerExplosion?.play()
            alienExploded += 1
            time += 5
            score.text = "score: \(String(alienExploded))"
            explosion.center = alien.center
            self.explosion.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.explosion.isHidden = true
            })
            
            timerAlien.invalidate()
            timerRocket.invalidate()
            rotateLeft.isEnabled = true
            rotateRight.isEnabled = true
            shoot.isEnabled = true
            rocket.isHidden = true
            rocket = nil
            createAlien()
            createRocket()
        }
    }
    
    //Fonction pour faire l'animation du comet
    @objc func animationComet()
    {
        let cos = __cospi(Double(-45)/Double.pi)
        let sin = __sinpi(Double(-45)/Double.pi)
        
        comet.center.x -= CGFloat(cos)
        comet.center.y -= CGFloat(sin)
        
        if comet.frame.origin.x < (rocket.frame.width * -1)
        {
            timerComet.invalidate()
            comet.frame.origin.y = -100
            
            let width = UIScreen.main.bounds.size.width
            let positionX =  Int(arc4random_uniform(UInt32(width - 100 + 1)) + 100)
            
            comet.frame.origin.x = CGFloat(positionX)
            beginAnimationComet()
        }
    }
    
    //Fonction pour faire la compte à rebours du jeu
    @objc func countDown()
    {
        time -= 1;
        timeRemains.text = "temps restant: \(String(time))"
        
        if time == 0 {
            timerGameOver.invalidate()
            if (timerRocket != nil) {
                timerRocket.invalidate()
            }
            
            if (timerAlien != nil) {
                timerAlien.invalidate()
            }
            
            ready.text = "Jeu terminé"
            ready.alpha = 1
            playerBackground?.stop()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.performSegue(withIdentifier: "rank", sender: self)
            })
        }
        else if time < 10
        {
            timeRemains.textColor = UIColor.red
        }
        else
        {
            timeRemains.textColor = UIColor.white
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rank" ,
            let rankingViewController = segue.destination as? RankingViewController {
             rankingViewController.score = alienExploded
        }
    }
    
    //Fonction pour commencer la compte à rebours du jeu
    func initTime(){
        timerGameOver =  Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(countDown),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    //Fonction pour commencer l'audio
    func initSound()
    {
        guard let urlBackground = Bundle.main.url(forResource: "background", withExtension: "m4a") else { return }
        guard let urlExplosion = Bundle.main.url(forResource: "explosion", withExtension: "mp3") else { return }
        guard let urlBeep = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerExplosion = try AVAudioPlayer(contentsOf: urlExplosion)
            playerExplosion?.setVolume(2.0, fadeDuration: 0)
            
            playerBeep = try AVAudioPlayer(contentsOf: urlBeep)
            playerBeep?.setVolume(1.5, fadeDuration: 0)
            
            playerBackground = try AVAudioPlayer(contentsOf: urlBackground)
            playerBackground?.setVolume(0.8, fadeDuration: 0)
            playerBackground?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //Fonction pour commencer le jeu
    func starting(n: Int){
        ready.text = String(n)
        self.playerBeep?.play()
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            self.ready.alpha = 0
        }) { (true) in
            self.ready.alpha = 1
            let _n = n - 1
          
            if _n > 0
            {
                self.starting(n: _n)
            }
            else
            {
                self.ready.text = "Allez!"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.ready.alpha = 0
                    self.rotateLeft.isEnabled = true
                    self.rotateRight.isEnabled = true
                    self.shoot.isEnabled = true
                    self.createAlien()
                    self.createRocket()
                    self.beginAnimationComet()
                    self.initTime()
                    self.playerBackground?.play()
                })
            }
        }
    }

    override func viewDidLoad()
    {
        self.initSound()
        timeRemains.text = "temps restant: \(String(time))"
        shoot.titleLabel?.adjustsFontSizeToFitWidth = true
        ready.adjustsFontSizeToFitWidth = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.starting(n:3)
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

