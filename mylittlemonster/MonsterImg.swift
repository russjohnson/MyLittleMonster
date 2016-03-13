//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Russ Johnson on 3/10/16.
//  Copyright © 2016 Russ Johnson. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    playIdleAnimation()
  }
  
  func playIdleAnimation() {
    
    self.image = UIImage(named: "idle1")
    self.animationImages = nil
    
    var imgArray = [UIImage]()
    
    for var i=1; i <= 4; i++ {
      let img = UIImage(named: "idle\(i)")
      imgArray.append(img!)
    }
    
    self.animationImages = imgArray
    self.animationDuration = 0.8
    self.animationRepeatCount = 0
    self.startAnimating()
  }
  
  func playDeathAnimation() {
    
    self.image = UIImage(named: "dead5")
    self.animationImages = nil
    
    var imgArray = [UIImage]()
    
    for var i=1; i <= 5; i++ {
      let img = UIImage(named: "dead\(i)")
      imgArray.append(img!)
    }
    
    self.animationImages = imgArray
    self.animationDuration = 0.8
    self.animationRepeatCount = 1
    self.startAnimating()
  }
  
  
}