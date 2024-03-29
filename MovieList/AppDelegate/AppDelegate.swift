//
//  AppDelegate.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit
import CoreData
import AlertViewLibrary

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared:AppDelegate? {
        if !Thread.isMainThread {
            print("faterror")
        }
        return UIApplication.shared.delegate as? AppDelegate
    }
    lazy var banner: adBannerView = {
        return adBannerView.instanceFromNib() as! adBannerView
    }()
    
    lazy var appearence:AppModel.Appearence? = {
        return AppModel.Appearence()
    }()
    
    lazy var ai:AlertManager = {
        let blue = UIColor.init(red: 205/255, green: 253/255, blue: 255/255, alpha: 1)
        let orange = UIColor(red: 218/255, green: 203/255, blue: 165/255, alpha: 1)
        
        return AlertManager.init(appearence:.with({
            $0.images = .with({
                $0.alertError = nil
                $0.alertSuccess = nil
            })
            $0.animations = .with({
                $0.setBackground = 0.8
                $0.alertShow = 0.5
                $0.performHide1 = 0.5
                $0.performHide2 = 0.3
                $0.loadingShow1 = 0.4
                $0.loadingShow2 = 0.5
            })
            $0.colors = .with({
                $0.buttom = .with({
                    $0.link = .black
                    $0.normal = .gray
                })
                $0.alertState = .with({
                    $0.view = blue
                    $0.background = .black.withAlphaComponent(0.5)
                })
                $0.activityState = .with({
                    $0.view = orange.withAlphaComponent(0.8)
                    $0.background = .black.withAlphaComponent(0.1)
                })
                $0.texts = .with({
                    $0.title = .black
                    $0.description = .black.withAlphaComponent(0.5)
                })
            })
        }))
    }()
    
    lazy var ai1:AlertManager = {
        let orange = UIColor.init(red: 181/255, green: 107/255, blue: 68/255, alpha: 1)
        let blue = UIColor.init(red: 75/255, green: 201/255, blue: 206/255, alpha: 1)
        return .init(appearence:.with({
            $0.animations = .with({
                $0.setBackground = 0.7
                $0.alertShow = 0.5
                $0.performHide2 = 0.3
            })
            $0.colors = .with({
                $0.separetor = .link
                $0.buttom = .with({
                    $0.normal = .red
                    $0.link = .blue
                })
                $0.texts = .with({
                    $0.title = .black
                    $0.description = .white
                })
                $0.alertState = .with({
                    $0.view = blue
                    $0.background = .red.withAlphaComponent(0.4)
                })
                $0.activityState = .with({
                    $0.view = .systemPink
                    $0.background = blue.withAlphaComponent(0.1)
                })
            })
        }))
    }()
    var db:CoreDataDBManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        db = .init(persistentContainer: persistentContainer, appDelegate: self)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            LocalDB.dbHolder = .init(dict: self.db?.fetch(.general)?.db?.toDict ?? [:])
        }
        self.banner.createBanner()
        return true
    }

    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LocalDataBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 */
            //    fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
               // fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

