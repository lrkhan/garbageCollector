//
//  CloudKitUtility.swift
//  CloudKit Utility Functions
//
//  Created by Luthfor Khan on 5/15/22.
//

import CloudKit
import Foundation
import SwiftUI

protocol CloudKitableProtocol {
    init?(record: CKRecord)

    var record: CKRecord { get }
}

class CloudKitUtility {
    static let NotificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

    // Change the name to correct Container
    static let containterName: String = "iCloud.com.github.lrkhan.CloudKitEx"

    static let recordNamePrivate: String = "Personal"
    static let recordNamePublic: String = "Contact"

    enum Location {
        case publicDir, privateDir
    }

    enum CloudKitError: String, LocalizedError {
        case couldNotDetermine
        case available
        case restricted
        case noAccount
        case temporarilyUnavailable
        case unknown
        case iCloudPermissionError
        case failedToFetchUserID
        case failedToDiscoverUser
    }
}

// CK - User/iCloud Conectivity Check
extension CloudKitUtility {
    // Status of User's iCliud Account
    static func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        CKContainer(identifier: CloudKitUtility.containterName).accountStatus { returnedStatus, _ in
            switch returnedStatus {
            case .couldNotDetermine:
                completion(.failure(CloudKitError.couldNotDetermine))
            case .available:
                completion(.success(true))
            case .restricted:
                completion(.failure(CloudKitError.restricted))
            case .noAccount:
                completion(.failure(CloudKitError.noAccount))
            case .temporarilyUnavailable:
                completion(.failure(CloudKitError.temporarilyUnavailable))
            @unknown default:
                completion(.failure(CloudKitError.unknown))
            }
        }
    }

    static func requestApplicationPersmission(completion: @escaping (Result<Bool, Error>) -> Void) {
        CKContainer(identifier: CloudKitUtility.containterName)
            .requestApplicationPermission([.userDiscoverability]) {returnedStatus, returnedError in
            if returnedStatus == .granted {
                completion(.success(true))
            } else {
                completion(.failure(returnedError!))
            }
        }
    }

    static private func fetchiCloudUserRecordID(completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        CKContainer(identifier: CloudKitUtility.containterName)
            .fetchUserRecordID {returnedID, _ in
            if let id = returnedID {
                completion(.success(id))
            } else {
                completion(.failure(CloudKitError.failedToFetchUserID))
            }
        }
    }

    static private func discoveriCloudUser(id: CKRecord.ID, completion: @escaping (Result<String, Error>) -> Void) {
        CKContainer(identifier: CloudKitUtility.containterName)
            .discoverUserIdentity(withUserRecordID: id) {returnedId, _ in
            if let name = returnedId?.nameComponents?.givenName {
                completion(.success(name))
            } else {
                completion(.failure(CloudKitError.failedToDiscoverUser))
            }
        }
    }

    static func discoverUserID(completion: @escaping (Result<String, Error>) -> Void) {
        fetchiCloudUserRecordID { result in
            switch result {
            case .success(let recordID):
                CloudKitUtility.discoveriCloudUser(id: recordID, completion: completion)
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}

// CK - CRUD Functions
extension CloudKitUtility {
    static func fetch<T: CloudKitableProtocol>(predicate: NSPredicate,
                                               recordType: CKRecord.RecordType,
                                               sortDescriptors: [NSSortDescriptor]? = nil,
                                               resultLimit: Int? = nil,
                                               from: Location,
                                               completion: @escaping (_ items: [T]) -> Void) {

        // create operation
        let operation = createOperation(predicate: predicate,
                                        recordType: recordType,
                                        sortDescriptors: sortDescriptors,
                                        resultLimit: resultLimit)

        // get items in the query
        var returnedItems = [T]()
        addRecordMatchedBlock(operation: operation) { item in
            returnedItems.append(item)
        }

        // query completion
        addQueryResultBlock(operation: operation) { _ in
            completion(returnedItems)
        }

        // execute operation
        addOpperation(operation: operation, toLoc: from)
    }

    static private func createOperation(predicate: NSPredicate,
                                        recordType: CKRecord.RecordType,
                                        sortDescriptors: [NSSortDescriptor]? = nil,
                                        resultLimit: Int? = nil) -> CKQueryOperation {

        let query = CKQuery(recordType: recordType, predicate: predicate)

        if let descriptors = sortDescriptors {
            query.sortDescriptors = descriptors
        }

        let queryOp = CKQueryOperation(query: query)
        // can limit the number of items returned from query

        if let limit = resultLimit {
            queryOp.resultsLimit = limit
        }

        return queryOp
    }

    static private func addRecordMatchedBlock<T: CloudKitableProtocol>(operation: CKQueryOperation,
                                                                       completion: @escaping (_ item: T) -> Void) {
        operation.recordMatchedBlock = { ( _, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let item = T(record: record) else {return}
                completion(item)
            case .failure:
                break
            }
        }
    }

    static private func addQueryResultBlock(operation: CKQueryOperation,
                                            completion: @escaping (_ finished: Bool) -> Void) {
        operation.queryResultBlock = { _ in
            completion(true)
        }
    }

    static private func addOpperation(operation: CKDatabaseOperation, toLoc: Location) {
        switch toLoc {
        case .publicDir:
            CKContainer(identifier: CloudKitUtility.containterName).publicCloudDatabase.add(operation)
        case .privateDir:
            CKContainer(identifier: CloudKitUtility.containterName).privateCloudDatabase.add(operation)
        }
    }

    static func addOrUpdate<T: CloudKitableProtocol>(item: T,
                                                     from: Location,
                                                     completion: @escaping (Result<Bool, Error>) -> Void) {
        // save to CloudKit
        saveItem(record: item.record, toLoc: from, completion: completion)
    }

    static func saveItem(record: CKRecord, toLoc: Location, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch toLoc {
        case .publicDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .publicCloudDatabase.save(record) { _, returnedError in

                if let returnedError = returnedError {
                    completion(.failure(returnedError))
                } else {
                    completion(.success(true))
                }
            }
        case .privateDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .privateCloudDatabase.save(record) { _, returnedError in

                if let returnedError = returnedError {
                    completion(.failure(returnedError))
                } else {
                    completion(.success(true))
                }
            }
        }
    }

    static func delete<T: CloudKitableProtocol>(item: T,
                                                from: Location,
                                                completion: @escaping (Result<Bool, Error>) -> Void) {
        CloudKitUtility.delete(record: item.record, from: from, completion: completion)
    }

    static private func delete(record: CKRecord, from: Location, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch from {
        case .publicDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .publicCloudDatabase
                .delete(withRecordID: record.recordID) { _, returnedError in
                if let returnedError = returnedError {
                    completion(.failure(returnedError))
                } else {
                    completion(.success(true))
                }
            }
        case .privateDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .privateCloudDatabase
                .delete(withRecordID: record.recordID) { _, returnedError in
                if let returnedError = returnedError {
                    completion(.failure(returnedError))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
}

// CK - Notifications
extension CloudKitUtility {

    static func requestNotificationPersmission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: CloudKitUtility.NotificationOptions) { succes, error in
            if let error = error {
                print(error)
            } else if succes {
                print("Successful")

                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Failure")
            }
        }
    }

    func subscribeTo(_ type: String, for optionType: CKQuerySubscription.Options, from: Location) {
        var subID = "\(type)"

        switch optionType {
        case .firesOnRecordCreation:
            subID += "New"
        case .firesOnRecordDeletion:
            subID += "Deletetion"
        case .firesOnRecordUpdate:
            subID += "Updates"
        default:
            subID += "Other"
        }

        let predicate = NSPredicate(value: true)
        let sub = CKQuerySubscription(recordType: type,
                                      predicate: predicate,
                                      subscriptionID: subID,
                                      options: optionType)

        let not = CKSubscription.NotificationInfo()

        not.title = "There is a new \(type)"
        not.alertBody = "Click me to check it out!"
        not.soundName = "default"

        sub.notificationInfo = not

        switch from {
        case .publicDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .publicCloudDatabase.save(sub) { _, returnedErr in

                if let returnedErr = returnedErr {
                    print(returnedErr)
                } else {
                    print("The user subscribed to \(subID)")
                }
            }
        case .privateDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .privateCloudDatabase.save(sub) { _, returnedErr in

                if let returnedErr = returnedErr {
                    print(returnedErr)
                } else {
                    print("The user subscribed to \(subID)")
                }
            }
        }
    }

    func unsubscribeFrom(_ type: String, for optionType: CKQuerySubscription.Options, from: Location) {

        var subID = "\(type)"

        switch optionType {
        case .firesOnRecordCreation:
            subID += "New"
        case .firesOnRecordDeletion:
            subID += "Deletetion"
        case .firesOnRecordUpdate:
            subID += "Updates"
        default:
            subID += "Other"
        }

        // check the subscriptions the user has
//        CKContainer(identifier: CloudKitUtility.containterName).publicCloudDatabase.fetchAllSubscriptions
        switch from {
        case .publicDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .publicCloudDatabase.delete(withSubscriptionID: subID) { _, returnedErr in
                if let returnedErr = returnedErr {
                    print(returnedErr)
                } else {
                    print("The user was unsubscribed from \(subID)")
                }
            }
        case .privateDir:
            CKContainer(identifier: CloudKitUtility.containterName)
                .privateCloudDatabase.delete(withSubscriptionID: subID) { _, returnedErr in
                if let returnedErr = returnedErr {
                    print(returnedErr)
                } else {
                    print("The user was unsubscribed from \(subID)")
                }
            }
        }
    }
}
