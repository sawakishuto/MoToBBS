//
//  AuthRepository.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class AuthRepository: AuthRepositoryProtocol {
    func deleteAccount(uid: String) -> AnyPublisher<Bool, Error> {
        return Deferred {
            Future { promise in
                guard let user = self.auth.currentUser else {return}
                user.delete { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(true))
                    }

                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(mailAdress: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Deferred {
            Future { promise in
                self.auth.createUser(withEmail: mailAdress, password: password) { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let result = result {
                        promise(.success(result))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func login(mailAdress: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Deferred {
            Future { promise in
                self.auth.signIn(withEmail: mailAdress, password: password) { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let result = result {
                        promise(.success(result))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func resetPassword(mailAdress: String) {
        auth.sendPasswordReset(withEmail: mailAdress) { error in
            if let error = error {
                print(error)
            } else {
                print("success!")
            }
        }

    }
    
    let auth = Auth.auth()


}
