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
        let cPos = old.frame
        var newCenter:CGPoint {
            switch action {
            case .dislike:
                let val = self.view.frame.width
                return .init(x: (val + 200) * (-1), y: old.layer.position.y)
            case .like:
                let val = self.view.frame.width
                return .init(x: val + 400, y: old.layer.position.y)
            case .superLike, .bet:
                let val = self.view.frame.height
                return .init(x: old.layer.position.x, y: (val + 200) * (-1))
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
}
