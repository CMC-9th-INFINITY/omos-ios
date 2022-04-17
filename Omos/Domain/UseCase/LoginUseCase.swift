//
//  LoginUseCase.swift
//  Omos
//
//  Created by sangheon on 2022/02/17.
//

import Foundation
import RxSwift

class LoginUseCase {
    private let AuthRepository: AuthRepository

    func signIn(email: String, password: String) -> Single<LoginResponse> {
        AuthRepository.signIn(email, password)
    }

    func signUp(email: String, password: String, nickname: String) -> Single<SignUpRespone> {
       AuthRepository.localSignUp(email, password, nickname)
    }

    func checkEmail(email: String) -> Single<CheckEmailRespone> {
        AuthRepository.checkEmail(email: email)
    }

    func snsLogin(email: String, type: SNSType) -> Single<SNSLoginResponse> {
        AuthRepository.snsLogin(email: email, type: type)
    }

    func snsSignUp(email: String, nickName: String, type: SNSType) -> Single<SNSSignUpResponse> {
        AuthRepository.snsSignUp(email: email, nickName: nickName, type: type)
    }

    func emailVerify(email: String) -> Single<EmailCheckResponse> {
        AuthRepository.emailVerify(email: email)
    }

    init(authRepository: AuthRepository) {
        self.AuthRepository = authRepository
    }
}
