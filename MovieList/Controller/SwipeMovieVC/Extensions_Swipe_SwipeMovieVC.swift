//
//  Extensions_SwipeMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

extension SwipeMovieVC {
    func createMovie() -> MoviePreviewView? {
        if data.count - 1 >= index && data.count != 0 {
            return performCreatingMovie()
        } else {
            return nil
        }
    }
    
    func moveNext(all:(first:MoviePreviewView, second:MoviePreviewView?, third:MoviePreviewView?), firstLoad:Bool = false, removed:Bool = false) {
        let nextCard = firstLoad ? all.first : all.second
        if let first = nextCard {
            let second = (firstLoad ? all.second : all.third) ?? self.createMovie()
            self.prepareFirstCard(to: first)
            let third = firstLoad ? all.third : self.createMovie()
            
            let newCards = (first:first, second:second, third:third)
            self.movieBoxes = newCards
            first.touchesEnded()
            self.fixView(cards: newCards, cardRemoved: removed)
            
        } else {
           // self.toggleScreenAI(hide: false)
            if apiError == nil {
                self.loadMovies()
            }
        }
    }
    
    func prepareFirstCard(to container: MoviePreviewView) {
        
        container.isUserInteractionEnabled = true
        container.layer.zPosition = 9999999
        container.alpha = 1
        container.vc?.containerAppeared()
    }
    
    
    private func prepareAlphaValue(isSecond:Bool, scrollValue: CGFloat) -> CGFloat {
        let maxZeroOne = scrollValue / 10
        let def:CGFloat = isSecond ? 0.9 : 0.8
        let new = def + maxZeroOne
        let max = isSecond ? 1.0 : 0.9
        return new <= max ? new : max
    }
    
    private func prepareTransform(isSecond:Bool, scrollValue: CGFloat) -> CGFloat {
        let scrollHorHelper = scrollValue * 50
        let def:CGFloat = isSecond ? transform.first : transform.second
        let newHorixontal = def - scrollHorHelper
        return newHorixontal >= 0 ? newHorixontal : 0
    }
    
    func performMoveCards(cards: (first: MoviePreviewView, second: MoviePreviewView?, third: MoviePreviewView?)) {
        cards.first.transform = CGAffineTransform(rotationAngle: 0)
        cards.first.moveToCenter()
        cards.first.vc?.view.backgroundColor = .white

        self.prepareAdditionalCard(cards.second, isSecond: true)
        self.prepareAdditionalCard(cards.third, isSecond: false)
        let previewVC = cards.first.vc
        previewVC?.updateScroll(scrValue: 0, topValue: 0, action: nil)
        if self.touched {
            self.containerView.alpha = 1
        }
    }
    
    private func prepareAdditionalCard(_ container:MoviePreviewView?, isSecond:Bool) {
        container?.vc?.view.backgroundColor = .red
        container?.layer.zPosition = isSecond ? -1 : -2
        container?.isUserInteractionEnabled = false
        container?.subviews.last?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, isSecond ? transform.first : transform.second, 0)
        let transform:CGFloat = isSecond ? 0.9 : 0.8
        container?.layer.transform = CATransform3DMakeScale(transform, transform, 1)
        container?.alpha = transform + 0.5
    }
    
    private func performCreatingMovie() -> MoviePreviewView {
        let container = MoviePreviewView()
        containerView.addSubview(container)
        container.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: containerView)
        container.center =
            .init(x: self.view.frame.width / 2, y: self.view.frame.height / 3)
        container.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)

        let panGesture:UIPanGestureRecognizer = .init(target: self, action: #selector(containerPanned(_:)))
        container.gesture = panGesture
        container.addGestureRecognizer(panGesture)
        
        let vc = MovieVC()
        addChild(vc)
        container.addSubview(vc.view)
        vc.view.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: container)
        container.vc = vc
        index += 1
        print(index, " ytgrfewd")
        return container
    }
    
    @objc func containerPanned(_ sender:UIPanGestureRecognizer) {
        cardsGestureManager.update(sender)
    }
    
    func setupCardsWhileScrolling(_ action: PanActionType, _ scrollValue: CGFloat, cards:(first:MoviePreviewView, second:MoviePreviewView?, third:MoviePreviewView?)) {
        let secondAlpha = prepareAlphaValue(isSecond: true, scrollValue: scrollValue)
        cards.second?.alpha = secondAlpha
        cards.second?.layer.transform = CATransform3DMakeScale(secondAlpha, secondAlpha, 1)
        
        let thirdAlpha = prepareAlphaValue(isSecond: false, scrollValue: scrollValue)
        cards.third?.alpha = thirdAlpha
        cards.third?.layer.transform = CATransform3DMakeScale(thirdAlpha, thirdAlpha, 1)
        
        let secondTransform = prepareTransform(isSecond: true, scrollValue: scrollValue)
        let thirdTransform = prepareTransform(isSecond: false, scrollValue: scrollValue)
        cards.second?.subviews.last?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, secondTransform, 0)
        cards.third?.subviews.last?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, thirdTransform, 0)
    }
    
    func setupGradientButtons(action:PanActionType, value:CGFloat, topCalc:CGFloat) {
       /* let dict:[PanActionType:TapGradientButton] = [
            .bet:superBetButton,
            .dislike:dislikeButton,
            .like:likeButton,
            .superLike:betButton
        ]
        dict.forEach { (actionKey, button) in
            let val = action == .bet || action == .superLike ? topCalc : value
            button.pressed(percent: actionKey == action ? val : 0, animated: false)
        }*/
    }
}

extension SwipeMovieVC:ContainerPanGestureProtocol {
    func updateWhileScrolling(_ action: PanActionType?, _ scrollValue: CGFloat, topCalc: CGFloat) {
        touched = true
        guard let cards = movieBoxes else { return }
        let previewVC = cards.first.vc
        guard let action = action else {
            UIView.animate(withDuration: 0.3) {
                cards.first.transform = CGAffineTransform(rotationAngle: 0)
            }
            return
        }
        setupCardsWhileScrolling(action, scrollValue, cards: cards)
        setupGradientButtons(action: action, value: scrollValue, topCalc: topCalc)

        if scrollValue >= 0.15 && (previewVC?.isHapptic ?? false) {
            previewVC?.happtic(start: false)
        }
        rotateCard(action: action, scrollValue: scrollValue)
    }
    
    private func rotateCard(action: PanActionType, scrollValue:CGFloat) {
        guard let cards = self.movieBoxes else { return }
        switch action {
        case .dislike:
            cards.first.transform = CGAffineTransform(rotationAngle: (scrollValue / 5) * (-1))
        case .like:
            cards.first.transform = CGAffineTransform(rotationAngle: scrollValue / 5)
        case .superLike, .bet:
            UIView.animate(withDuration: 0.3) {
                cards.first.transform = CGAffineTransform(rotationAngle: 0)
            }
            
        }
    }
    
    func panEndAction(_ action: PanActionType?) {
        guard let cards = self.movieBoxes else { return }
        if let action = action {
            removeFirst(action: action)
        } else {
            fixView(cards: cards)
        }
    }
    
    func actionValueChanged(_ action: PanActionType?, scrollValue: CGFloat, topCalc: CGFloat) {
        let previewVC = movieBoxes?.first.vc
        previewVC?.updateScroll(scrValue: scrollValue, topValue: topCalc, action: action)
        vibrate()
    }
    
    
}
