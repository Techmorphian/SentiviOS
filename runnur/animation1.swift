//
//  animation.swift
//  runnur
//
//  Created by Sonali on 07/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import Foundation
import UIKit



class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate
{
    
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        
        return 0.8
        
    }
    
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let presentFrameForVC = CGRectMake(-(transitionContext.finalFrameForViewController(toViewController).width), 0, transitionContext.finalFrameForViewController(toViewController).width, 800)
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        
        //        let bounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame=CGRectMake(fromViewController.view.frame.width,fromViewController.view.frame.origin.y, 0, fromViewController.view.frame.height)
        
        
        
        
        
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.9 , initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
            
            fromViewController.view.alpha = 0.6
            
            
            
            toViewController.view.frame = finalFrameForVC
            
            fromViewController.view.frame = presentFrameForVC
            
            }, completion: {
                
                finished in
                
                transitionContext.completeTransition(true)
                
                fromViewController.view.alpha = 1.0
                
        })
        
    }
    
    
    
}

