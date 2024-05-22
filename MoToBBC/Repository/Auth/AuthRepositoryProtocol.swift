//
//  LoginRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/21.
//

import Foundation
import FirebaseAuth

protocol AuthRepositoryProtocol {
    func login(mailAdress: String, password: String, completion: @escaping () -> Void)

    func signUp(mailAdress: String, password: String, completion: @escaping () -> Void)

    func resetPassword(mailAdress: String)

    func deleteAccount(uid: String)

}
