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
    
    @IBOutlet weak var satellite: UIImageView!
    @IBOutlet weak var alien: UIImageView!
    @IBOutlet weak var explosion: UIImageView!
    @IBOutlet weak var comet: UIImageView!
    
    @IBOutlet weak var shot: UIButton!
  
    @IBOutlet weak var timeRemains: UILabel!
    
    var rocket: UIImageView!
    
    var timerAlien: Timer!
    var timerRocket: Timer!
    var timerComet: Timer!
    var timerGameOver: Timer!
    
    var playerExplosion: AVAudioPlayer?
    
    var alienExploded = 0
    var controlRotation = 0
    var angle = -300
    var time = 10
    
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
    
    @IBAction func actionShot(_ sender: UIButton)
    {
        sender.isEnabled = false
        rocket.isHidden = false
        
        timerRocket =  Timer.scheduledTimer(timeInterval: 0.01,
                                        target: self,
                                        selector: #selector(animationRocket),
                                        userInfo: nil,
                                        repeats: true)
    }
    
    func createAlien()
    {
        let viewHeight = round(UIScreen.main.bounds.height / 2)
        let alienWidth = alien.frame.width
        let alienHeight = alien.frame.height
        let positionX = CGFloat(Int(UIScreen.main.bounds.width))
        let positionY = CGFloat(Int(arc4random_uniform(UInt32(viewHeight))))
        
        alien.frame = CGRect(x: positionX, y: positionY, width: alienWidth, height: alienHeight)
        
        let timeInterval = 0.01 * Double(Int(arc4random_uniform(UInt32(2)))+1)
        
        timerAlien =  Timer.scheduledTimer(timeInterval: timeInterval,
                                       target: self,
                                       selector: #selector(animationAlien),
                                       userInfo: nil,
                                       repeats: true)
    }
    
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
    
    func createComet()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.timerComet =  Timer.scheduledTimer(timeInterval: 0.002,
                                               target: self,
                                               selector: #selector(self.animationComet),
                                               userInfo: nil,
                                               repeats: true)
        })
    }
    
    @objc func animationAlien()
    {
        alien.frame.origin.x = alien.frame.origin.x - 1
        
        let alienPosition = alien.frame.width * -1
        
        if(alien.frame.origin.x < alienPosition)
        {
            timerAlien.invalidate()
            createAlien()
        }
    }
    
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
            shot.isEnabled = true
        }
        
        if(rocket.frame.intersects(alien.frame))
        {
            playerExplosion?.play()
            alienExploded += 1
            time += 10
            score.text = String(alienExploded)
            explosion.center = alien.center
            self.explosion.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.explosion.isHidden = true
            })
            
            timerAlien.invalidate()
            timerRocket.invalidate()
            shot.isEnabled = true
            rocket.isHidden = true
            rocket = nil
            createAlien()
            createRocket()
        }
    }
    
    @objc func countDown()
    {
        time -= 1;
        
        timeRemains.text = String(time)
        
        if time == 0 {
            timerGameOver.invalidate()
            if (timerRocket != nil) {
                timerRocket.invalidate()
            }
            
            performSegue(withIdentifier: "seg", sender: self)
        }
       
    }
    
    func initTime(){
        timerGameOver =  Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(countDown),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    //--- Fonctions pour commencer l'audio
    func initSound()
    {
        guard let urlExplosion = Bundle.main.url(forResource: "explosion", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerExplosion = try AVAudioPlayer(contentsOf: urlExplosion)
            playerExplosion?.setVolume(1.0, fadeDuration: 0)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad()
    {
        shot.layer.cornerRadius = 35
        shot.titleLabel?.adjustsFontSizeToFitWidth = true
        createAlien()
        createRocket()
        createComet()
        initSound()
        initTime()
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            createComet()
        }
    }

}

