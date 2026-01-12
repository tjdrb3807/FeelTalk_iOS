# 필로우톡(FeelTalk)
![FeelTalk_ProfileImage](./image/FeelTalk_Profile.png)

## 👋 Introduce
💞 “자기는 이런게 좋아?”, “저런게 좋아?” 여러분은 연인과 이런 대화를 자주 나누시나요?   
가장 가까운 사이이지만, 깊은 대화를 나누기 어려워하는 연인들이 많다고 합니다.   
우리 앱은 **연인들이 스킨십에 대한 속깊은 이야기를 나눌 수 있도록 돕는 서비스** 입니다.

<br>

## 📱 Screen
### 1. 회원가입 & 로그인
![회원가입 플로우](./image/FeelTalk_SignUp_Flow.png)
* 필로우톡은 소셜 로그인 기반 인증 구조를 사용하여 로그인과 회원가입을 하나의 플로우로 통합했습니다. 인증 성공 시 사용자 존재 여부에 따라 계정을 생성하거나 로그인 처리하여 초기 진입 과정을 단순화했습니다.
* 성인 대상 서비스 특성상 휴대폰 본인 인증을 필수 단계로 포함하고 있으며, 인증 상태에 따라 화면 전환 및 다음 단계 접근을 제어합니다.
* 본인 인증 이후에는 닉네임을 설정하고, 커플 서비스 특성을 반영한 코드 기반 사용자 연결 구조를 제공합니다.

### 2. 시그널 전송
![시그널 전송 플로우](./image/FeelTalk_Signal_Flow.png)
* 시그널 전송은 사용자의 현재 기분 상태를 상대방에게 전달하고, 서로의 상태를 간단하게 확인할 수 있도록 설계된 핵심 서비스입니다.
* 사용자는 자신의 시그널을 선택할 수 있으며, 선택된 시그널은 서버에 저장되어 커플로 연결된 상대방에게 전달됩니다.

### 3. 오늘의 질문
![오늘의 질문 플로우](./image/FeelTalk_Question_Flow.png)
* 오늘의 질문은 커플 간 대화를 자연스럽게 유도하기 위해 매일 새로운 질문을 랜덤하게 제공하는 커뮤니케이션 기능입니다.
* 사용자는 질문에 대한 답변을 작성하고, 답변은 커플 관계로 연결된 상대방과 공유됩니다.
* 상대방이 아직 답변하지 않은 경우, ‘꼭 찌르기’ 기능을 통해 가벼운 방식으로 응답을 요청할 수 있습니다.

### 4. 첼린지
![챌린지 플로우](./image/FeelTalk_Challenge_Flow.png)
* 챌린지 등록은 커플이 함께 목표를 설정하고, 일정 기간 동안 이를 공유·실천할 수 있도록 지원하는 서비스입니다.
* 사용자는 챌린지를 직접 생성하고, 진행 중 / 완료 상태에 따라 목록을 구분해 관리할 수 있습니다.
* 완료된 챌린지는 히스토리 형태로 확인할 수 있어, 커플 간의 공동 경험 기록으로 기능하도록 설계했습니다

### 5. 화면잠금
![화면잠금 플로우](./image/FeelTalk_LockScreen_Flow.png)
* 화면 잠금은 커플 서비스 특성상 발생할 수 있는 민감 정보 노출을 방지하기 위한 보안 기능입니다.
* 잠금 활성화 시 앱 진입 또는 포그라운드 전환 시 비밀번호 입력을 요구하여 개인정보를 보호합니다.
* 비밀번호 분실 상황을 대비해 보안 질문 기반 비밀번호 재설정 기능을 제공합니다.

### 6. 탈퇴 & 헤어지기
![탈퇴&헤어지기 플로우](./image/FeelTalk_Withdrawal_BreakUp_Flow.png)
* 필로우톡은 계정 탈퇴와 커플 관계 해제(헤어지기)를 분리하여 제공합니다.
* 탈퇴 시 사용자 계정 및 관련 데이터가 삭제되며 복구할 수 없습니다.
* 헤어지기는 계정을 유지한 채 커플 관계만 해제하는 기능으로, 관계 해제 전 데이터 처리 범위를 명확히 안내합니다.

<br>

## 🛠️ Tech Stack
| **category** | **techStack** |
| --- | --- |
| **language** | ![Badge](https://img.shields.io/badge/swift5.x-F05138?style=for-the-badge&logo=swift&logoColor=white) |
| **dependencyManagement** | ![Badge](https://img.shields.io/badge/cocoaPods-FA2B59?style=for-the-badge&logo=cocoapods&logoColor=white) |
| **versionControl** | ![Badge](https://img.shields.io/badge/gitHub-181717?style=for-the-badge&logo=github&logoColor=white), ![Badge](https://img.shields.io/badge/git-F05033?style=for-the-badge&logo=git&logoColor=white) |
| **architecture** | ![Badge](https://img.shields.io/badge/cleanArchitecture-FFD93D?style=for-the-badge), ![Badge](https://img.shields.io/badge/mvvm-4CAF50?style=for-the-badge), ![Badge](https://img.shields.io/badge/coordinator-0066FF?style=for-the-badge) |
| **uiFramework** | ![Badge](https://img.shields.io/badge/uiKit-2396F3?style=for-the-badge&logo=apple&logoColor=white) |
| **reactiveProgramming** | ![Badge](https://img.shields.io/badge/rxSwift-B7178C?style=for-the-badge), ![Badge](https://img.shields.io/badge/rxDataSources-FF006E?style=for-the-badge), ![Badge](https://img.shields.io/badge/rxKeyboard-9B5DE5?style=for-the-badge), ![Badge](https://img.shields.io/badge/rxGesture-FF6F00?style=for-the-badge) |
| **layout** | ![Badge](https://img.shields.io/badge/snapKit-0E8E9A?style=for-the-badge) |
| **networking** | ![Badge](https://img.shields.io/badge/alamofire-FF5733?style=for-the-badge) |
| **oauthProviders** | ![Badge](https://img.shields.io/badge/kakao-FFEB00?style=for-the-badge), ![Badge](https://img.shields.io/badge/naver-03C75A?style=for-the-badge), ![Badge](https://img.shields.io/badge/google-4285F4?style=for-the-badge&logo=google&logoColor=white), ![Badge](https://img.shields.io/badge/apple-000000?style=for-the-badge&logo=apple&logoColor=white) |
| **pushNotification** | ![Badge](https://img.shields.io/badge/fcm-F57C00?style=for-the-badge&logo=firebase&logoColor=white) |
| **secureStorage** | ![Badge](https://img.shields.io/badge/keychain-005BBB?style=for-the-badge) |

<br>

## 📐 Architecture
![아키텍처 다이어그램](./image/FeelTalk_Architecture.png)

### Clean Architecture
* Presentation / Domain / Data 계층을 분리하여 책임을 명확히 구분했습니다.
* 비즈니스 규칙은 Domain 계층에 위치하며, UI 및 네트워크 변경에 영향을 받지 않도록 설계했습니다.
* Repository는 Domain 계층에서 프로토콜로 정의하고, Data 계층에서 구현함으로써 의존성 역적을 적용했습니다.

### MVVM + RxSwift
* 화면 로직과 비즈니스 로직 분리를 위해 MVVM 패턴을 적용했습니다.
* View는 사용자 이벤트를 전달하고, ViewModel은 상태를 생성하여 단방향 데이터 흐름을 유지합니다.
* RxSwift를 활용해 비동기 이벤트를 단일 스트림 기반으로 관리하고, UI 상태 변경을 일관될 방식으로 처리했습니다.
* 기술 블로그
  * 🔗 [FeelTalk-MVVM 패턴 도입기(with RxSwift)](https://tjdrb3807.github.io/study/ios/2025-12-23-iOS_FeelTalk_MVVM01/)
  * 🔗 [FeelTalk-MVVM 패턴 설계 전략(Input-Output)](https://tjdrb3807.github.io/study/ios/2025-12-23-iOS_FeelTalk_MVVM02/)
  * 🔗 [FeelTalk-MVVM 패턴 리팩토링)](https://tjdrb3807.github.io/study/ios/2025-12-23-iOS_FeelTalk_MVVM03/)

### Coordinator Pattern
* 화면 전환(Flow) 로직을 ViewController에서 분리하기 위해 Coordinator 패턴을 적용했습니다.
* 인증 플로우와 메인 서비스 플로우를 분리하여 사용자 상태에 따른 화면 전환을 관리합니다.
* 각 기능 흐름은 독립적인 Coordinator에서 관리되어 ViewController 간 의존성을 최소화했습니다.


