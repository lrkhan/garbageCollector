//
//  CloudStatusModel.swift
//  CK_MultiTest
//
//  Created by Luthfor Khan on 5/18/22.
//

import CloudKit
import Foundation

struct Contact: Hashable, CloudKitableProtocol, Codable {
    enum RecordFields: String {
        case id, firstName, lastName, profilePic, domains, role, socailKey, socialVal, fact, interest
    }

    enum CodingKeys: CodingKey {
        case id, firstName, lastName, profilePic, domains, role, socailKey, socialVal, fact, interest
    }

    var record: CKRecord

    // Apple SignIn ID
    let id: String

    let firstName: String
    let lastName: String
    let profilePic: URL?

    let domains: [String]
    let role: String

    let socialKey: [String]
    let socialVal: [String]

    let fact: String
    let interest: String

    init?(id: String,
          firstName: String,
          lastName: String,
          profilePic: URL?,
          domains: [String],
          role: String,
          socialKey: [String],
          socialVal: [String],
          fact: String,
          interest: String) {
        let record = CKRecord(recordType: CloudKitUtility.recordNamePublic)

        record[RecordFields.id.rawValue] = id
        record[RecordFields.firstName.rawValue] = firstName
        record[RecordFields.lastName.rawValue] = lastName

        if let imgUrl = profilePic {
            record[RecordFields.profilePic.rawValue] = CKAsset(fileURL: imgUrl)
        }

        record[RecordFields.domains.rawValue] = domains
        record[RecordFields.role.rawValue] = role

        record[RecordFields.socailKey.rawValue] = socialKey
        record[RecordFields.socialVal.rawValue] = socialVal

        record[RecordFields.fact.rawValue] = fact
        record[RecordFields.interest.rawValue] = interest

        self.init(record: record)
    }

    init?(record: CKRecord) {
        guard let id = record[RecordFields.id.rawValue] as? String else {return nil}
        guard let fName = record[RecordFields.firstName.rawValue] as? String else {return nil}
        guard let lName = record[RecordFields.lastName.rawValue] as? String else {return nil}
        guard let img = record[RecordFields.profilePic.rawValue] as? CKAsset else {return nil}
        guard let domains = record[RecordFields.domains.rawValue] as? [String] else {return nil}
        guard let role = record[RecordFields.role.rawValue] as? String else {return nil}
        guard let key = record[RecordFields.socailKey.rawValue] as? [String] else {return nil}
        guard let val = record[RecordFields.socialVal.rawValue] as? [String] else {return nil}
        guard let fact = record[RecordFields.fact.rawValue] as? String else {return nil}
        guard let interst = record[RecordFields.interest.rawValue] as? String else {return nil}

        self.record = record
        self.id = id
        self.firstName = fName
        self.lastName = lName
        self.profilePic = img.fileURL
        self.domains = domains
        self.role = role
        self.socialKey = key
        self.socialVal = val
        self.fact = fact
        self.interest = interst
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(String.self, forKey: .id)

        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)

        let pic = try container.decode(URL?.self, forKey: .profilePic)

        let domains = try container.decode([String].self, forKey: .domains)
        let role = try container.decode(String.self, forKey: .role)

        let socialKey = try container.decode([String].self, forKey: .socailKey)
        let socialVal = try container.decode([String].self, forKey: .socialVal)

        let fact = try container.decode(String.self, forKey: .fact)
        let interest = try container.decode(String.self, forKey: .interest)

        self.init(id: id,
                      firstName: firstName,
                      lastName: lastName,
                      profilePic: pic,
                      domains: domains,
                      role: role,
                      socialKey: socialKey,
                      socialVal: socialVal,
                      fact: fact,
                  interest: interest)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)

        try container.encode(profilePic, forKey: .profilePic)
        try container.encode(domains, forKey: .domains)
        try container.encode(role, forKey: .role)
        try container.encode(socialKey, forKey: .socailKey)

        try container.encode(socialVal, forKey: .socialVal)
        try container.encode(fact, forKey: .interest)
    }
}

struct PersonalInfo: CloudKitableProtocol, Codable {
    var record: CKRecord

    enum CodingKeys: CodingKey {
        case myContactInfo, myList
    }

    var myContactInfo: Contact

    var myList: [Contact]

    init?(userInfo: Contact, list: [Contact]) {
        let rec = CKRecord(recordType: CloudKitUtility.recordNamePrivate)

        var ref: [CKRecord.Reference]

        for rec in list {
            ref.append(CKRecord.Reference(record: rec.record, action: .none))
        }
        rec[CodingKeys.myContactInfo.stringValue] = CKRecord.Reference(record: userInfo.record, action: .deleteSelf)
        rec[CodingKeys.myList.stringValue] = ref

        self.init(record: rec)
    }

    init?(record: CKRecord) {
       // code
    }

//    init() {
//        // get info from private
//        // load local copy
//
//        // update changes (private, local, public)
//        //      High -> Low precedence
//    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.myContactInfo = try container.decode(Contact.self, forKey: .myContactInfo)

        self.myList = try container.decode([Contact].self, forKey: .myList)

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(myContactInfo, forKey: .myContactInfo)
        try container.encode(myList, forKey: .myList)
    }
}

class CurrentUser: ObservableObject {
    @Published var personalInfo: Contact

    @Published var favList = [Contact]()

    init() {

    }

}

class CloudStatus: ObservableObject, Codable {
    @Published var iCloudSignedIn: Bool = false
    @Published var iCloudPermission: Bool = false
    @Published var iCloudName: String?

    @Published var appleSignedIn: Bool = false
    @Published var appleUserID: String?
    @Published var appleUserEmail: String?
    @Published var appleUserName: [String?]?

    init() {
        self.load()

        if !self.iCloudSignedIn && !self.appleSignedIn {
            // Get iCloud Status
            CloudKitUtility.getiCloudStatus {[weak self] result in
                switch result {
                case .success(let val):
                    DispatchQueue.main.async {
                        self?.iCloudSignedIn = val
                    }
                case .failure(let err):
                    print(err)
                }
            }

            // Request Permission
            CloudKitUtility.requestApplicationPersmission {[weak self] result in
                switch result {
                case .success(let val):
                    DispatchQueue.main.async {
                        self?.iCloudPermission = val
                    }
                case .failure(let err):
                    print(err)
                }
            }

            // iCloud user ID
            CloudKitUtility.discoverUserID {[weak self] result in
                switch result {
                case .success(let id):
                    DispatchQueue.main.async {
                        self?.iCloudName = id
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }

        self.save()
    }

    enum CodingKeys: CodingKey {
        case iCloudSignedIn, iCloudPermission, iCloudName
        case appleSignedIn, appleUserID, appleUserEmail, appleUserName
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(iCloudSignedIn, forKey: .iCloudSignedIn)
        try container.encode(iCloudPermission, forKey: .iCloudPermission)
        try container.encode(iCloudName, forKey: .iCloudName)

        try container.encode(appleSignedIn, forKey: .appleSignedIn)
        try container.encode(appleUserID, forKey: .appleUserID)
        try container.encode(appleUserEmail, forKey: .appleUserEmail)
        try container.encode(appleUserName, forKey: .appleUserName)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.iCloudSignedIn = try container.decode(Bool.self, forKey: .iCloudSignedIn)
        self.iCloudPermission = try container.decode(Bool.self, forKey: .iCloudPermission)
        self.iCloudName = try container.decode(String.self, forKey: .iCloudName)

        self.appleSignedIn = try container.decode(Bool.self, forKey: .appleSignedIn)
        self.appleUserID = try container.decode(String.self, forKey: .appleUserID)
        self.appleUserEmail = try container.decode(String.self, forKey: .appleUserEmail)
        self.appleUserName = try container.decode([String].self, forKey: .appleUserName)
    }

    func save() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("userCloudStatus.json")

            try JSONEncoder()
                .encode(self)
                .write(to: fileURL)

            print("Writing complete")

            return
        } catch {
            print("error writing user data")

            return
        }
    }

    private func load() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("userCloudStatus.json")

            let data = try Data(contentsOf: fileURL)
            let loadStatus = try JSONDecoder().decode(CloudStatus.self, from: data)

            print("Loaded User Successfully")

            self.iCloudSignedIn = loadStatus.iCloudSignedIn
            self.iCloudPermission = loadStatus.iCloudPermission
            self.iCloudName = loadStatus.iCloudName

            self.appleSignedIn = loadStatus.appleSignedIn
            self.appleUserID = loadStatus.appleUserID
            self.appleUserEmail = loadStatus.appleUserEmail
            self.appleUserName = loadStatus.appleUserName
        } catch {
            print("error reading user data")
        }
    }
}
