## 🙌 소개
- 요리도감은 요리 레시피를 공유 및 소통할 수 있는 커뮤니티 서비스입니다.
- 디자인부터 개발 그리고 심사까지 모두 혼자서 작업한 개인 프로젝트입니다.

</br>

## ✨ 주요 기능
|카테고리 별 레시피 리스트|좋아요 기능|댓글 및 답글 기능|
|---|---|---|
|<img height ="500" src="https://github.com/jihojivenchy/CookBook/assets/99619107/8510ef5f-5666-4370-813b-9dd019b4abdd">|<img height ="500" src="https://github.com/jihojivenchy/CookBook/assets/99619107/a245977b-03cb-44a5-9682-576271b49ebc">|<img height ="500" src="https://github.com/jihojivenchy/CookBook/assets/99619107/ee8df8bf-6199-4f33-8a8e-486ccd031ea9">

</br>

## 📱앱스토어
- [요리도감](https://apps.apple.com/kr/app/요리도감/id1644290667)

</br>

## 🛠️ 기술
### iOS
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Swift-FF6C22?style=for-the-badge&logo=Swift&logoColor=FFFFFF"/></a>
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/UIkit-2396F3?style=for-the-badge&logo=UIkit&logoColor=FFFFFF"/></a>
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Firebase-FFFBF5?style=for-the-badge&logo=firebase&logoColor=FF9843"/></a>
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/KingFisher-3B66BC?style=for-the-badge&logo=librarything&logoColor=FFFFFF"/></a>

### UI/UX Tool
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Snapkit-FF90BC?style=for-the-badge&logo=librarything&logoColor=FFFFFF"/></a>

### Design Pattern
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/MVC-7FC7D9?style=for-the-badge&logo=instructure&logoColor=FFFFFF"/></a>

</br>

### 📌 Snapkit

#### 학습
- Snapkit의 제약조건 메서드를 통해 다양한 화면 크기에 대응하는 동적인 레이아웃을 구성하는 방법을 학습
- 뷰의 계층 구조를 이해하고, UIKit에서 제공하는 다양한 뷰 컴포넌트를 적절히 배치하고 설정하는 방법에 대해 학습

</br>

### 📌 KingFihser

#### 사용 이유
- 이미지 다운로드 작업(네트워킹)을 최소화하여 사용자 경험을 개선하기 위해

#### 학습
-  Kingfisher의 캐시 정책을 API를 유연하게 사용하여 한정된 자원을 효율적으로 사용하는 방법을 학습
- 리사이징과 다운샘플링의 차이를 이해하기 위해 이미지의 메모리 관련 [WWDC](https://developer.apple.com/videos/play/wwdc2018/416/)를 학습
- 리사이징: 원본 이미지를 메모리에 완전히 로드한 후, 이미지의 크기를 조절
- 다운샘플링: 원본 이미지를 메모리에 로드하기 전, 필요한 사이즈로 픽셀을 최소화하여 처리 후 저장(메모리 효율성 증가)
- [KingFisher 정리](https://iosjiho.tistory.com/123)

</br>

### 📌 MVC
#### 사용 이유
- ViewController에 모든 코드를 때려박던 나의 어리석음을 깨닫고 디자인 패턴을 적용

#### 성과
- 분리된 관심사: MVC로 책임을 분리함으로써 코드의 재사용성, 가독성, 유지보수 모두 향상

</br>

### 📝 어려웠던 점
- 추천 레시피의 이미지를 멋있게 보여주기 위해 일정 시간 간격으로 무한히 돌아가는 Carousel UI를 구현.
- 아직 UICollectionView에 관련 API도 미숙한 상황에서 UIScrollViewDelegate를 사용하여, 특정 셀의 좌표를 계산하는 등의 작업을 하는 것에 혼란을 느낌.
- 먼저 UIScrollViewDelegate의 API들에 대한 실행 순서를 파악 후 이동할 좌표를 계산하는 방법에 대해 학습
- 추가로 특정 인덱스의 셀부터 시작하고자 할 때, scrollToItem을 사용하는 데 viewDidLoad 시점에 호출하면 작동되지 않음.
- 원인은 뷰의 라이프 사이클과 UICollectionView의 렌더링 시점의 오차로 인한 문제였고, viewDidLayoutSubViews 시점에 호출하여 해결

</br>

###  🔧 보완
- GitHub와 Git의 사용이 너무나도 미숙하기 때문에 Git의 다양한 명령어에 대해 학습하고, 익숙해지자.
- 어떤 작업을 할 것인지 미리 그려보고, 깔끔하게 커밋 단위를 나누어서 구현해보자.
- 공식문서와 WWDC를 확인하자.

</br>
