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
        .init(appearence:.with({
            $0.colors = .generate({
                $0.view = .red
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

