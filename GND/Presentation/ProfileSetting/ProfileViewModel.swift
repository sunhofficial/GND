//
//  ProfileViewModel.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Foundation
import Combine
protocol ProfileViewModelInput {
    var selectGender: CurrentValueSubject<Gender, Never> {get}
    var selectAgeRange: CurrentValueSubject<AgeRange?, Never> {get}
    func sendProfile()
}
protocol ProfileViewModelOutput {
    var isFormValid: AnyPublisher<Bool, Never> {get}
    var profilePosted: PassthroughSubject<Void, Error> {get}
}
protocol ProfileViewModelType: ProfileViewModelInput, ProfileViewModelOutput {

}
class ProfileViewModel: ProfileViewModelType{
    var selectGender =  CurrentValueSubject<Gender, Never>(.none)
    var selectAgeRange = CurrentValueSubject<AgeRange?, Never>(nil)
    
    @Published private(set) var selectedGender: Gender = .none
    @Published private(set) var selectedAge: AgeRange?

    private var cancellables = Set<AnyCancellable>()
    init() {
        selectGender
                .assign(to: &$selectedGender)

        selectAgeRange
                .assign(to: &$selectedAge)
    }
    var profilePosted: PassthroughSubject<Void, Error> = .init()

    var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(selectGender, selectAgeRange)
            .map { gender, ageRange in
                return gender != .none && ageRange != nil
            }
            .eraseToAnyPublisher()
    }

  
    func sendProfile() {
        print(selectedGender, selectedAge)
    }
    
}
