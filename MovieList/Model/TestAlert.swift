//
//  TestAlert.swift
//  MovieList
//
//  Created by Misha Dovhiy on 25.12.2023.
//

import UIKit
import AlertViewLibrary

struct TestAlert {
    private var alert:AlertManager {
        AppModel.Appearence.alert
    }
    func load() {
        test2Perform()
    }
    
}

fileprivate extension TestAlert {
    func test3Perform() {
        alert.showAlert(title: nil, appearence: .type(.error))
        alert.showAlert(title: nil, appearence: .type(.error))
    }
    func test2Perform() {
        alert.showLoading(description: "Your loading description")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.alert.showAlert(title: "Your title", description: "Your Description", appearence: .with({
                $0.primaryButton = .with({
                    $0.title = "Some title"
                    $0.close = false
                    $0.action = self.test2Perform
                })
            }))
        })
    }
    
    func testAI(canMany:Bool = true) {
        let ai = AppModel.Appearence.alert

        ai.showLoading(description: "Your") {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                ai.showAlert(title: canMany ? nil : "some erfewd egrfwd tegrf wer svdcsd rwe", appearence: .with({
                    if canMany {
                        $0.primaryButton = .with({
                            $0.title = "many alerts"
                            $0.action = {
                                for i in 0..<5{
                                    self.testRegulare()
                                }
                            }
                        })
                    } else {
                        $0.primaryButton = .with({
                            $0.style = .link
                            $0.title = "loading test"
                            $0.action = self.loadingTest
                        })
                    }
                    $0.secondaryButton = .with({
                        $0.style = .error
                        $0.close = false
                        $0.action = {
                            self.testAI(canMany: false)
                        }
                        $0.title = "fuck you"
                    })
                    $0.type = canMany ? .internetError : .standard
                }))
            })
            
        }
    }
    
    private func loadingTest() {
        let ai = AppModel.Appearence.alert
        ai.showLoading(title: "some title", completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                ai.showAlert(title: "areer", appearence: .with({
                    $0.image = .image(.add)
                }))
            })
        })
        
    }
    
    private func testRegulare() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            let ai = AppModel.Appearence.alert

        })
    }
}
