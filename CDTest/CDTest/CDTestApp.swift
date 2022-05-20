//
//  CDTestApp.swift
//  CDTest
//
//  Created by Luthfor Khan on 5/17/22.
//

import SwiftUI

@main
struct CDTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
