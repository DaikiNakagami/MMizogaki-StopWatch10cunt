//
//  ViewController.swift
//  StopWatch
//
//  Created by Voice on 2/16/16.
//  Copyright © 2016 Voice. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation
import Social


class ViewController: UIViewController {
    
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var timer: Timer!
    var count: Float = 0
    var motionManager:CMMotionManager! = CMMotionManager()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let application: UIApplication = UIApplication.shared
        application.isIdleTimerDisabled = true
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.time(_:)), userInfo: nil, repeats: true)
        timer.invalidate()
        
        
        motionManager.accelerometerUpdateInterval = 0.1;
        let handler:CMAccelerometerHandler = {(data:CMAccelerometerData?, error:NSError?) -> Void in
            
            let weakSelf = self
            if Float(data!.acceleration.z) >= 0.8 {
                
                if weakSelf.timer.isValid == false {
                    
                    weakSelf.timer = Timer.scheduledTimer(timeInterval: 0.01, target: weakSelf, selector: #selector(ViewController.time(_:)), userInfo: nil, repeats: true)
                    print(weakSelf.timer)
                }
                
            }else {
                if weakSelf.timer.isValid == true {
                    
                    weakSelf.timer.invalidate()
                    
                    if weakSelf.count <= 10.0 {
                        
                        weakSelf.gameLabel.text = "success"
                        
                        let titleSound = URL(fileURLWithPath:Bundle.main.path(forResource: "succes",ofType:"mp3")!)
                        do {
                            weakSelf.audioPlayer = try AVAudioPlayer(contentsOf: titleSound, fileTypeHint: nil)
                        } catch {
                            print("Error")
                        }
                        
                        weakSelf.audioPlayer.prepareToPlay()
                        weakSelf.audioPlayer.play()
                    }
                }
            }
            
        } as! CMAccelerometerHandler
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:handler)
    }
    
    func time(_ timer: Timer) {
        
        count += 0.01
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
        if count >= 10.0 {
            
            let titleSound = URL(fileURLWithPath:Bundle.main.path(forResource: "Failure",ofType:"mp3")!)
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: titleSound, fileTypeHint: nil)
            } catch {
                print("Error")
            }
            
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            gameLabel.text = "Failure"
        }
    }
    
    
    
    @IBAction func clean(_ sender: AnyObject) {
        
        timer.invalidate()
        count = 0.00
        gameLabel.text = "?????"
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
    }
    
    @IBAction func twitterButton(_ sender: AnyObject) {
        
        let postView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nあなたの記録は%@です",timerLabel.text!) as String)
        postView.add(UIImage(named:"ELITES"))
        postView.add(URL(string:"http://elite.sc/"))
        self.present(postView, animated: true, completion: nil)
        
    }
    @IBAction func facebookButton(_ sender: AnyObject) {
        
        let postView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
         postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nあなたの記録は%@です",timerLabel.text!) as String)
        postView.add(UIImage(named:"ELITES"))
        postView.add(URL(string:"http://elite.sc/"))
        self.present(postView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

