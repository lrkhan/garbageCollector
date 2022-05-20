//
//  CKTestApp.swift
//  CKTest
//
//  Created by Luthfor Khan on 5/17/22.
//

import SwiftUI

@main
struct CKTestApp: App {
    @StateObject private var dataController = DataController()
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
