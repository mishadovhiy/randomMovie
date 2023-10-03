//
//  ContainerPanGesture.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

protocol ContainerPanGestureProtocol {
    func updateWhileScrolling(_ action:PanActionType?, _ scrollValue:CGFloat, topCalc:CGFloat)
    func panEndAction(_ action:PanActionType?)
    func actionValueChanged(_ action:PanActionType?, scrollValue: CGFloat, topCalc:CGFloat)
}
enum PanActionType:Int {
    case dislike = 0
    case like = 1
    case bet = 2
    case superLike = 3
}

class ContainerPanGesture {
    
    let delegate:ContainerPanGestureProtocol
    let vc:UIViewController
    var defaultCenter:CGPoint?
    private var result:PanActionType? = nil
    
    init(vc:UIViewController, delegate:ContainerPanGestureProtocol) {
        self.delegate = delegate
        self.vc = vc
    }
    func update(_ sender:UIPanGestureRecognizer) {
        
        guard let view = sender.view else { return }
        let touch = sender.translation(in: vc.view)
        let new:CGPoint = .init(x: view.center.x + touch.x, y: view.center.y + touch.y)
        view.center = new
        sender.setTranslation(.zero, in: vc.view)
        let isInCenter = view.center.x - vc.view.center.x
        let resultCalc = abs(isInCenter) / vc.view.center.x
        
        let scrollTop = view.center.y - vc.view.center.y
        

        let card = view as? SwipeMovieVC.MoviePreviewView
        let topCalc = abs(scrollTop) / vc.view.center.y
        
        var result = valuesToAction(resultCalc: resultCalc, topCalc: topCalc, isInCenter: isInCenter)
        let scrVal = (result ?? .dislike) == .bet ? topCalc : resultCalc
        delegate.updateWhileScrolling(result ?? (isInCenter > 0 ? .like : .dislike), scrVal, topCalc: topCalc)
        
        if result != self.result {
            self.result = result
            self.delegate.actionValueChanged(result, scrollValue: scrVal, topCalc: topCalc)
        }
        switch sender.state {
        case .failed, .cancelled:
            card?.touchesEnded()
            delegate.panEndAction(.none)
        case .ended:
            card?.touchesEnded()
            let ended = valuesToAction(resultCalc: resultCalc, topCalc: topCalc, isInCenter: isInCenter, ended: true)
            if ended != nil {
                self.result = nil
            }
            delegate.panEndAction(ended)
        default:
            break
        }
    }

    func valuesToAction(resultCalc:CGFloat, topCalc:CGFloat, isInCenter:CGFloat, ended:Bool = false) -> PanActionType? {
        if topCalc >= 0.6 {
            return .bet
        } else if resultCalc > 0.55 {
            return isInCenter > 0 ? .like : .dislike
        } else {
            return nil
        }
        /*if resultCalc > 0.55 {
            return isInCenter > 0 ? .like : .dislike
        } else {
            if resultCalc <= 0.3 && topCalc >= 0.6 {
                return .bet
            } else {
                return nil
            }
        }*/
    }
    
    private func vibrate() {
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
}
