//
//  ProfileViewModel.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Foundation
import Combine
protocol ProfileViewModelInput {
    func selectGender(_ gender: Gender)
    func selectAgeRange(_ range: String)
    func sendProfile()
}
protocol ProfileViewModelOutput {
    var isFormValid: AnyPublisher<Bool, Never> {get}
}
protocol ProfileViewModelType: ProfileViewModelInput, ProfileViewModelOutput {

}
class ProfileViewModel: ProfileViewModelType{
    private let genderSubject = CurrentValueSubject<Gender, Never>(.none)
     private let ageRangeSubject = CurrentValueSubject<String?, Never>(nil)
    var isFormValid: AnyPublisher<Bool, Never> {
//        Publishers.CombineLatest(gender)
    }

    func selectGender(_ gender: Gender) {
        <#code#>
    }
    
    func selectAgeRange(_ range: String) {
        <#code#>
    }
    
    func sendProfile() {
        <#code#>
    }
    
    private var cancellables = Set<AnyCancellable>()
}
