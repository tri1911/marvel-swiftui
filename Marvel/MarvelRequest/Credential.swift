//
//  Credential.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import Foundation
import CryptoKit

struct Credential {
    static let publicKey = "fbadab227100b57a48da8c14f04b73c7"
    static let privateKey = "6d82d31ad69b4daae6cd68cef4d28eec72f152b4"
    
    static var info: String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = "\(ts)\(Credential.privateKey)\(Credential.publicKey)".md5
        return "ts=\(ts)&apikey=\(Credential.publicKey)&hash=\(hash)"
    }
}

// MARK: - Extension(s)

extension String {
    var md5: String {
        // Returned output will be: "MD5 digest: 5ceb6a71b915b6be4427e8bb8bd49700"
        let output = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())
        return output.map { String(format: "%02hhx", $0 )}.joined()
    }
}
