//
//  NickNameViewModel.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Foundation
import Combine
protocol NickNameViewModelInput {
    var nickname: CurrentValueSubject<String, Never> { get }
    func didTapCompleteButton()
}
protocol NickNameViewModelOutput{
    var isCompleteButtonEnabled: AnyPublisher<Bool, Never> { get }
}
protocol NickNameViewModelType: NickNameViewModelInput, NickNameViewModelOutput {
    var inputs: NickNameViewModelInput { get }
    var outputs: NickNameViewModelOutput {  get }
}
class NickNameViewModel: NickNameViewModelType {
    var nickname = CurrentValueSubject<String, Never>("")
    var isCompleteButtonEnabled: AnyPublisher<Bool, Never>
    var inputs: NickNameViewModelInput { return self }
    var outputs: NickNameViewModelOutput { return self }
    func didTapCompleteButton() {
        
    }
    
    init() {
        isCompleteButtonEnabled = nickname.map {
            !$0.isEmpty
        }.eraseToAnyPublisher()
    }
    

}
