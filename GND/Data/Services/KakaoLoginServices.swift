//
//  KakaoLoginServices.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Combine
import KakaoSDKAuth
import AuthenticationServices
import KakaoSDKUser
class KakaoLoginServices {
    func publishloginWithKakao() -> Future<String, Error> {
        return Future {promise in
            UserApi.shared.loginWithKakaoTalk { oauthToken, err in
                if let error = err {
                    promise(.failure(error))
                } else if let oauthToken = oauthToken, let id = oauthToken.idToken {
                    promise(.success(id))
                }
            }
        }
    }
    func publishMe() -> Future<String, Error> {
        return Future { promise in
            UserApi.shared.me { user, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = user?.id {
                    promise(.success(String(user)))
                }
            }}
    }
}
