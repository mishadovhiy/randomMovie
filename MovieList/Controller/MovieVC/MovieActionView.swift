//
//  MovieActionView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 04.10.2023.
//

import UIKit

class MovieActionView: View {

    var imageView:UIImageView? {
        return self.subviews.first(where: {$0 is UIImageView}) as? UIImageView
    }
    
    static func createTo(container:SwipeMovieVC.MoviePreviewView, type:PanActionType) -> MovieActionView {
        let view:MovieActionView = .init()
        view.backgroundColor = .clear
        container.addSubview(view)
        view.addConstaits([.top:130, .height:60, .width:60], superV: container)
        switch type {
        case .dislike:
            view.addConstaits([.right:30], superV: container)
            view.tintColor = #colorLiteral(red: 0.2630000114, green: 0.2630000114, blue: 0.2630000114, alpha: 1)
        case .like:
            view.addConstaits([.left:-30], superV: container)
            view.tintColor = .red
        }
        
        let img = UIImageView()
        img.image = type == .like ? #imageLiteral(resourceName: "like.svg") : #imageLiteral(resourceName: "dislike.svg")
        view.addSubview(img)
        img.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: view)
        img.shadow(opasity: 0.8)
        view.pressed(percent: 0)
        return view
    }

    
    func pressed(percent:CGFloat) {
        self.alpha = percent
        self.layer.zoom(value: 1 + (percent / 5.5))
    }

}
