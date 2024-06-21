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
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var dateRanges: [DropRange: String] = [:]
    private func calculateAllDateRanges() {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy.MM.dd"
          let today = Date()
        endDate = dateFormatter.string(from: today)

        dateRanges[.hour] = dateFormatter.string(from: Calendar.current.date(byAdding: .hour,value: -24, to: today)!)
        dateRanges[.day] = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -7, to: today)!)
        dateRanges[.week] = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: today)!)
        dateRanges[.month]  = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -12, to: today)!)
      }
    func fetchChartData(type: AnalzyeType, dateRange: DropRange) {
        guard let startdate = dateRanges[dateRange] else {return}
        switch type {
        case .stride:
            analyzeUsecase.getStrideStats(type: dateRange, startDate: startdate, endDate: endDate)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                               .store(in: &cancellables)
        case .speed:
            analyzeUsecase.getSpeedStats(type: dateRange, startDate: startdate, endDate: endDate)
                .sink { res in
                    print(res)
                } receiveValue: { res in
                    print(res)
                }        .store(in: &cancellables)

        case .steps:
            analyzeUsecase.getStepsStats(type: dateRange, startDate: startdate, endDate: endDate)
                .sink { res in
                    print(res)
                } receiveValue: { res in
                    print(res)
                }        .store(in: &cancellables)
        }
    }

}
