# 필로우톡(FeelTalk)
![FeelTalk_ProfileImage](./image/FeelTalk_Profile.png)

## 📌 Table of Contents

### 1. Architecture
- [필로우톡(FeelTalk)](#필로우톡feeltalk)
  - [📌 Table of Contents](#-table-of-contents)
    - [1. Architecture](#1-architecture)
    - [2. Network](#2-network)
    - [3. ETC](#3-etc)
  - [Teck Stack](#teck-stack)
  - [1. Architecture](#1-architecture-1)
    - [1.1 Clean Architecture](#11-clean-architecture)
    - [1.2 MVVM with RxSwift](#12-mvvm-with-rxswift)
      - [Why?](#why)
      - [How?](#how)
      - [1.2.1 Input/Output Pattern](#121-inputoutput-pattern)
      - [Reactive Extension for UIViewController](#reactive-extension-for-uiviewcontroller)
    - [1.3. Coordinator Pattern](#13-coordinator-pattern)
      - [Why?](#why-1)
      - [How?](#how-1)
      - [1.3.1 시스템 플로우 관리](#131-시스템-플로우-관리)
      - [1.3.2 TabBarCoordinator](#132-tabbarcoordinator)
      - [1.3.3 Child -\> Parent 데이터 동기화 Trigger](#133-child---parent-데이터-동기화-trigger)
  - [2. Network](#2-network-1)
    - [2.1 Router Pattern](#21-router-pattern)
      - [Why?](#why-2)
      - [How?](#how-2)
    - [2. Request Interaction](#2-request-interaction)
      - [Why?](#why-3)
      - [How?](#how-3)
  - [ETC](#etc)
    - [1. Screen Save](#1-screen-save)
    - [2. FCM Handler](#2-fcm-handler)

### 2. Network
- [2.1 Router Pattern](#21-router-pattern)
- [2.2 Request Interaction](#22-request-interaction)

### 3. ETC
- [Screen Save](#1-screen-save)
- [FCM Handler](#2-fcm-handler)

## Teck Stack

## 1. Architecture 

### 1.1 Clean Architecture
Clean Architecture 원칙과 MVVM 패턴을 따릅니다.
![FeelTalk_CleanArchitecture](./image/FeelTalk_CleanArchitecture.png)
* 실제 폴더 구조가 아닌 Xcode 그룹 사용으로 프로젝트 구성을 관리합니다.

---

### 1.2 MVVM with RxSwift
#### Why? 
UIKit 기반 MVC 구조에서는 화면이 복잡해질수록 UI 로직과 비즈니스 로직이 ViewController에 집중되며 Massive ViewController 현상이 반복적으로 발생합니다. 프로젝트 초기 단계에서 필로우톡 역시 화면 수 증가와 다양한 비동기 이벤트 처리가 빈번할 것으로 예상되었기 때문에, 이러한 구조적 문제가 충분히 발생할 수 있다고 판단했습니다. 이를 예방하고 책임을 명확히 분리하기 위해 설계 단계에서 MVVM 패턴을 도입했습니다.

또한 UIKit은 사용자 입력, UI 업데이트, 네트워크 응답 등 서로 다른 비동기 이벤트를 Delegate, Closure, Notification 등 다양한 방식으로 처리하도록 설계되어 있어 이벤트 흐름을 일관되게 유지하기 어렵습니다. 이러한 특성이 반복되면 데이터 바인딩 로직이 다시 ViewController로 집중될 가능성이 높아, MVVM만으로는 Massive ViewController를 완전히 방지하기 어렵다고 판단했습니다.

RxSwift는 이러한 한계를 해결하기 위해 비동기 이벤트를 단일 스트림 기반으로 통합하고, View와 ViewModel 간 바인딩을 일관된 방식으로 유지할 수 있도록 지원합니다. 이에 따라 본 프로젝트는 아키텍처 설계 단계에서 RxSwift를 함께 도입해 MVVM 구조의 완성도를 높이고, 복잡한 비동기 흐름을 안정적으로 관리할 수 있는 기반을 마련했습니다.

#### How?
#### 1.2.1 Input/Output Pattern
RxSwift 기반 MVVM을 단순 Relay 조합으로만 구성하면 입력 이벤트와 출력 상태가 여러 스트림으로 분산되기 쉽습니다. 화면의 복잡도가 증가할수록 이러한 스트림은 ViewModel 내부에 산발적으로 흩어지며, View와 ViewModel 사이의 데이터 흐름도 일관성을 잃습니다. 이 구조는 시간이 지나면서 ViewModel 전역에 비즈니스 로직이 퍼지고, View가 ViewModel의 여러 프로퍼티를 직접 참조하게 되면서 결합도가 높아지는 문제가 있습니다.

이를 방지하기 위해 본 프로젝트는 Input/Output 패턴을 도입하여 ViewModel의 이벤트 흐름을 단일 구조로 통합했습니다.

* __Input__: View에서 발생하는 모든 사용자 이벤트를 하나의 구조체로 모아 ViewModel의 단일 진입점으로 전달합니다. 

  Input에 포함된 모든 이벤트를 `Observable`로 선언한 이유는 ViewModel이 이벤트 생성 시점을 직접 통제하고, View는 단순히 사용자 행동을 방출하는 역할만 수행하는 구조를 명확히 분리하기 위함입니다.

  Input은 View가 ViewModel에 전달해야 하는 이벤트의 인터페이스(Contract)를 정의하며, ViewModel은 해당 스트림을 생성하거나 수정하지 않고 읽기만 합니다. 이를 통해 View -> ViewModel 단방향 이벤트 흐름이 보장됩니다.
    ```Swift
    struct Input {
        let viewWillAppear: Observable<Void>
        let tapAnswerButton: Observable<Void>
        let tabMySignalButton: Observable<Void>
        let tapChatRoomButton: Observable<Void>
    }
    ```
* __Output__: ViewModel이 생성하는 UI 상태를 구조체로 묶어 View에 제공합니다.
  
  Output을 `Observable`로 노출하는 이유는 ViewModel이 내부 상태를 어떤 방식(PublishRelay, BehaviorRelay 등)으로 관리하는지 외부에서 알 수 없도록 캡슐화를 보장하기 위함입니다.  

    View는 Output에 정의된 Observable만 구독할 수 있으며, ViewModel의 내부 Relay에 직접 접근하거나 상태를 변경할 수 없습니다.  
    이 구조는 단방향 데이터 흐름을 유지할 뿐만 아니라, ViewModel 내부 구현이 변경되더라도 Output 인터페이스가 유지되어 유지보수성과 확장성을 크게 높여줍니다.

    ```Swift
    private let todayQuestion = PublishRelay<Question>()
    private let mySignal = PublishRelay<Signal>()
    private let partnerSignal = PublishRelay<Signal>()

    struct Output {
        let todayQuestion: Observable<Question>
        let mySignal: Observable<Signal>
        let partnerSignal: Observable<Signal>
    }
    ```
* __transform(input:)__: 모든 비즈니스 로직을 처리하는 메서드로, Input -> Logic -> Output의 흐름이 명확하게 고정됩니다.
    ```Swift
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .take(1)
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getTodayQuestion()
                    .asObservable()
                    .bind(to: vm.todayQuestion)
                    .disposed(by: disposeBag)
                
                vm.signalUseCase.getMySignal()
                    .bind(to: vm.mySignal)
                    .disposed(by: disposeBag)
 
                vm.signalUseCase.getPartnerSignal()
                    .bind(to: vm.partnerSignal)
                    .disposed(by: disposeBag)
            }

        return Output(todayQuestion: self.todayQuestion.asObservable(),
                        mySignal: self.mySignal.asObservable(),
                        partnerSignal: self.partnerSignal.asObservable())
    }
    ```

---

#### Reactive Extension for UIViewController
UIKit은 ViewController의 생명주기 이벤트를 `override`방식으로만 제공하기 때문에, MVVM 구조에서 해당 이벤트들을 ViewModel로 전달하기 위해 별도의 delegate 코드가 필요했습니다.

이를 개선하기 위해 본 프로젝트에서는 UIViewController의 생명주기를 Rx 기반 스트림으로 변환하는 Reactive Extension을 직접 구현했습니다.

아래 코드와 같이 UIKit의 methodInvoked(_:)를 사용해 시스템이 호출하는 Lifecycle 메서드를 Observable 스트림으로 변환합니다.

```Swift
extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }

        return ControlEvent
    }
}
```

이러한 설계로 인한 장점은 다음과 같습니다.
* View -> ViewModel 이벤트 흐름의 일관성 확보
  * UI 이벤트뿐 아니라 새영주기 이벤트도 동일한 Observable 스트림으로 처리할 수 있습니다.
* ViewController 내부 로직 감소
  * 생명주기를 처리하기 위해 override한 코드가 필요 없어집니다.
* ViewModel이 화면 로딩 / 갱신 시점을 직접 제어
  * viewWillAppear.take(1) -> 최초 진입 시 API 호출
  * viewDidAppear.skip(1) -> 화면이 다시 보여질 떄마다 UI 갱신
  * viewWillDisappear -> 키보드 / 타이머 종료 처리

### 1.3. Coordinator Pattern
#### Why?
필로우톡은 Massive ViewController 문제를 해결하기 위해 MVVM 아키텍처를 도입했습니다. 그러나 여전히 화면(View)을 담당하는 ViewController에 화면 전환(Flow) 로직이 포함되어, Massive ViewController 문제를 완전히 해소하지는 못했습니다.   

또한 ParentViewController가 ChildViewController를 직접 참조하며 화면 전환을 수행하는 구조로 인해, 두 ViewController 간의 의존성이 높아지는 문제가 존재했습니다. 이러한 문제를 해결하기 위해, 화면 전환(Flow) 로직을 ViewController로부터 분리할 수 있는 Coordiantor Pattern 을 적용했습니다.

#### How?
#### 1.3.1 시스템 플로우 관리
![Coordinator FlowChart](./image/FeelTalk_Coordinator_FlowChart.png)
필로우톡의 화면 전환에는 크게 두 가지(<font color= "green">로그인, 회원가입</font>, <font color= "red">FeelTalk 메인 서비스</font>) 플로우가 존재합니다.</br>
각각의 플로우 RootViewController가 UINavigationController에 Push 되는 시점은 첫 실행, AccessToken 유/무, 커플 여부에 따라 다르므로 각 케이스를 분기처리 하여 사용자 상태에 따른 화면 전환을 구현했습니다.

#### 1.3.2 TabBarCoordinator
프로젝트에서는 전체 화면 구조의 중심이 되는 탭 기반 UI를 구현하기 위해 TabbarCoordinator 패턴을 도입했습니다. 기존의 방식처럼 UITabBarController에서 탭 전환 로직을 직접 처리하는 방식은 화면 전환 책임이 UITabBarController 내부로 몰리며 유지보수가 어려워지는 문제가 있었습니다. 특히, 탭 구성 요소가 여러 모듈로 나뉘어지고, 각 탭마다 독립적인 네비게이션 흐름을 갖는 경우 이러한 문제는 더욱 심각해집니다.

이를 해결하기 위해 TabBarCoordinator를 도입하여 탭 구조 관리, 초기 화면 설정, 탭 간 독립적인 Navigation 흐름 구성 등을 UITabBarController에서 완전히 분리했습니다.

* 탭은 TabBarPage enum으로 정의되며, 각 탭은 아래 정보를 하나의 타입으로 보관합니다. 이를 통해 TabBar의 UI 정보가 분산되지 않고 단일 구조(enum)안에서 관리되며 확장성도 확보합니다.
```Swift
enum TabBarPage: String, CaseIterable {
    case home, question, challenge, myPage
    
    func toTitle() -> String { ... }                // 탭 타이틀
    func pageOfNumber() -> Int { ... }              // 탭별 인덱스
    func toIconName() -> String { ... }             // 기본 아이콘
    func toSelectedIconName() -> String { ... }     // 선택 아이콘
}
```

* Coordiantor는 앱 최초 구동시 start() 메서드를 통해 모든 탭의 NavigationController를 생성하고 TabBarController에 주입합니다. Coodiantor가 TabBarController 생성과 화면 초기 설정을 관리함으로써 ViewController는 UI로직만 담당하게 됩니다.

```Swift
func start() {
    let pages = TabBarPage.allCases
    let controllers = pages.map { self.createTabNavigationController(of: $0) }
    self.configureTabBarController(with: controllers)
}
```

* 탭 전환 시 기존 화면 상태가 유지되며, 탭마다 별도의 흐름(Stack)을 갖도록 각 탭은 독립적인 UINavigationController를 사용하도록 설계했습니다. 

```Swift
private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
    let tabNavigationController = UINavigationController()
    tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
    self.startTabCoordinator(of: page, to: tabNavigationController)
    return tabNavigationController
}
```

* 탭에 대응하는 Coordinator를 생성하고 각 Coordiantor가 해당 탭의 rootViewController를 관리하도록 설계했습니다.

```Swift
private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
    switch page {
    case .home:
        let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)

    case .question:
        let questionCoordinator = DefaultQuestionCoordinator(tabNavigationController)
        questionCoordinator.start()
        childCoordinators.append(questionCoordinator)

    case .challenge:
        let challengeCoordinator = DefaultChallengeCoordinator(tabNavigationController)
        challengeCoordinator.start()
        childCoordinators.append(challengeCoordinator)

    case .myPage:
        let myPageCoordinator = DefaultMyPageCoordinator(tabNavigationController)
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
}
```

#### 1.3.3 Child -> Parent 데이터 동기화 Trigger
ChildViewController에서 사용자가 서버 요청을 완료한 뒤 ParentViewController로 전환(Pop)될 때, 해당 작업의 결과가 ParentViewController에 제대로 동기화되지 않는 문제가 있었습니다.

기존에는 화면이 다시 나타나는 시점(viewWillAppear)에 데이터를 Reload하는 방식을 검토했지만, 다음과 같이 네트워크 오버헤드 발생 가능성이 있었습니다.

1. 사용자가 ChildViewController에서 아무 작업을 하지 않았음에도 ParentViewController의 viewWillAppear가 호출되기만 하면 불필요한 데이터 재요청 발생
2. 이미 viewDidAppar에서 초기 데이터를 불어왔음에도 viewWillAppear에서 중복 요청이 발생하여 네트워크 리소스 낭비

즉, 화면 전환 시점에서 데이터를 무조건 갱신하는 방식은 정확한 데이터 갱신 타이밍을 보장하지 못하고, 네트워크 효율성도 떨어진다는 문제가 있었습니다.

이를 해결하기 위해 ChildCoordinator -> ParentCoordinator로 이벤트를 명확하게 전달하는 Finish Delegate 패턴을 적용했습니다.

ChildCoordinator는 서버 작업이 정상적으로 완료된 시점에만 Delegate 메서드를 호출하여 ParentCoodinator에 위임하고 ParentCoordinator는 해당 ViewController의 ViewModel에 이벤트를 트리거로 필요한 시점에 데이터를 갱신하도록 구현했습니다.

```Swift
extension Coordinator {
    /// 현재 Coordinator의 Flow가 종료될 때 호출되는 메서드
    ///
    /// - childCoordiantor 배열을 모두 제거하여 메모리 누수를 방지하고, 불필요한 참조를 정리
    /// - 일반적으로 ChildViewController 또는 ViewModel에서 특정 작업이 완료되고 Pop or Dismiss 시점에 호출됨.
    func finish() { childCoordinator.removeAll() }
}
```

ChildCoordinator
```Swift
final class DefaultSignalCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .signal

    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.navigationController.dismiss(animated: false)
    }

    func dismiss() {
        self.childCoordinators.removeAll()
        self.navigationController.dismiss(animated: false)
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
```

ChildViewController의 ViewModle
```Swift
final class SignalViewModel {
    private weak var coodinator: SignalCoordinator?
    private let model = PublishRelay<Signal>()

    struct Input {
        let tapChangeSignal: Observable<Signal>
        let dismiss: Observable<Void>
    }

    func transfer(input: Input) -> Output {
        ...

        // 시그널 전송 버튼은 탭했을 떄
        input.tapChangeSignalButton
            .withLatestFrom(model)
            .withUnretained(self)
            .bind { vm, model in
                vm.signalUseCase.changeMySignal(model)  // 사용자의 현재 상태(model)를 기반으로 Signal 변경 요청
                .filter { $0 } 
                .delay(.microseconds(300), scheduler: MainSchedular.instance)   // BottomSheet가 내려가는 시간
                .bind(onNext: { _ in
                    vm.coordinator?.finish()    // Signal 변경 성공시 Coodinator의 finish() 호출 
                }).disposed(by: vm.disposeBag)
            }.disposed(by: vm.disposeBag)

        
        input.dismiss
            delay(.milliseconds(300), 
                scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposedBag)

        return Output(selectedSignal: self.model)
    }
}
```
ParentCoordinator
```Swift
extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .signal:
            homeViewController.viewModel.reloadObservable.accept(.signal)
        case .answer, .answered:
            homeViewController.viewModel.reloadObservable.accept(.todayQuestion)
        case .chatFromBottomSheet:
            showChatFlow()
        default:
            break
        }
        
        self.navigationController.tabBarController?.tabBar.isHidden = false
    }
}
```

---

## 2. Network
### 2.1 Router Pattern
#### Why?
기존 Repository 계층은 API 요청을 구성하는 Request Component(URL, HTTP Method, Parameter, …)를 여러 파일에 분산해 정의하는 방식으로 구현되어 있었습니다.<br>이러한 방식은 50개 이상의 API를 사용하는 상황에서, 엔드포인트가 지속적으로 확장되는 환경에 적합하지 않았습니다.<br>그로 인해 Request 정의의 일관성이 떨어지고, 휴먼 에러 및 유지보수 비용 증가 문제가 발생했습니다.<br>이를 해결하고자 Router Pattern을 도입하여 API 계층을 재구성했습니다.

#### How?
먼저, 모든 API가 공통적으로 준수해야 할 요청 규약을 Router Protocol로 정의해 프로젝트 전체의 엔드포인트 정의 방식을 일관되게 유지했습니다.
```Swift
public protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding? { get }
}
```

각 도메인(Challenge, Question, ...)별로 연관된 API들은 열거형(Enum)의 case로 정의했습니다.<br>이 방식은 새로운 엔드포인트 추가 시 기존 Enum과 switch 구문을 수정해야 하므로 개방-폐쇄 원칙(OCP)을 위반하지만, 다음과 같은 장점들을 고려하여 채택했습니다:

* 강력한 타입 안정성 및 명시성: 컴파일러가 누락된 케이스를 체크하여 API 정의를 안전하게 유지합니다.
* API 중앙 집중화: 도메인별 API를 단일 Enum에 모아 관리하여 응집도를 높입니다.
* 캡슐화: 연관 값(associated values)을 통해 각 요청에 필요한 데이터를 안전하게 전달합니다.

```Swift
enum ChallengeAPI {
    case addChallenge(requestDTO: AddChallengeRequestDTO)
    case completeChallenge(requestDTO: CompleteChallengeRequestDTO)
    case getChallenge(index: Int)
    case getChallengeCount
    ...
}
```

또한, URLRequestConvertible 프로토콜을 준수함으로써 Router에서 정의한 엔드포인트 정보를 실제 URLRequest로 안전하게 변환할 수 있도록 구성했습니다.<br>모든 Request Component는 Router 프로토콜에 따라 일관성 있게 정의되며, asURLRequest()에서는 이를 조합하여 최종 네트워크 요청을 생성합니다.

```Swift
extension ChallengeAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }

    var path: String {
        switch self {
        case .addChallenge:
            return "/api/v1/challenge"
        ...    
        }
    }

    var method: HTTPMethod {
        switch self {
        case .addChallenge: return .post
        ...
        }
    }

    var header: [String : String] {
        switch self {
        case .addChallenge,
            ...:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        ...
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .addChallenge(requestDTO: let dto):
            return ["title": dto.title,
                    "deadline": dto.deadline,
                    "content": dto.content]
        ...
        }
    }

    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .addChallenge,
            ...:
            return JSONEncoding.default
        ...
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)!
        var request = URLRequest(url: url)

        request.method = method
        request.headers = HTTPHeaders(header)
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}
```

### 2. Request Interaction
#### Why? 
필로우톡은 JWT기반 인증을 사용하며, Access Token에는 유효 기간이 존재합니다. 이 유효 기간이 짧기 떄문에 네트워크 요청 시점에 Access Token이 만료되거나 만료 직적인 경우가 빈번하게 발생합니다. 기존 구조에서는 각 API 호출부마다 토큰 만료 여부를 체크하고 재발급 요청을 수행해야 했기 때문에 중복 코드 발생, 유지보수성 저사, 재발급 타이밍 불일치로 인한 불안전성의 문제가 있었습니다.

이를 해결하기 위해 Alamofire RequestInterceptor를 활용하여 모든 네트워크 요청 전에 토큰 상태를 자동으로 점검하고 필요한 경우 안전하게 재발급 받아 반영하는 구조를 구축했습니다.

#### How?
* adapt()에서 AccessToken 자동 갱신
  * AccessToken, 만료 시간(expiredTime)을 Keychain에서 가져옵니다.
  * 만료 시간이 1분 이하로 남았을 경우, 토큰을 재발급하는 API(LoginAPI.reissuanceAccessToken)을 호출합니다.
  * 재발급 성공시 Keychain 값을 갱신하고, 새로운 Access Token을 URLRequest의 Header에 설정합니다
  * 만료 시간이 충분하면 기존 Access Token을 그대로 사용합니다.

```Swift
final class DefaultRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let crtDateStr = Date.toString(Date())
        guard let crtAccessToken = KeychainRepository.getItem(key: "accessToken") as? String,
              let crtExpiredTime = KeychainRepository.getItem(key: "expiredTime") as? String,
              let targetDate = Date.toDate(crtExpiredTime),
              let crtDate = Date.toDate(crtDateStr) else {
            completion(.success(urlRequest))
            return }

        if Int(targetDate.timeIntervalSince(crtDate)) <= 60 { // 토큰 만료 시간이 1분 이하인 경우(재발급)
            guard let crtRefreshToken = KeychainRepository.getItem(key: "refreshToken") as? String else {
                completion(.success(urlRequest))
                return
            }

            AF.request(
                LoginAPI.reissuanceAccessToken(
                    requestDTO: AccessTokenReissuanceRequestDTO(
                        accessToken: crtAccessToken,
                        refreshToken: crtRefreshToken)))
            .responseDecodable(of: BaseResponseDTO<LoginResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    let loginResponseDTO: LoginResponseDTO?? = responseDTO.data
                    guard let data_unwrap = loginResponseDTO else {
                        return
                    }
                    guard let data = data_unwrap else {
                        return
                    }

                    if KeychainRepository.addItem(value: data.accessToken, key: "accessToken") &&
                        KeychainRepository.addItem(value: data.refreshToken, key: "refreshToken") &&
                        KeychainRepository.addItem(value: KeychainRepository.setExpiredTime(), key: "expiredTime") {

                    } 
                case .failure(let error):
                    print("[RESPONSE]: Fail to reissue \(error)")
                    print("토큰 재발급 실패")
                    print(error)
                }
            }

            guard let newAccessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return }
            
            var urlRequest = urlRequest
            urlRequest.setValue(newAccessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        } else { // 토큰 만료 시간이 여유 있는 경우(기존 토큰 사용)
            var urlRequest = urlRequest
            urlRequest.setValue(crtAccessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        }
    }
}
```

## ETC
### 1. Screen Save
### 2. FCM Handler



