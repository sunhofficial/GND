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
    @Published var selectedType: AnalzyeType = .stride
    @Published var endDate: Date = Date()
    @Published var dateRanges: [DropRange: Date] = [:]
    @Published var mineData: [AnalyzeData] = []
    @Published var ageGroup: [AnalyzeData] = []
    @Published var strideChartDatas: AnalzyeDateResponse<AnalyzeStrideData> = .init(mine: [], ageGroup: [])
    @Published var stepsChartDatas: AnalzyeDateResponse<AnalyzeStepData> = .init(mine: [], ageGroup: [] )
    @Published var speedChartDatas: AnalzyeDateResponse<AnalyzeSpeedData> = .init(mine: [], ageGroup: [])
    private func calculateAllDateRanges() {
        let today = Date()
        dateRanges[.hour] = Calendar.current.date(byAdding: .hour,value: -24, to: today)!
        dateRanges[.day] = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        dateRanges[.week] =  Calendar.current.date(byAdding: .month, value: -1, to: today)!
        dateRanges[.month]  =  Calendar.current.date(byAdding: .month, value: -12, to: today)!
    }
    func updateAnalyzeType(type: AnalzyeType) {
        self.selectedType = type
    }
    func fetchChartData( dateRange: DropRange) {
        guard let startdate = dateRanges[dateRange] else {return}
        switch selectedType {
        case .stride:
            analyzeUsecase.getStrideStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink(receiveCompletion: { _ in }, receiveValue: {[weak self]
                    res in
//                    self?.mineData = res.mine
//                    self?.ageGroup = res.ageGroup
                    self?.strideChartDatas = res
                })
                .store(in: &cancellables)
        case .speed:
            analyzeUsecase.getSpeedStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink { res in
                    print(res)
                } receiveValue: { [weak self]
                    res in
//                    self?.mineData = res.mine
//                    self?.ageGroup = res.ageGroup
                    self?.speedChartDatas = res
                }        .store(in: &cancellables)
            
        case .steps:
            analyzeUsecase.getStepsStats(type: dateRange, startDate: startdate.formattedDateString(), endDate: endDate.formattedDateString())
                .sink { res in
                    print(res)
                } receiveValue: { [weak self]
                    res in
//                    self?.mineData = res.mine
//                    self?.ageGroup = res.ageGroup
                    self?.stepsChartDatas = res
                }        .store(in: &cancellables)
        }
    }
    
}
