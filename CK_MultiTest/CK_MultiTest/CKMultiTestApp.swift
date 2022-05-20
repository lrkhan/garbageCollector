//
//  CK_MultiTestApp.swift
//  CK_MultiTest
//
//  Created by Luthfor Khan on 5/18/22.
//

import SwiftUI

@main
struct CKMultiTestApp: App {
    @StateObject private var cloudStats = CloudStatus()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cloudStats)
        }
    }
}
