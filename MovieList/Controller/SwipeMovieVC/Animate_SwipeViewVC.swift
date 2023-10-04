//
//  Animate_SwipeViewVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

extension SwipeMovieVC {
    func removeFirst(action:PanActionType) {//here
        guard let cards = movieBoxes else { return }
        cards.second?.isUserInteractionEnabled = true
        let old = cards.first
        var newCenter:CGPoint {
            switch action {
            case .dislike:
                let val = self.view.frame.width
                return .init(x: (val + 200) * (-1), y: old.layer.position.y)
            case .like:
                let val = self.view.frame.width
                return .init(x: val + 400, y: old.layer.position.y)
            }
        }
        self.cardWillMove(for: action, card: old)
        UIView.animate(withDuration: 0.24, delay: 0, options: .allowUserInteraction, animations: {
            old.vc?.view.alpha = 0
            old.layer.position = newCenter
            old.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: { _ in
            old.vc?.view.removeFromSuperview()
            old.vc?.removeFromParent()
            old.removeFromSuperview()
            self.cardDidMove(for: action, card: cards.first)
        })
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {_ in
            self.moveNext(all: cards, removed: true)
        })
        
        
        
    }
    
    
    func fixView(cards: (first: MoviePreviewView, second: MoviePreviewView?, third: MoviePreviewView?), cardRemoved:Bool = false, firstLoaded:Bool = false) {
        if !touched {
            self.containerView.alpha = 0
            self.containerView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
        }
        if cardRemoved {
            print("fixViewcardRemoved")
            UIView.animate(withDuration: 0.23, delay: 0, options: .allowUserInteraction, animations: {
                self.performMoveCards(cards: cards)
            }, completion: { _ in
                self.cardMovedToTop(card: cards.first, fixingViews: true)
            })
        } else {
            print("fixViewsdfdfs")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction]) {
                self.performMoveCards(cards: cards)
            } completion: { _ in
                self.cardMovedToTop(card: cards.first, fixingViews: true, cardRemoved: cardRemoved)
                if firstLoaded {
                    print("egrfwcdwrfe")
                    self.removeFirst(action: .like)
                }
            }
        }
        
    }
    
    
    
    
    func setAnimating(animating:Bool = false, error:MessageContent? = nil, completion:(()->())? = nil) {
        let showStack = animating || error != nil
        let showButton = error != nil
        if self.loadingStack.isHidden != !showStack || reloadButton.isHidden != !showButton {
            let errorTitleLabel =                 self.loadingStack.arrangedSubviews.first(where: {$0 is UILabel && $0.tag == 0}) as? UILabel
            let errorDescriptionLabel =                 self.loadingStack.arrangedSubviews.first(where: {$0 is UILabel && $0.tag == 1}) as? UILabel
            let aiView = self.loadingStack.arrangedSubviews.first(where: {$0 is UIActivityIndicatorView}) as? UIActivityIndicatorView
            var animateButton:Bool = false
            let toHideButton = self.view.safeAreaInsets.bottom + self.reloadButton.frame.height + 20
            
            if showButton {
                errorTitleLabel?.text = error?.title
                errorDescriptionLabel?.text = error?.description
                reloadButton.isHidden = false
                self.reloadButton.layer.move(.top, value: toHideButton)
                animateButton = true
            }
            let alphaStack:CGFloat = showStack ? 1 : 0
            UIView.animate(withDuration: 0.3, animations: {
                if self.loadingStack.alpha != alphaStack {
                    self.loadingStack.alpha = alphaStack
                }
                if errorTitleLabel?.isHidden != !showButton {
                    errorTitleLabel?.isHidden = !showButton
                }
                if errorDescriptionLabel?.isHidden != !showButton {
                    errorDescriptionLabel?.isHidden = !showButton
                }
                
                aiView?.setAnimating = animating
                if self.reloadButton.isHidden != !showButton || animateButton {
                    self.reloadButton.layer.move(.top, value: showButton ? 0 : toHideButton)
                }
            }, completion: { _ in
                completion?()
                if self.reloadButton.isHidden != !showButton {
                    self.reloadButton.isHidden = !showButton
                }
            })
        } else {
            completion?()
        }
    }
}
