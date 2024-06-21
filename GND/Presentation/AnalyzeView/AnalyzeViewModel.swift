//
//  AnalyzeViewModel.swift
//  GND
//
//  Created by 235 on 6/20/24.
//

import Combine
import Foundation
final class AnalyzeViewModel: ObservableObject {
    private var analyzeUsecase: AnalyzeUseCase
    private var cancellables = Set<AnyCancellable>()
    init(analyzeUsecase: AnalyzeUseCase) {
        self.analyzeUsecase = analyzeUsecase
        calculateAllDateRanges()
    }
    //    @Published var startDate: String = ""
    @Published var endDate: Date = Date()
    @Published var dateRanges: [DropRange: Date] = [:]
    private func calculateAllDateRanges() {
        let today = Date()
        dateRanges[.hour] = Calendar.current.date(byAdding: .hour,value: -24, to: today)!
        dateRanges[.day] = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        dateRanges[.week] =  Calendar.current.date(byAdding: .month, value: -1, to: today)!
        dateRanges[.month]  =  Calendar.current.date(byAdding: .month, value: -12, to: today)!
    }
    func fetchChartData(type: AnalzyeType, dateRange: DropRange) {
        guard let startdate = dateRanges[dateRange] else {return}
        switch type {
        case .stride:
            analyzeUsecase.getStrideStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &cancellables)
        case .speed:
            analyzeUsecase.getSpeedStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink { res in
                    print(res)
                } receiveValue: { res in
                    print(res)
                }        .store(in: &cancellables)

        case .steps:
            analyzeUsecase.getStepsStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink { res in
                    print(res)
                } receiveValue: { res in
                    print(res)
                }        .store(in: &cancellables)
        }
    }

}
