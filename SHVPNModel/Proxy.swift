//
//  Proxy.swift
//  SHVPN
//
//  Created by LEI on 4/6/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public enum ProxyType: String {
    case Shadowsocks = "SS"
    case ShadowsocksR = "SSR"
    case Https = "HTTPS"
    case Socks5 = "SOCKS5"
    case None = "NONE"
}

extension ProxyType: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }

    public var isShadowsocks: Bool {
        return  self == .ShadowsocksR
    }
    
}

public enum ProxyError: Error {
    case invalidType
    case invalidName
    case invalidHost
    case invalidPort
    case invalidAuthScheme
    case nameAlreadyExists
    case invalidUri
    case invalidPassword
}

extension ProxyError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .invalidType:
            return "Invalid type"
        case .invalidName:
            return "Invalid name"
        case .invalidHost:
            return "Invalid host"
        case .invalidAuthScheme:
            return "Invalid encryption"
        case .invalidUri:
            return "Invalid uri"
        case .nameAlreadyExists:
            return "Name already exists"
        case .invalidPassword:
            return "Invalid password"
        case .invalidPort:
            return "Invalid port"
        }
    }
    
}

open class Proxy: NSObject {
    open dynamic var typeRaw = "SSR"
    open dynamic var name = ""
    open dynamic var host = ""
    open dynamic var port = 0
    //加密方式
    open dynamic var authscheme: String?  // method in SS
    open dynamic var user: String?
    open dynamic var password: String?
    open dynamic var ota: Bool = false
    open dynamic var ssrProtocol: String?
    open dynamic var ssrObfs: String?
    open dynamic var ssrObfsParam: String?

    open static let ssUriPrefix = "ss://"
    open static let ssrUriPrefix = "ssr://"

    open static let ssrSupportedProtocol = [
        "origin",
        "verify_simple",
        "auth_simple",
        "auth_sha1",
        "auth_sha1_v2"
    ]

    open static let ssrSupportedObfs = [
        "plain",
        "http_simple",
        "tls1.0_session_auth",
        "tls1.2_ticket_auth"
    ]

    open static let ssSupportedEncryption = [
        "table",
        "rc4",
        "rc4-md5",
        "aes-128-cfb",
        "aes-192-cfb",
        "aes-256-cfb",
        "bf-cfb",
        "camellia-128-cfb",
        "camellia-192-cfb",
        "camellia-256-cfb",
        "cast5-cfb",
        "des-cfb",
        "idea-cfb",
        "rc2-cfb",
        "seed-cfb",
        "salsa20",
        "chacha20",
        "chacha20-ietf"
    ]


}

