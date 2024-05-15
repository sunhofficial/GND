//
//  MainViewModel.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import UIKit
protocol MainviewModelInput {
    func moveToExercise(mode: ExerciseMode)
}
final class MainViewModel: ObservableObject, MainviewModelInput {
    private weak var coordinator: StrideCoordinator?
    func moveToExercise(mode: ExerciseMode) {
        coordinator?.doExerciseView(mode: mode  )
    }
    init(coordinator: StrideCoordinator) {
            self.coordinator = coordinator
      }
}
