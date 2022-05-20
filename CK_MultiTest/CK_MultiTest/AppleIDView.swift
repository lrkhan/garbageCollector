//
//  AppleIDView.swift
//  TekIT
//
//  Created by Luthfor Khan on 2/11/22.
//

import AuthenticationServices
import SwiftUI

struct AppleIDView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cloudStat: CloudStatus

    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                cloudStat.appleSignedIn = true
                switch auth.credential {
                case let authCred as ASAuthorizationAppleIDCredential:
                    // User ID from apple
                    cloudStat.appleUserID =  authCred.user

                    // User Info
                    cloudStat.appleUserEmail = authCred.email

                    let firstName = authCred.fullName?.givenName
                    let lastName = authCred.fullName?.familyName

                    cloudStat.appleUserName = [firstName, lastName]

                default:
                    break
                }
            case . failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(height: 55)
        .padding()
    }
}
