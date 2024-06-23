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
    //    @Binding var selectedType: AnalzyeType
    @State private var mineDatas: [AnalyzeData] = []
    @State private var ageGroupDatas: [AnalyzeData] = []


    var body: some View {
        Chart {
            switch viewModel.selectedType {
            case .stride:
                ForEach(viewModel.strideChartDatas.mine, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        yStart: .value("최소 보폭", data.minStride),
                        yEnd: .value("최대 보폭", data.maxStride)
                    )
                    .foregroundStyle(Color.blue).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("내 데이터")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }

                ForEach(viewModel.strideChartDatas.ageGroup, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        yStart: .value("최소 보폭", data.minStride),
                        yEnd: .value("최대 보폭", data.maxStride)
                    )
                    .foregroundStyle(Color.green).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("연령 그룹")
                            .font(.caption)
                            .foregroundColor(.green).opacity(0.4)
                    }
                }
            case .speed:
                ForEach(viewModel.speedChartDatas.mine, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        yStart: .value("", data.minSpeed),
                        yEnd: .value("최대 보폭", data.maxSpeed)
                    )
                    .foregroundStyle(Color.blue).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("내 데이터")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }

                ForEach(viewModel.speedChartDatas.ageGroup, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        yStart: .value("최소 보폭", data.minSpeed),
                        yEnd: .value("최대 보폭", data.maxSpeed)
                    )
                    .foregroundStyle(Color.green).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("연령 그룹")
                            .font(.caption)
                            .foregroundColor(.green).opacity(0.4)
                    }
                }
            case .steps:
                ForEach(viewModel.stepsChartDatas.mine, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        y:.value("걸음수", data.steps)
                    )
                    .foregroundStyle(Color.blue).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("내 데이터")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }

                ForEach(viewModel.stepsChartDatas.ageGroup, id: \.date) { data in
                    BarMark(
                        x: .value("날짜", data.date),
                        y:.value("걸음수", data.steps)
                    )
                    .foregroundStyle(Color.green).opacity(0.4)
                    .annotation(position: .top, alignment: .leading) {
                        Text("연령 그룹")
                            .font(.caption)
                            .foregroundColor(.green).opacity(0.4)
                    }
                }
            }
        }
//        Chart{
            //            ForEach(viewModel.mineData + viewModel.ageGroup, id: \.date) { data in
            //                if let strideData = data as? AnalyzeStrideData {
            //                    BarMark(x: .value("날짜", strideData.date), yStart: .value("최소보폭", strideData.minStride), yEnd: .value("최대보폭", strideData.maxStride))
            //                        .foregroundStyle(Color.blue)
            //                } else if let speedData = data as? AnalyzeSpeedData {
            //                    BarMark(x: .value("Date", speedData.date),
            //                            yStart: .value("Min Speed", speedData.minSpeed),
            //                            yEnd: .value("Max Speed", speedData.maxSpeed))
            //                    .foregroundStyle(Color.green)
            //                } else if let stepData = data as? AnalyzeStepData {
            //                    BarMark(x: .value("Date", stepData.date),
            //                            y: .value("Steps", stepData.steps))
            //                    .foregroundStyle(Color.orange)
            //                }
            //            }

//        }

    }
}

//#Preview {
//    AnalyzeChartView()
//}
