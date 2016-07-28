//
//  CircleLabel.swift
//  runnur
//
//  Created by Sonali on 08/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation

class CircleLabel: UILabel
{
  
//    @IBInspectable var topInset: CGFloat = 5.0
//    @IBInspectable var bottomInset: CGFloat = 5.0
//    @IBInspectable var leftInset: CGFloat = 7.0
//    @IBInspectable var rightInset: CGFloat = 7.0
    
//    override func drawTextInRect(rect: CGRect)
//    {
//        
//        let insets = UIEdgeInsets(top: 30, left: 30.0, bottom: 30.0, right: 30)
//        
//        self.clipsToBounds = true
//
//        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
//    }
//    
//    override func intrinsicContentSize() -> CGSize
//    {
//        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
//        intrinsicSuperViewContentSize.height += 50.0 + 50.0
//        intrinsicSuperViewContentSize.width += 30.0 + 30.0
//        return intrinsicSuperViewContentSize
//    }

    
    
    /// new
    
    
    let topInset = CGFloat(2.0), bottomInset = CGFloat(2.0), leftInset = CGFloat(15.0), rightInset = CGFloat(15.0)
    
    override func drawTextInRect(rect: CGRect)
    {
      
        
//        self.layer.cornerRadius = self.frame.size.width / 2;
//        self.backgroundColor = colorCode.RedColor
//        self.layer.masksToBounds = true
      // self.clipsToBounds = true

    
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    
    
}
