//
//  ChartView.swift
//  GND
//
//  Created by 235 on 5/16/24.
//

import SwiftUI
import Charts
enum ChartMode: String {
    case speed = "속도"
    case stride = "보폭"
    case distance = "운동거리"
    case walkCount = "걸음수"
    var units: String {
        switch self {
        case .speed:
            "m/h"
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
struct ChartView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var selectedMode: ChartMode? {
        didSet {
            updateChart(for: selectedMode)
        }
    }
    @State private var datapoints: [DataPoint] = []
    @State private var goalValue = 10.0
    var body: some View {
        VStack {
            HStack(spacing: 16){
                ChartButton(mode: .speed, isSeleceted: selectedMode == .speed, value: viewModel.exerciseData?.averageSpeed ?? 0) {
                    selectedMode = .speed
                }
                ChartButton(mode: .stride, isSeleceted: selectedMode == .stride, value: viewModel.exerciseData?.averageStride ?? 0) {
                    selectedMode = .stride
                }
            }
            HStack(spacing: 16){
                ChartButton(mode: .distance, isSeleceted: selectedMode == .distance, value: viewModel.exerciseData?.totalDistance ?? 0) {
                    selectedMode = .distance
                }
                ChartButton(mode: .walkCount, isSeleceted: selectedMode == .walkCount, value: Double(viewModel.exerciseData?.totalWalkCount ?? 0)) {
                    selectedMode = .walkCount
                }
            }

            Chart {

                ForEach(datapoints) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.time),
                        y: .value("Value", dataPoint.animate ?  dataPoint.value : 0)
                    ).lineStyle(.init(lineWidth: 3))

                        .interpolationMethod(.cardinal)
                        .foregroundStyle(Color(uiColor: CustomColors.brown))
                }
                RuleMark(y: .value("Goal", goalValue))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundStyle(.gray)
                    .annotation(position: .trailing, alignment: .leading) {
                        Text("목표: \(goalValue, specifier: "%.1f")")
                            .font(.headline)
                            .foregroundStyle(Color(uiColor: CustomColors.brown))
                            .offset(x: -30)
                    }

            }.chartXAxis(.hidden)
                .chartYAxis(content: {
                    AxisMarks (preset: .automatic){ val in
                        AxisValueLabel()
                    }
                })
                .frame(height: 240)

        }.padding(.horizontal, 16)
            .onAppear {
                if selectedMode == nil {
                    selectedMode = .speed // 초기 선택 모드 설정
                }
            }


    }
    private func updateChart(for mode: ChartMode?) {
        guard let mode = mode else {return}
        datapoints = dataPoints(for: mode)
        for (index, _) in datapoints.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.snappy(duration: 1)) {
                    datapoints[index].animate = true
                }
            }
        }
    }
    func dataPoints(for mode: ChartMode?) -> [DataPoint] {
        guard let mode = mode, let exerciseData = viewModel.exerciseData else { return [] }
        switch mode {
        case .speed:
            return exerciseData.speedDatas.enumerated().map { DataPoint(time: $0, value: $1) }
        case .stride:
            return exerciseData.strideDatas.enumerated().map { DataPoint(time: $0, value: $1) }
        case .distance:
            return exerciseData.distanceDatas.enumerated().map { DataPoint(time: $0, value: $1) }
        case .walkCount:
            return exerciseData.walkCountDatas.enumerated().map { DataPoint(time: $0, value: Double($1)) }
        }
    }
}
//#Preview {
////    ChartView(viewModel: ExerciseViewModel(exerciseUsecase: ExerciseUsecase(coreLocationService: CoreLocationServices(), exerciseRepository: ExerciseRepository(), coreMotionService: CoreMotionService())))
//}
struct DataPoint: Identifiable {
    let id = UUID()
    let time: Int
    let value: Double
    var animate: Bool = false
}
struct DummyData {
    static func generateDummyExerciseData() -> ExerciseData {
        return ExerciseData(
            speedDatas: [5.0, 5.2, 5.1, 5.3,5.0, 5.2, 5.1, 5.3,5.0, 5.2, 5.1, 5.3,75.0, 76.0, 74.5, 75.5],
            strideDatas: [75.0, 76.0, 74.5, 75.5,100.0, 105.0, 102.0, 108.0,100.0, 105.0, 102.0, 108.0],
            distanceDatas: [100.0, 105.0, 102.0, 108.0,74.5, 75.5,100.0, 105.0, 102.0, 108.0,100.0, 105.0, 102.0, 108.0],
            walkCountDatas: [1000, 1050, 1020, 1080]
        )
    }
}
#Preview {

    //    let exerciseViewModel = ExerciseViewModel(exerciseUsecase: ExerciseUsecase(coreLocationService: CoreLocationServices(), exerciseRepository: ExerciseRepository(), coreMotionService: CoreMotionService()))
    //    exerciseViewModel.exerciseData = dummyData
    ChartView(viewModel: ExerciseViewModel(dummyData: DummyData.generateDummyExerciseData()))
}
