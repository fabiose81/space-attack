//
//  ViewController.swift
//  space-attack
//
//  Created by Fabio Estrela on 17-12-04.
//  Copyright © 2017 Fabio Estrela. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var satellite: UIImageView!
    @IBOutlet weak var alien: UIImageView!
    @IBOutlet weak var rocket: UIImageView!
    @IBOutlet weak var explosion: UIImageView!
    @IBOutlet weak var comet: UIImageView!
    
    @IBOutlet weak var shot: UIButton!
    
    var timerAlien: Timer!
    var timerRocket: Timer!
    var timerComet: Timer!
    
    var alienExploded = 0
    var controlRotation = 0
    var angle = 0
    
    var rocketWidth = 0
    var rocketHeight = 0
    
    @IBAction func actionRotateLeft(_ sender: UIButton)
    {
        if controlRotation >= 0
        {
            satellite.transform =  satellite.transform.rotated(by: CGFloat(-45))
            rocket.transform =  rocket.transform.rotated(by: CGFloat(-45))
            controlRotation -= 1
            angle = -200
        }
    }
    
    @IBAction func actionRotateRight(_ sender: UIButton)
    {
        if controlRotation <= 0
        {
            satellite.transform =  satellite.transform.rotated(by: CGFloat(45))
            rocket.transform =  rocket.transform.rotated(by: CGFloat(45))
            controlRotation += 1
            angle = 90
        }        
    }
    
    @IBAction func actionShot(_ sender: UIButton)
    {
        rocket.isHidden = false

        sender.isEnabled = false
        
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
        let rocketWidth = rocket.frame.width
        let rocketHeight = rocket.frame.height
        
        rocket.center = satellite.center
      /*  rocket.frame = CGRect(x: 0, y: 0, width: rocketWidth, height: rocketHeight)*/
 
       /* rocket.frame.origin.x = satellite.frame.origin.x
        rocket.frame.origin.y = satellite.frame.origin.y*/
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
        
        let rocketPosition = rocket.frame.height * -1
        
        if(rocket.frame.origin.y < rocketPosition)
        {
            timerRocket.invalidate()
            createRocket()
            shot.isEnabled = true
            rocket.transform = rocket.transform.rotated(by: CGFloat(45))
        }
        
        if(rocket.frame.intersects(alien.frame))
        {
            alienExploded += 1
            score.text = String(alienExploded)
            explosion.center = alien.center
            self.explosion.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.explosion.isHidden = true
            })
            
            timerAlien.invalidate()
            timerRocket.invalidate()
            shot.isEnabled = true
            createAlien()
            createRocket()
        }
    }
    
    
    override func viewDidLoad()
    {
       // rocketWidth = Int(rocket.frame.width)
       // rocketHeight = Int(rocket.frame.height)
        
        createAlien()
        createRocket()
        createComet()
       
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

