//
//  AlertDefaultText.swift
//  AlertView
//
//  Created by Misha Dovhiy on 06.06.2022.
//

import Foundation

struct AlertDefaultText {
    let loading = "Loading"
    let done = "Done"
    let internetError = (title:"Internet error", description:"Try again later")
    let error = "Error"
    let okButton = "OK"
    let success = "Success"
}

extension AlertViewLibraryy {
    public enum Image:String {
        case error = "warning"
        case succsess = "success"
        case message = "vxc"
    }
}
