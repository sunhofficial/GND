//
//  LoginRepository.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Alamofire
import Combine
protocol UserRepositoryProtocol {
    func postLogin(_ login: Login) -> AnyPublisher<User, Error>
    func postUserData(_ info: UserInfo) -> AnyPublisher<UserInfo, Error>
}
//여기서 DTO처리를 해주는듯
class UserRepository: UserRepositoryProtocol {
    func postUserData(_ info: UserInfo) -> AnyPublisher<UserInfo, any Error> {
        return Future<UserInfo, Error> {promise in
            AF.request(UserAPI.requestSetuser(UserInfoDTO(gender: info.gender, age: info.age, nickname: info.nickname)))
                .response { response in
                      debugPrint(response)
                  }
                .responseDecodable(of: UserInfoDTO.self) { response in
                    if let data = response.value {
                        promise(.success(data.toDomain()))
                    }
                    else if let error = response.error  {
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func postLogin(_ login: Login) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            AF.request(UserAPI.requestlogin(LoginRequest(type: login.type, id: login.id)))
                .response { response in
                      debugPrint(response)
                  }
                .responseDecodable(of: LoginResponse.self) { response in
                    print(response)
                    if let data = response.value {
                        KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                        KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
                        promise(.success(data.toDomain()))
                    } else if let error = response.error{
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

}
