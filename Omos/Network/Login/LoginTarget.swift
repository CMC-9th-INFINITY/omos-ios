//
//  LoginTarget.swift
//  Omos
//
//  Created by sangheon on 2022/02/17.
//

import Alamofire

enum LoginTarget {
    case login(LoginRequest)
    case getUserDetails(UserDetailRequest)
    //case kakaoLogin()
    case checkEmail(CheckEmailRequest)
    case signUp(SignUpRequest)
    case doRefresh(RefreshRequest)
    case SNSLogin(SNSLoginRequest)
    case SNSSignUp(SNSSignUpRequest)
    case logOut(userId:Int)
}

extension LoginTarget:TargetType {
    var baseURL: String {
        return "http://ec2-3-37-146-80.ap-northeast-2.compute.amazonaws.com:8080/api/auth"
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getUserDetails: return .get
        case .signUp: return .post
        case .doRefresh: return .post
        case .checkEmail: return .post
        case .SNSLogin: return .post
        case .SNSSignUp: return .post
        case .logOut: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .getUserDetails: return "/details" //it could be changed
        case .signUp: return "/signup"
        case .doRefresh: return "/post"
        case .checkEmail: return "/check-email"
        case .SNSLogin: return "/sns-login"
        case .SNSSignUp: return "/sns-signup"
        case .logOut(let user): return "/logout/\(user)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .login(let request): return .body(request)
        case .getUserDetails(let request): return .body(request)
        case .signUp(let request): return .body(request)
        case .doRefresh(let request): return .body(request)
        case .checkEmail(let request): return .body(request)
        case .SNSLogin(let request): return .body(request)
        case .SNSSignUp(let request): return .body(request)
        default:
            return nil
        }
    }
    
    
}
