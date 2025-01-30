//
//  Extensions_SwipeMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

extension SwipeMovieVC {
    private func performCreatingMovie(first:Bool = false) -> MoviePreviewView? {
        if !(randomList.count - 1 >= index) {
            return nil
        }
        let container = MoviePreviewView()
        container.customTouchAnimation = { begun in
            UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, animations: {
                container.layer.zoom(value: begun ? 1.01 : 1)
            })
        }
        container.shadow(opasity: Styles.buttonShadow)
        container.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1)
        container.layer.cornerRadius = Styles.buttonRadius3
       // container.layer.masksToBounds = true
        containerView.addSubview(container)
        container.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: containerView)
        
        container.center =
            .init(x: self.view.frame.width / 2, y: self.view.frame.height / 3)
        container.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
        
        let panGesture:UIPanGestureRecognizer = .init(target: self, action: #selector(containerPanned(_:)))
        container.gesture = panGesture
        container.addGestureRecognizer(panGesture)
        
        let vc = MovieVC.configure(isPreview: true, movie: randomList[index])
        addChild(vc)
        container.addSubview(vc.view)
        vc.view.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: container)
        container.vc = vc
        index += 1
        vc.didMove(toParent: self)
        print(index, " ytgrfewd")
        container.likeView = .createTo(container: container, type: .like)
        container.dislikeView = .createTo(container: container, type: .dislike)
        vc.container = container
        return container
    }

    
    func createMovie(first:Bool = false) -> MoviePreviewView? {
        if randomList.count - 1 >= index && randomList.count != 0 {
            return performCreatingMovie(first: first)
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
            self.fixView(cards: newCards, cardRemoved: removed, firstLoaded: firstLoad)
            
        } else {
            if apiError == nil {
                self.loadMovies()
            }
        }
    }
    
    /**
     - not animated method
     */
    func prepareFirstCard(to container: MoviePreviewView) {
        container.isUserInteractionEnabled = true
        container.layer.zPosition = 9999999
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
        cards.first.vc?.view.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1)
        cards.first.alpha = 1

        self.prepareAdditionalCard(cards.second, isSecond: true)
        self.prepareAdditionalCard(cards.third, isSecond: false)
        let previewVC = cards.first.vc
        previewVC?.updateScroll(scrValue: 0, topValue: 0, action: nil)
        if self.touched {
            self.containerView.alpha = 1
        }
    }
    
    func prepareAdditionalCard(_ container:MoviePreviewView?, isSecond:Bool) {
        container?.layer.zPosition = isSecond ? -1 : -2
        container?.isUserInteractionEnabled = false
        container?.subviews.last?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, isSecond ? transform.first : transform.second, 0)
        let transform:CGFloat = isSecond ? 0.9 : 0.8
        container?.layer.transform = CATransform3DMakeScale(transform, transform, 1)
        container?.alpha = transform + 0.5
        container?.vc?.view.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1).darker(0.015)

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
        previewVC?.updateScroll(scrValue: scrollValue, topValue: topCalc, action: action)
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
            cards.first.rotate(value: scrollValue / -5)
        case .like:
            cards.first.rotate(value: scrollValue / 5)
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
        if #available(iOS 13.0, *) {
            vibrate(style: .soft)
        }
    }
    
    func reloadPressed() {
        self.setAnimating(animating: true) {
            self.apiLoad()
        }
    }
    
    /// -
    
    func removeAllBoxes() {
        let all = [movieBoxes?.first, movieBoxes?.second, movieBoxes?.third]
        all.forEach({
            if let box = $0 {
                box.vc?.view.removeFromSuperview()
                box.vc?.removeFromParent()
                box.removeFromSuperview()
            }
        })
        movieBoxes = nil
        randomList = []
        allApi = []
    }
    
    private func randomMovies(page: Int) -> [Movie] {
        var newData:[Movie] = []
        for _ in 0..<(Int.random(in: 2...5)) {
            if let new = (allApi.first(where: {$0.page == page}))?.movie.randomElement() {
                newData.append(new)
                
            }
        }
        return newData
    }
    
    func setRandoms() -> Bool {
        print("setRandomssetRandomssetRandoms")
        randomList.removeAll()
        randomList = self.allApi.first?.movie ?? []
//        var data:[Int: [Movie]] = [:]
//        for _ in 0..<20 {
//            if let randomPage = allApi.randomElement()?.page {
//                var newMovies = self.randomMovies(page: randomPage)
//                
//                if let updating = data[randomPage] {
//                    updating.forEach({newMovies.append($0)})
//                }
//                data.updateValue(newMovies, forKey: randomPage)
//                
//            }
//        }
//        
//        var c = 0
//        let api = Array(allApi)
//        data.forEach({ list in
//            var new = api.first(where: {$0.page == list.key})?.movie ?? []
//            print(new.count, " gterfwds")
//            new.removeAll(where: { rem in
//                return list.value.contains(where: {$0.imdbid == rem.imdbid})
//            })
//            print(new.count, " gterfwdsafterrrr")
//            list.value.forEach({ _ in
//                c += 1
//            })
//            allApi.removeAll(where: {$0.page == list.key})
//            allApi.append(.init(movie: new, page: list.key))
//        })
//        data.forEach({ dict in
//            dict.value.forEach({
//                self.randomList.append($0)
//            })
//        })
//        
//        print(c, " brtgerfrvrgb")
        return !(randomList.count == 0)
    }
    
    
    func tempAppearence() {
        randomList.removeAll()
        for _ in 0..<20 {
            randomList.append(.init(dict: [:]))
        }
        loadMovies()
    }
}
