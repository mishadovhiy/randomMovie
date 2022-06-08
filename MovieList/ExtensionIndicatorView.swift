//
//  ExtensionIndicatorView.swift
//  Budget Tracker
//
//  Created by Mikhailo Dovhyi on 30.03.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit

extension AlertViewLibraryy {
    public func showAlertWithOK(title:String? = nil,text:String? = nil, error: Bool, okTitle:String = "OK", hidePressed:((Bool)->())? = nil) {
        let alertTitle = title ?? (error ? self.text.error : self.text.success)
        let okButton:button = .init(title: okTitle, style: error ? .error : .link, close: true, action: hidePressed)
        DispatchQueue.main.async {
            self.showAlert(buttons: (okButton, nil), title: alertTitle, description: text, type: error ? .error : .standard)
        }
    }
    
    public func prebuild_closeButton(title:String? = nil, style:ButtonType = .regular) -> button {
        let titleText = title ?? self.text.done
        return .init(title: titleText, style: style, close: true) { _ in }
    }
    
}

extension AlertViewLibraryy {

    public enum ViewType {
        /**
         - higligting background
         */
        case error
        /**
         - higligting background
         */
        case internetError
        case succsess
        case standard
        /**
         - error type without higlight
         */
        case standardError
        case ai
    }
    
    
    
    public struct button {
        let title: String
        var style: ButtonType
        var close: Bool = true
        let action: ((Bool) -> ())?
        public init(title:String, style: ButtonType, close: Bool = true, action: ((Bool) -> ())?) {
            self.title = title
            self.style = style
            self.close = close
            self.action = action
        }
    }
    public enum ButtonType {
        case error
        case regular
        case link
    }
}
