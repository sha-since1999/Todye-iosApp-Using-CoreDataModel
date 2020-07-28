//
//  AppDelegate.swift
//  Todo List
//
//  Created by Rohit sahu on 27/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import CoreData
import  RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
     // to print the path of ream file
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
        do{
              _ = try Realm()
        }catch{
            print("for initialisig Realm\(error)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

   
    
}
