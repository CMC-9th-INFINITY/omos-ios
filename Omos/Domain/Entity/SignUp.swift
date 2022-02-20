//
//  SignUp.swift
//  Omos
//
//  Created by sangheon on 2022/02/18.
//

import Foundation


struct SignUpRequest :Codable {
    let email:String
    let nickname:String
    let password:String
}

struct SignUpRespone:Codable {
    let state:Bool
}


struct CheckEmailRequest:Codable {
    let email:String
}

struct CheckEmailRespone:Codable {
    let state:Bool
}
