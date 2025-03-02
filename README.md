# GND

이 앱은 iOS 및 Android 버전으로 각각 개발되었으며, 사용자의 보폭, 걸음 속도, 걷기 거리 등을 실시간으로 분석하여 사용자에게 적절한 피드백을 제공합니다. 이를 통해 고령자들이 보다 건강한 생활을 영위할 수 있도록 돕고, 운동 능력을 향상시키는 것을 목표로 하고 있습니다.

앱 시연 영상: https://m.site.naver.com/1oDHS

## 기술 스택
- **UIKit**
- **Combine**
- **CoreMotion**
- **CoreLocation**
- **MapKit**
- **SnapKit**
- **Then**
- **Alamofire**

## 아키텍처
![Image](https://github.com/user-attachments/assets/509c9f36-259b-4407-9330-4f3b0581c71c)
이 프로젝트는 **Clean 아키텍처**와 **MVVM 아키텍처**를 기반으로 하고 있으며, **Coordinator Pattern** 패턴을 통해 화면전환 로직을 분리했습니다.
각 계층은 다음과 같이 구성됩니다:
Presentation Layer: ViewController(UI)와 ViewModel(MVVM 패턴)이 존재하며, 화면전환을 위해 Coordinator를 활용하였습니다.
Domain Layer: UseCase를 통해 비즈니스 로직을 처리하며, Repository Protocol을 활용하여 Repository와의 결합도를 낮췄습니다.
Data Layer: 네트워크 및 센서등의 데이터를 Repository에서 처리.
특히 Domain Layer에는 UseCase뿐만 아니라 UseCase Protocol을 포함하여, Data Layer의 Repository Protocol과 분리하여 의존성을 최소화하려 했습니다. 이를 통해 UseCase는 특정 데이터 소스에 종속되지 않고, 보다 유연한 구조를 유지할 수 있습니다.
규모가 크지 않아 Coordinator내에서 의존성 주입을 하였습니다. 
#### AppCoordinator는 앱 시작 시점에서 로그인 플로우(LoginCoordinator)와 메인 플로우(TabCoordinator)를 결정합니다.
#### TabCoordinator는 각 탭에 해당하는 하위 Coordinator(StrideCoordinator, TogetherCoordinator)을 생성해 화면을 초기화합니다.
#### StrideCoordinator는 메인 탭 내에서 운동 관련 화면(ExerciseViewController 등)의 흐름을 제어합니다.

## 기능 설명

### 실시간 피드백 기능
- **CoreMotion**의 `PedometerData`를 20초 간격으로 비동기적으로 수집 및 분석합니다.
- 목표를 미달한 경우, 부족한 데이터를 **Combine**을 통해 방출하고, **UseCase**를 통해 **ViewModel**에서 구독하여 뷰로 전달합니다.
- `queryPedometerData` 메서드를 사용하여 특정 시간대의 걷기 데이터를 기반으로 정확한 피드백을 제공합니다.

### 에너지 효율성 향상
- **Xcode Gauges**를 활용하여 **CoreLocation**의 `desiredAccuracy`와 `distanceFilter`를 조정하여, 맵 경로의 정확도와 에너지 효율성 간의 최적 균형을 맞췄습니다.
- `distanceFilter` 값은 배터리 소모에 직접적인 영향을 주지 않으며, 위치 업데이트 빈도를 조절하는 역할을 합니다.
- `desiredAccuracy`를 기본값으로 설정하면 에너지 소비가 많았으나, `kCLLocationAccuracyNearestTenMeters`로 설정하여 10미터의 오차를 허용하면서도 에너지 효율성을 유지할 수 있었습니다.




## 라이센스
이 프로젝트는 MIT 라이센스 하에 제공됩니다. 

## 수상 내역
- **KCC2024 논문 발표 및 장려상 수상**
