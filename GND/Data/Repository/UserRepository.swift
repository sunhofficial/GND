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
}
//여기서 DTO처리를 해주는듯
class UserRepository: UserRepositoryProtocol {
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
