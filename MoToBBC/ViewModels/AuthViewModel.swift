//
//  AuthViewModel.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/23.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseAuth

final class AuthViewModel: ObservableObject {
    private var authRepository: AuthRepositoryProtocol!

    init(authRepository: AuthRepositoryProtocol!) {
        self.authRepository = authRepository
    }

    func login(mailAdress: String, password: String) {
        authRepository.login(mailAdress: mailAdress, password: password)
            .receive(on: DispatchQueue.main)
            .sink { response in
                switch response {
                case.finished:
                    return
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { authData in
                // とりあえずBool返して
                print(authData)
            }
    }
}
