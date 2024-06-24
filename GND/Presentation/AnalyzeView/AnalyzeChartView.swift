//
//  AnalyzeChartView.swift
//  GND
//
//  Created by 235 on 6/20/24.
//

import SwiftUI
import Charts
import Combine

struct AnalyzeChartView: View {
    @ObservedObject var viewModel: AnalyzeViewModel
    @State private var mineDatas: [AnalyzeData] = []
    @State private var ageGroupDatas: [AnalyzeData] = []


    var body: some View {
        switch viewModel.selectedType {
        case .stride:
            Chart(viewModel.strideChartDatas, id: \.isMine) { element in

                ForEach(element.data, id: \.date) { data in
                    let date = data.date.toDate()!
                    BarMark (x: .value("date", date.formattedToChart(for: viewModel.selectedDateRange)),
                             yStart: .value("최소보폭", data.minStride),
                             yEnd: .value("최대보폭", data.maxStride)
                    ).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .foregroundStyle(by: .value("isMine", element.isMine ? "내 기록": "연령대 평균"))
            }.chartForegroundStyleScale(
                [
                    "내 기록" : .brown.opacity(0.8),
                    "연령대 평균": .red.opacity(0.4)
                ])
        case .steps:
            Chart(viewModel.stepsChartDatas, id: \.isMine) { element in
                ForEach(element.data, id: \.date) { data in
                    let date = data.date.toDate()!
                    BarMark (x: .value("date", date.formattedToChart(for: viewModel.selectedDateRange)),
                             y: .value("걸음수", data.step)
                    ).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .foregroundStyle(by: .value("isMine", element.isMine ? "내 기록": "연령대 평균"))
            }.chartForegroundStyleScale(
                [
                    "내 기록" : .brown.opacity(0.8),
                    "연령대 평균": .red.opacity(0.4)
                ])
        case .speed:
            Chart(viewModel.speedChartDatas, id: \.isMine) { element in
                ForEach(element.data, id: \.date) { data in
                    let date = data.date.toDate()!
                    BarMark (x: .value("date", date.formattedToChart(for: viewModel.selectedDateRange)),
                             yStart: .value("최소보폭", data.minSpeed),
                             yEnd: .value("최대보폭", data.maxSpeed)
                    ).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .foregroundStyle(by: .value("isMine", element.isMine ? "내 기록": "연령대 평균"))
            }.chartForegroundStyleScale(
                [
                    "내 기록" : .brown.opacity(0.8),
                    "연령대 평균": .red.opacity(0.4)
                ])
        }}
}
