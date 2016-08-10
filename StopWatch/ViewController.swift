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
    var timer: NSTimer!
    var count: Float = 0
    var motionManager:CMMotionManager! = CMMotionManager()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let application: UIApplication = UIApplication.sharedApplication()
        application.idleTimerDisabled = true
        
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "time:", userInfo: nil, repeats: true)
        timer.invalidate()
        
        
        motionManager.accelerometerUpdateInterval = 0.1;
        let handler:CMAccelerometerHandler = {(data:CMAccelerometerData?, error:NSError?) -> Void in
            
            let weakSelf = self
            if Float(data!.acceleration.z) >= 0.8 {
                
                if weakSelf.timer.valid == false {
                    
                    weakSelf.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: weakSelf, selector: "time:", userInfo: nil, repeats: true)
                    print(weakSelf.timer)
                }
                
            }else {
                if weakSelf.timer.valid == true {
                    
                    weakSelf.timer.invalidate()
                    
                    if weakSelf.count <= 10.0 {
                        
                        weakSelf.gameLabel.text = "success"
                        
                        let titleSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("succes",ofType:"mp3")!)
                        do {
                            weakSelf.audioPlayer = try AVAudioPlayer(contentsOfURL: titleSound, fileTypeHint: nil)
                        } catch {
                            print("Error")
                        }
                        
                        weakSelf.audioPlayer.prepareToPlay()
                        weakSelf.audioPlayer.play()
                    }
                }
            }
            
        }
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:handler)
    }
    
    func time(timer: NSTimer) {
        
        count += 0.01
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
        if count >= 10.0 {
            
            let titleSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Failure",ofType:"mp3")!)
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: titleSound, fileTypeHint: nil)
            } catch {
                print("Error")
            }
            
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            gameLabel.text = "Failure"
        }
    }
    
    
    
    @IBAction func clean(sender: AnyObject) {
        
        timer.invalidate()
        count = 0.00
        gameLabel.text = "?????"
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        
        let postView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nあなたの記録は%@です",timerLabel.text!) as String)
        postView.addImage(UIImage(named:"ELITES"))
        postView.addURL(NSURL(string:"http://elite.sc/"))
        self.presentViewController(postView, animated: true, completion: nil)
        
    }
    @IBAction func facebookButton(sender: AnyObject) {
        
        let postView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
         postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nあなたの記録は%@です",timerLabel.text!) as String)
        postView.addImage(UIImage(named:"ELITES"))
        postView.addURL(NSURL(string:"http://elite.sc/"))
        self.presentViewController(postView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

