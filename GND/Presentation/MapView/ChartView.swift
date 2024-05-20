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
            "m/s"
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
    @State private var selectedMode: ChartMode?
    @State private var datapoints: [DataPoint] = []
    @State private var animatedDatapoints: [DataPoint] = []
    @State private var goalValue = 10.0
    @State private var isAnimtedFinish = false
    @State private var currentTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16){
                ChartButton(mode: .speed, isSeleceted: selectedMode == .speed, value: viewModel.exerciseData?.averageSpeed ?? 0) {
                    selectedMode = .speed
                }
                ChartButton(mode: .stride, isSeleceted: selectedMode == .stride, value: Double(viewModel.exerciseData?.averageStride ?? 0)) {
                    selectedMode = .stride
                }
            }
            HStack(spacing: 16){
                ChartButton(mode: .distance, isSeleceted: selectedMode == .distance, value: Double(viewModel.exerciseData?.totalDistance ?? 0)) {
                    selectedMode = .distance
                }
                ChartButton(mode: .walkCount, isSeleceted: selectedMode == .walkCount, value: Double(viewModel.exerciseData?.totalWalkCount ?? 0)) {
                    selectedMode = .walkCount
                }
            }
            HStack {
                Spacer()
                Text("운동 시간 \(viewModel.exerciseTime ?? "2시간 1분")")
                    .font(.system(size: 24, weight: .medium))
            }

            Chart {
                ForEach(animatedDatapoints) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.time),
                        y: .value("Value", dataPoint.value )
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
            .onChange(of: selectedMode) { oldValue, newValue in
                datapoints = []
                    updateChart(for: newValue)
            }



    }
    private func updateChart(for mode: ChartMode?) {
        guard let mode = mode else {return}
        currentTask?.cancel() // 이전 작업 취소
        datapoints = dataPoints(for: mode)
        animatedDatapoints = []
        currentTask = Task {
            for (index, point) in datapoints.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.01) {
                    withAnimation(.easeOut(duration: 1)) {
                        animatedDatapoints.append(point)
                    }
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
            return exerciseData.strideDatas.enumerated().map { DataPoint(time: $0, value: Double($1)) }
        case .distance:
            return exerciseData.distanceDatas.enumerated().map { DataPoint(time: $0, value: Double($1)) }
        case .walkCount:
            return exerciseData.walkCountDatas.enumerated().map { DataPoint(time: $0, value: Double($1)) }
        }
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let time: Int
    var value: Double
//    var animate: Bool = false
}
//struct DummyData {
//    static func generateDummyExerciseData() -> ExerciseData {
//        return ExerciseData(
//            speedDatas: [5.0, 5.2, 5.1, 5.3,5.0, 5.2, 5.1, 5.3,5.0, 5.2, 5.1, 5.3,75.0, 76.0, 74.5, 75.5],
//            strideDatas: [75.0, 76.0, 74.5, 75.5,100.0, 105.0, 102.0, 108.0,100.0, 105.0, 102.0, 108.0],
//            distanceDatas: [100.0, 105.0, 102.0, 108.0,74.5, 75.5,100.0, 105.0, 102.0, 108.0,100.0, 105.0, 102.0, 108.0],
//            walkCountDatas: [1000, 1050, 1020, 1080]
//        )
//    }
//}
//#Preview {
//
//    //    let exerciseViewModel = ExerciseViewModel(exerciseUsecase: ExerciseUsecase(coreLocationService: CoreLocationServices(), exerciseRepository: ExerciseRepository(), coreMotionService: CoreMotionService()))
//    //    exerciseViewModel.exerciseData = dummyData
//    ChartView(viewModel: ExerciseViewModel(dummyData: DummyData.generateDummyExerciseData()))
//}
