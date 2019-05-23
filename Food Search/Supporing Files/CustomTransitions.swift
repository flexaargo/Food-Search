//
//  CustomTransitions.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

open class ModalPushAnimator: NSObject {}

extension ModalPushAnimator: UIViewControllerAnimatedTransitioning {
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toVC = transitionContext.viewController(forKey: .to) else {
      return
    }
    transitionContext.containerView.addSubview(toVC.view)
//    toVC.view.alpha = 0
    toVC.view.frame = CGRect(x: toVC.view.frame.width, y: 0, width: toVC.view.frame.width, height: toVC.view.frame.height)
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
//      toVC.view.alpha = 1
      toVC.view.frame = CGRect(x: 0, y: 0, width: toVC.view.frame.width, height: toVC.view.frame.height)
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}

open class ModalPopAnimator: NSObject {}

extension ModalPopAnimator: UIViewControllerAnimatedTransitioning {
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) else {
      return
    }
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      fromVC.view.frame = CGRect(x: 0, y: fromVC.view.frame.height, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
