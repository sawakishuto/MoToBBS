//
//  LoginRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/21.
//

import Foundation
import FirebaseAuth
import Combine

protocol AuthRepositoryProtocol {
    func login(mailAdress: String, password: String) -> AnyPublisher<AuthDataResult, Error>

    func signUp(mailAdress: String, password: String) -> AnyPublisher<AuthDataResult, Error>

    func resetPassword(mailAdress: String)

    func deleteAccount(uid: String) -> AnyPublisher<Bool, Error> 

}
