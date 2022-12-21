# Tribble

외국인 여행객 일정 플래너 및 이벤트 별 매칭 플랫폼 서비스를 제공하는 애플리케이션입니다.

---
## 0. 스크린 샷

<img src="https://user-images.githubusercontent.com/66731007/208090748-f1576a0d-f927-4ad3-afb7-0cffc4df8f0b.jpg" width="200" height="500"/> <img src="https://user-images.githubusercontent.com/66731007/208091846-929fd948-4029-4dd0-9d0d-e5c545092f91.jpg" width="200" height="500"/> <img src="https://user-images.githubusercontent.com/66731007/208092043-56bcaca5-9691-4fca-9eec-0e31ce81f2ef.jpg" width="200" height="500"/> <img src="https://user-images.githubusercontent.com/66731007/208090910-afb41baa-ed26-4f89-8e6f-0bf390b68668.jpg" width="200" height="500"/>


---
## 1. 프로젝트 소개
우선 저희는 엔데믹이 다가오면서 높아진 여행 수요와 대중문화의 세계화 등으로 증가하는 외국인 관광객 수에 주목했습니다. 각종 통계자료와 외국인 유학생 대상으로 설문조사를 진행하고 분석한 후에, 여행객들에게 불편함이 존재하는 것을 발견했습니다. 그것은 바로, 여행객들은 여행 계획을 자기 마음대로 자유롭게 짤 수 있으면서 여유로운 개별 여행을 하고 싶지만, 그러면 로컬적인 경험을 하기 힘들고 언어소통과 같은 부분에서 어려움이 있다는 것이었습니다. 다른 불편함으로는 여행 일정을 계획하는 것에 시간이 많이 든다는 점이 있었습니다. 그래서 저희는 자유여행의 장점을 살리면서도 이러한 문제들을 해결하는 것에 초점을 두었습니다. 기존의 가이드 여행 방식에서는 가이드가 일정을 만들고 여행객은 수동적으로 그 일정 중에서 선택하는 방식이었습니다. 이는 여행 시 가이드의 일정을 그대로 따라가야만 하므로 자유여행의 이점이 전혀 없었습니다. 반면 저희는 여행객 중심이어서 유저 맞춤 일정 작성이 가능한데, 자동 여행일정 추천을 통해 외국인 입장에서는 한국이 낯설기 때문에 어려울 수 있는 여행 일정 작성을 도와줄 수 있습니다. 특히 취향 및 선호도 입력을 통해 입력된 취향에 가중치를 추가한 TSP 알고리즘과 그리디 추천 알고리즘을 이용하여 여행 일정에 자동으로 이벤트를 포함시키는 취향 기반의 여행 일정 추천 기능을 제공하여 사용자 맞춤 여행 일정 추천 제공이 가능합니다. 이러한 방식으로 자유 여행의 장점을 살리면서 단점을 해결했습니다. 또 기존의 장소 중심 일정을 각 가이드의 로컬적인 컨텐츠가 있는 이벤트 중심의 일정으로 시선을 바꾸면서 차별점을 두었습니다.

---
## 2. 프로젝트 설치 및 실행 방법
프로젝트와 함께 업로드 된 'Tribble.apk'를 Android 모바일 기기에 내려받고 설치한 후, 실행합니다.

프로젝트에 기여하기 위해서는, 크로스 플랫폼 프레임워크 Flutter를 설치하고, Android Studio 혹은 Visual Studio Code에서 프로젝트 소스코드에 접근할 수 있습니다.

---
## 3. 프로젝트 사용 방법
### 당신이 가이드인 경우,
  #### a. 먼저, 회원가입과 로그인을 진행합니다.
<img src="https://user-images.githubusercontent.com/66731007/208092724-e90b68cf-6377-41d5-b268-5879a58be9fa.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208092810-7a102ac4-d3e7-4a01-89fc-fccb4434a893.jpg" width="160" height="400"/>
  #### b. 한국인인 가이드는 자신이 가이드를 할 수 있는 여행 일정 단위인 이벤트를 작성할 수 있습니다. 가이딩을 할 장소를 설정하고 가이딩할 이벤트의 성격에 적합하도록 유형들과 해시태그를 적절히 달아주고 등록합니다. 등록이 완료되면, DB에 이벤트가 등록되어 외국인 여행객이 이벤트를 검색하거나 자동 일정 추천에 사용할 수 있게 됩니다.
<img src="https://user-images.githubusercontent.com/66731007/208093610-068f7960-1895-46aa-acb7-3730a7a46720.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208093745-e201f97b-3115-412f-8295-ad00b20c6748.jpg" width="160" height="400"/>
  #### c. 등록된 이벤트는 나의 이벤트 창에서 확인할 수 있습니다.
<img src="https://user-images.githubusercontent.com/66731007/208094199-99e89145-3be9-4a15-ad3c-9ec548c88ef9.jpg" width="160" height="400"/>    


### 당신이 트리블러인 경우,
  #### a. 먼저, 회원가입과 로그인을 진행합니다.
<img src="https://user-images.githubusercontent.com/66731007/208094579-4b94566f-560b-4241-b552-4f36f3ade1a3.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208091846-929fd948-4029-4dd0-9d0d-e5c545092f91.jpg" width="160" height="400"/>
  #### b.  외국인인 트래블러는 자신만의 여행 일정을 빌드하기 위해, Make My Own Tour 버튼을 눌러서 이벤트를 위치 및 키워드 기반으로 검색 후 직접 조합할 수 있습니다. 여행할 장소를 설정하고 여행 예정 시간을 설정한 뒤 검색하게 되면 검색 장소 반경 1km내의 이벤트들이 검색되어 보여집니다.
<img src="https://user-images.githubusercontent.com/66731007/208094881-9e5e2407-963e-49db-9c95-1ec1ee6d6f87.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208095053-5d5e601f-d931-44a8-8485-1eb56c99644e.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208095103-eebf125d-958d-4038-a9ae-65503bcb8295.jpg" width="160" height="400"/>
  #### c. 검색된 이벤트들을 투어에 넣어서 자신만의 여행 일정을 만들 수 있습니다. 각 이벤트마다 가이드를 요청하거나 요청하지 않을 수 있습니다.
<img src="https://user-images.githubusercontent.com/66731007/208095134-2dfcb860-c655-4f68-ab8d-f702ddcb7471.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208095183-9f12a134-a017-4317-b882-fe3bc46037aa.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208095240-5d249c90-9ee8-4edc-ba2f-d89233b796a0.jpg" width="160" height="400"/>
  #### d. 또한  Get Recommendation 버튼을 눌러서 취향 기반의 자동 일정 추천을 받을 수 있습니다. 선호하는 여행 취향을 고른 뒤 검색하면 네 가지의 추천 일정이 제공됩니다. 추천 일정에는 가장 인기 있는 투어와 먹거리 투어 등이 제공되어서, 주어진 추천 일정 중에서 원하는 일정을 선택할 수 있습니다. 각 투어에는 자신이 고른 여행 취향이 적절히 반영된 일정으로 제공됩니다. 추천된 일정 속 이벤트들 중 마음에 들지 않는 이벤트가 있다면, 마커를 터치하여 삭제가 가능합니다. 각 이벤트마다 가이드를 요청하거나 요청하지 않을 수 있습니다.
<img src="https://user-images.githubusercontent.com/66731007/208094881-9e5e2407-963e-49db-9c95-1ec1ee6d6f87.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208096507-17093c22-fb25-42c9-864f-c89a22ad986a.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208096579-c0e8e9aa-e318-4fdf-af66-5b19747521fb.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208096648-8fe7f371-1f26-47d4-81e8-042256dc5e25.jpg" width="160" height="400"/> <img src="https://user-images.githubusercontent.com/66731007/208097841-60f4d36d-1afa-4cf8-9f55-bc566cdf0ef8.jpg" width="160" height="400"/>
  #### e. 자신만의 일정을 빌드한 뒤 컨펌하게 되면, DB에 투어가 등록되어 나의 투어에서 확인할 수 있습니다.
<img src="https://user-images.githubusercontent.com/66731007/208097369-4f0908a3-84fe-4f46-8f95-fe3333021e32.jpg" width="160" height="400"/>

#### f. 각 이벤트 별 가이드에게 채팅으로 세밀한 일정 조정이 가능합니다.
<img src="https://user-images.githubusercontent.com/66731007/208099265-d69a6e02-6e27-4962-8921-be5bc091ff0b.jpg" width="160" height="400"/>
   
---
## 4. Team (Contributors)
Team Tribbler, 중앙대학교 소프트웨어학부 3학년

|                            [김상민](https://github.com/nstar1125)                             |                          [이동화](https://github.com/tjdrhr02)                           |                          [한동민](https://github.com/han-0315)                           |
| :----------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------: |
|                                     Backend(Recommendation Algorithm) + Frontend                                     |                                       Backend(Event Management, Map) + Frontend                                        |                                     Backend(Chat) + Frontend                                     |

###### 2022-2 Capstone Design(1)
