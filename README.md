# 필로우톡(FeelTalk)
![FeelTalk_ProfileImage](./image/FeelTalk_Profile.png)
## Teck Stack
## 1. Architecture
### 1.1 Clean Architecture
Clean Architecture 원칙과 MVVM 패턴을 따릅니다.
![FeelTalk_CleanArchitecture](./image/FeelTalk_CleanArchitecture.png)
* 실제 폴더 구조가 아닌 Xcode 그룹 사용으로 프로젝트 구성을 관리합니다.

### 1.2 MVVM with RxSwift
#### Why? 
기존 UIKit 기반 구조에서는 ViewController가 지나치게 비대(Massive ViewController)해지는 경향이 반복적으로 발생했습니다. 이는 단일 클래스(ViewController)에 너무 많은 책임이 모여 가독성과 유지보수성이 떨어지고, UI로직과 비즈니스 로직이 강하게 결함되어 재사용성이 저하되는 문제가 있었습니다. 이러한 문제를 해결하고 확장성, 유지보수성을 극대화화기 위해, 필로우톡 프로젝트에 MVVM 패턴을 도입했습니다.

#### How?
MVVM 패턴에서 데이터 바인딩 방식에 있어 아래와 같은 방법을 고려했습니다.
1. Closure나 Delegate 패턴을 활용한 데이터 바인딩
2. RxSwift를 활용한 데이터 바인딩

### 1.3. Coordinator Pattern
#### Why?
필로우톡은 Massive ViewController 문제를 해결하기 위해 MVVM 아키텍처를 도입했습니다.   
그러나 여전히 화면(View)을 담당하는 ViewController에 화면 전환(Flow) 로직이 포함되어, Massive ViewController 문제를 완전히 해소하지는 못했습니다.   
또한 ParentViewController가 ChildViewController를 직접 참조하며 화면 전환을 수행하는 구조로 인해, 두 ViewController 간의 의존성이 높아지는 문제가 존재했습니다.   
이러한 문제를 해결하기 위해, 화면 전환(Flow) 로직을 ViewController로부터 분리할 수 있는 Coordiantor Pattern 을 적용했습니다.

#### How?
#### 1.3.1 시스템 플로우 관리
![Coordinator FlowChart](./image/FeelTalk_Coordinator_FlowChart.png)
필로우톡의 화면 전환에는 크게 두 가지(<font color= "green">로그인, 회원가입</font>, <font color= "red">FeelTalk 메인 서비스</font>) 플로우가 존재합니다.</br>
각각의 플로우 RootViewController가 UINavigationController에 Push 되는 시점은 첫 실행, AccessToken 유/무, 커플 여부에 따라 다르므로 각 케이스를 분기처리 하여 사용자 상태에 따른 화면 전환을 구현했습니다.


#### 1.3.2 Navigation Stack 관리
회원가입 화면(SignUpViewController)에서 ‘인증 완료’ 버튼을 탭하면 서버에 회원가입 요청을 보낸 후, 커플 매칭을 위한 커플 코드 화면(InviteCodeViewController) 으로 전환됩니다.
이때 스와이프 백(Swipe Back) 제스처나 네비게이션 바의 Back 버튼으로 이전 화면으로 돌아갈 경우, 이미 회원가입이 완료되었음에도 불구하고 사용자가 입력한 정보가 남아 있는 SignUpViewController가 다시 표시되는 문제가 발생했습니다.
![Coordinator FlowChart](./image/FeelTalk_Coordinator_SignUp.png)


이는 회원가입 완료 후 불필요한 화면 복귀로 인한 UX 저하와, 이미 사용이 끝난 ViewController 및 ViewModel 인스턴스가 Heap 영역에 잔존하면서 발생할 수 있는 메모리 누수(Memory Leak) 문제를 유발할 수 있었습니다.
이를 방지하기 위해, UINavigationController의 Navigation Stack을 제어하는 로직을 추가하여 회원가입 완료 시 이전 화면을 Stack에서 제거하도록 구현했습니다.
![Coordinator FlowChart](./image/FeelTalk_Coordinator_Navigation_Stack.png)

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

#### Result!
이와 같은 구조를 적용하면 Repository 계층은 Request를 매번 수동으로 구성할 필요 없이, 각 API가 제공하는 URLRequestConvertible을 그대로 Alamofire(AF.request)에 전달하기만 하면 됩니다.<br>이는 네트워크 레이어의 중복 코드 제거와 Request 정의의 일관성 확보에 크게 기여했습니다.

### 2. Request Interaction
#### Why? 
필로우톡은 JWT기반 인증을 사용하며, Access Token에는 유효 기간이 존재합니다. 이 유효 기간이 짧기 떄문에 네트워크 요청 시점에 Access Token이 만료되거나 만료 직적인 경우가 빈번하게 발생합니다. 

기존 구조에서는 각 API 호출부마다 토큰 만료 여부를 체크하고 재발급 요청을 수행해야 했기 때문에 중복 코드 발생, 유지보수성 저사, 재발급 타이밍 불일치로 인한 불안전성의 문제가 있었습니다.

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



