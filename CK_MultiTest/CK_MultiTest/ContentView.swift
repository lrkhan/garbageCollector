//
//  ContentView.swift
//  CK_MultiTest
//
//  Created by Luthfor Khan on 5/18/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var cloudStat: CloudStatus

    var body: some View {
        NavigationView {
            VStack {
                if !cloudStat.appleSignedIn {
                    AppleIDView()
                }

                Text("Hello, world!")
                    .padding()

                Text("sign: \(cloudStat.iCloudSignedIn.description)")
                    .padding()
                Text("permission: \(cloudStat.iCloudPermission.description)")
                    .padding()
                Text("apple: \(cloudStat.appleSignedIn.description)")
                    .padding()
            }
            .navigationTitle("Welcome \(cloudStat.iCloudName ?? "")")
        }
    }
}
