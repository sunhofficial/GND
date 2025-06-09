//
//  ChartView.swift
//  GND
//
//  Created by 235 on 5/16/24.
//

import SwiftUI
import Charts
enum ChartMode: String,CaseIterable {
    case speed = "속도"
    case stride = "보폭"
    case distance = "운동거리"
    case walkCount = "걸음수"
    var units: String {
        switch self {
        case .speed:
            "km/h"
        case .stride:
            "cm"
        case .distance:
            "m"
        case .walkCount:
            "걸음"
        }
    }

}
struct ChartButton: View {

    var mode: ChartMode
    var isSeleceted: Bool
    var value: Double
    var action: () -> Void
    var body: some View {
        Button(action:  action) {
            VStack(spacing: 8){
                Text(mode.rawValue)
                Text("\(value, specifier: "%.1f") \(mode.units)")
            }.font(.system(size: 24, weight: .medium))
                .foregroundStyle(isSeleceted ? Color(uiColor:  CustomColors.cell) : Color(uiColor:CustomColors.brown))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(!isSeleceted ? Color(uiColor:  CustomColors.cell) : Color(uiColor:CustomColors.brown))
                .clipShape(.rect(cornerRadius: 10))


        }
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let time: Int
    var value: Double
}

struct ChartView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    var userGoal: UserGoal
    
    var body: some View {
        VStack(spacing: 16) {
            // Chart Mode Selection
            HStack(spacing: 16) {
                ForEach(ChartMode.allCases, id: \.self) { mode in
                    ChartButton(
                        mode: mode,
                        isSeleceted: viewModel.selectedChartMode == mode,
                        value: getCurrentValue(for: mode)
                    ) {
                        viewModel.selectChartMode(mode) // ViewModel에 위임
                    }
                }
            }
            
            HStack {
                Spacer()
                Text("운동 시간 \(viewModel.exerciseTime ?? "0시간 0분")")
                    .font(.system(size: 24, weight: .medium))
            }
            
            // Chart - 이제 ViewModel의 상태만 구독
            Chart {
                ForEach(viewModel.animatedChartData) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.time),
                        y: .value("Value", dataPoint.value)
                    )
                    .lineStyle(.init(lineWidth: 3))
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(Color.brown)
                }
                
                if let goalValue = viewModel.chartGoalValue {
                    RuleMark(y: .value("Goal", goalValue))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.gray)
                        .annotation(position: .trailing, alignment: .leading) {
                            Text("목표: \(goalValue, specifier: "%.1f")")
                                .font(.headline)
                                .foregroundStyle(.brown)
                                .offset(x: -48)
                        }
                }
            }
            .chartXAxis(.hidden)
            .frame(height: 240)
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.selectChartMode(.speed) // 초기 모드 설정
        }
    }
    
    private func getCurrentValue(for mode: ChartMode) -> Double {
        guard let exerciseData = viewModel.exerciseData else { return 0 }
        
        switch mode {
        case .speed: return exerciseData.averageSpeed
        case .stride: return Double(exerciseData.averageStride)
        case .distance: return Double(exerciseData.distanceDatas.last ?? 0)
        case .walkCount: return Double(exerciseData.walkCountDatas.last ?? 0)
        }
    }
}
