//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Russ Johnson on 3/9/16.
//  Copyright © 2016 Russ Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var monsterImage: MonsterImg!
  @IBOutlet weak var foodImage: DragImage!
  @IBOutlet weak var heartImage: DragImage!

  @IBOutlet var penaltyImg1: UIImageView!
  @IBOutlet var penaltyImg2: UIImageView!
  @IBOutlet var penaltyImg3: UIImageView!
  
  let DIM_ALPHA: CGFloat = 0.1
  let OPAQUE: CGFloat = 1.0
  let MAX_PENALTIES = 3
  
  var penalties = 0
  var timer: NSTimer!
  var monsterHappy = false
  var currentItem: UInt32 = 0
  
  var musicPlayer: AVAudioPlayer!
  var sfxBite: AVAudioPlayer!
  var sfxHeart: AVAudioPlayer!
  var sfxDeath: AVAudioPlayer!
  var sfxSkull: AVAudioPlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    foodImage.dropTarget = monsterImage
    heartImage.dropTarget = monsterImage
    
    penaltyImg1.alpha = DIM_ALPHA
    penaltyImg2.alpha = DIM_ALPHA
    penaltyImg3.alpha = DIM_ALPHA
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
    
    do {
      try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
      try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
      try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
      try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
      try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
      
      musicPlayer.prepareToPlay()
      musicPlayer.play()
      
      sfxBite.prepareToPlay()
      sfxHeart.prepareToPlay()
      sfxDeath.prepareToPlay()
      sfxSkull.prepareToPlay()
      
    } catch let err as NSError {
      print(err.debugDescription)
    }
    
    startTimer()
  }
  
  func itemDroppedOnCharacter(notif: AnyObject) {
    monsterHappy = true
    startTimer()
    
    foodImage.alpha = DIM_ALPHA
    foodImage.userInteractionEnabled = false
    heartImage.alpha = DIM_ALPHA
    foodImage.userInteractionEnabled = false
    
    if currentItem == 0 {
      sfxHeart.play()
    } else {
      sfxBite.play()
    }
    
  }
  
  func startTimer() {
    if timer != nil {
      timer.invalidate()
    }
    
    timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
  }
  
  func changeGameState() {
    
    
    if !monsterHappy {
      penalties++
      sfxSkull.play()
      
      if penalties == 1 {
        penaltyImg1.alpha = OPAQUE
        penaltyImg2.alpha = DIM_ALPHA
      } else if penalties == 2 {
        penaltyImg2.alpha = OPAQUE
        penaltyImg3.alpha = DIM_ALPHA
      } else if penalties == 3 {
        penaltyImg3.alpha = OPAQUE
      } else {
        penaltyImg1.alpha = DIM_ALPHA
        penaltyImg2.alpha = DIM_ALPHA
        penaltyImg3.alpha = DIM_ALPHA
      }
      
      if penalties >= MAX_PENALTIES {
        gameOver()
      }
    }
    
    let rand = arc4random_uniform(2)
    
    if rand == 0 {
      foodImage.alpha = DIM_ALPHA
      foodImage.userInteractionEnabled = false
      
      heartImage.alpha = OPAQUE
      heartImage.userInteractionEnabled = true
    } else {
      heartImage.alpha = DIM_ALPHA
      heartImage.userInteractionEnabled = false
      
      foodImage.alpha = OPAQUE
      foodImage.userInteractionEnabled = true
    }
    
    currentItem = rand
    monsterHappy = false
    
  }
  
  
  func gameOver() {
    timer.invalidate()
    monsterImage.playDeathAnimation()
    sfxDeath.play()
  }
  
}

