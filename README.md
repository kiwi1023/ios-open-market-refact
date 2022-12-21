# My Market 🏪 (MVVM + UIKit)
> <프로젝트 기간>

- MVC: 2022-11-10 ~ 2022-12-02 
- MVVM: 2022-12-05 ~ 2022-12-20

## 팀원

[송기원](https://github.com/kiwi1023), [유한석](https://github.com/yusw10), [이은찬](https://github.com/apwierk2451)

## 📝 프로젝트 소개

**서버와의 네트워킹을 통해 상품을 등록, 수정, 삭제가 가능한 나만의 마켓**

## 🔑 키워드

- `UIKit`
- `Network`
- `URLSession Mock Test`
- `Json Decoding Strategy`
- `NSCache`
- `XCTestExpection`
- `completionHandler`
- `Escaping Closure`
- `URLSession`
- `RefreshController`
- `Test Double`
- `UICollectionView`
    - `DiffableDataSource`
    - `CompositionalLayout`
- `MVVM`
- `delegate`
- `Observable`

## 📱 프로젝트 실행화면
|메인화면 (배너뷰)|무한스크롤|UISearch Bar 구현
|-|-|-|
![](https://i.imgur.com/YNCvTrG.gif)|![](https://i.imgur.com/IetZB5q.gif)|![](https://i.imgur.com/XsmOkXR.gif)
|상품 등록|상품 수정|상품 삭제
![](https://i.imgur.com/lG54iB0.gif)|![](https://i.imgur.com/LYpv4HT.gif)|![](https://i.imgur.com/9CXdCm6.gif)

## 🚀트러블 슈팅



### MVC 

<details>
<summary>Launch Screen 이슈</summary>
    
초기 CollectionView를 설정하면서 화면을 확인해보았는데 다음과 같이 상하단의 영역이 잘려서 나오는걸 확인할 수 있었다.
    
<img src=https://i.imgur.com/xdtPbDP.png width=40%>
    
CollectionView의 각 anchor를 메인 View Controller의 View의 safeAreaLayoutGuide에 맞춰주지 않았다고 생각되어 뷰 계층 창을 보았는데 오히려 뷰 계층상에서는 전혀 문제가 없었다.
    
<img src=https://i.imgur.com/vhbb1HH.png width=40%>

잘렸다기 보다는 아예 window자체가 작게 잡혀있다는 것에 가까운 형태였다. 
    
<img src=https://i.imgur.com/9z4bjck.png width=50%>
    
문제는 예상 하지 못한곳에서 발생하고 있었다. 
프로젝트의 UI를 코드기반으로 변경하면서 기본으로 생성되는 스토리보드 파일들을 모두 제거하는 과정을 거쳤다.

그 과정 중에 LaunchScreen을 생성하는 옵션을 껐는데 이 옵션을 꺼버리니 위와 같이 window 자체가 작게 잡혔다.

이 옵션을 다시 킴으로써 문제를 해결할 수 있었지만, 정확히 어떤 원리로 이와같이 동작되었는지 관련 글이 부족해서 알 수 없었다...(런치 스크린을 설정하는 방법의 글이 주류였다)
    
다만 예상해보자면, SceneDelegate에서 윈도우를 인스턴스화 하는 과정에서 기존에는 런치스크린이 화면 전체 크기에 맞게 최상위 Frame을 잡고 이를 기반으로 window크기가 잡혀왔지만, 우리의 코드에서는 이 과정이 생략되어서 컨텐츠 최소 크기대로 윈도우가 설정된것으로 추측했다. 아마도 SceneDelegate에서 Scene을 생성시에 윈도우 크기를 스크린 크기로 지정해준다면 윈도우 크기가 의도한 대로 나오지 않을까 싶다.


</details>

</br>

<details>
    
<summary> 상품 목록 화면이동시 서치바가 보여지도록 수정 </summary>
    
상품 목록 화면으로 진입시 다음과 같이 서치바가 보여지도록 설정하고자 했다.
    
<img src=https://i.imgur.com/S5HlxtC.png width=50%>
    
이를 NavigationItem의 `hidesSearchBarWhenScrolling` 속성을 통해 지정하고자 했는데 뷰 진입시 서치바가 보이게 하기 위해 이 속성을 false로 하면 스크롤시 자연스럽게 사라지지 않았다.
    
따라서 뷰 최초 진입하여 ViewWillAppear시에 이를 해제하여 서치바가 나오게 하고 스크롤링이 시작될 때 true로 바꿔 서치바가 자연스럽게 네비게이션 아이템에 적용되어 스크롤하면 사라지도록 하였다. 


</details>

###

<details>
    <summary>이미지 캐시 싱글톤 객체 </summary>
    
    상품 리스트 뷰에서 이미지를 로드하기 위해 DataTask 작업을 UIImageView의 extension으로 확장하여 사용하고 있었다. 
    
```swift
extension UIImageView {
    func setImageUrl(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
```
    
다만 작업중 다음과 같은 문제를 생각했다.
    1. 데이터를 load하기 위해 dataTask코드를 현재 확장하고있는데 모든 UIImageView가 데이터를 로드하는게 아니다.

따라서 기존의 모든 UIImageView를 대상으로 확장하는 방식에서 UIImageView를 상속받는 새로운 데이터 타입을 만들었다.

    
```swift
final class DownloadableUIImageView: UIImageView {
    var dataTask: URLSessionDataTask?
    
    func setImageUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        self.image = UIImage()
        self.dataTask = URLSession.shared.dataTask(with: url) { (data, result, error) in
            guard error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage()
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                }
            }
        }
        self.dataTask?.resume()
    }
    
    func cancelImageDownload() {
        dataTask?.cancel()
        dataTask = nil
    }
}
```
    
그러나 이 부분에서도 좀 더 근본적인 고민을 하게 되었다. "과연 UIImageView가 네트워크 통신 코드를 소유하는게 맞을까? UIImageView는 말 그대로 UI에 쓰이는 이미지 뷰 관련 코드만 소지해야하지 않을까?" 

결국 캐싱 작업을 추가하면서 UIImageView에서 네트워크 통신 코드를 분리하는 작업을 한번 더 수행했다.
    
```swift
    
final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var waitingRespoinseClosure = [NSURL: [(UIImage) -> Void]]()
    private var dataTasks = [NSURL: URLSessionDataTask]()
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        if waitingRespoinseClosure[url] != nil {
            return
        } else {
            waitingRespoinseClosure[url] = [completion]
        }
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.waitingRespoinseClosure[url], error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
            }
            return
        }
        dataTasks[url] = task
        dataTasks[url]?.resume()
    }
    
    func cancel(url: NSURL) {
        dataTasks[url]?.cancel()
        dataTasks[url] = nil
        dataTasks.removeValue(forKey: url)
        waitingRespoinseClosure[url] = []
        waitingRespoinseClosure.removeValue(forKey: url)
    }
}

```
    
캐시에 존재하는 이미지라면 네트워크 요청을 취소하도록 하고, 동일한 URL의 이미지라도 현재 네트워크 요청 중인지, 완료하여 캐시에 존재하는지 등 각각의 경우마다 중복 작업을 피하도록 설계해보았다. 각 URL 에 따라 데이터 태스크, 완료시 클로저, 캐시를 두었다.
    
</details>

</details>
    
###

<details>
    
<summary>UITextView의 크기가 늘어나지 않는 문제</summary>
    
<img src="https://i.imgur.com/KXhDRWW.png" width="250" height="500"/>
    
UITextView가 속한 StackView의 bottomAnchor를 ScrollView의 bottomAnchor와 constraint를 같게 맞추어 주었음에도 늘어나지 않는 문제가 발생했다.
    
<img src="https://i.imgur.com/m9ZM32G.png" width="250" height="500"/>
    
위 view Hierarchy에서 보듯 StackView의 크기 자체가 늘어나지 않는 것을 확인했다. 세로로 스크롤이 되어야하는 특성을 주어야하기 때문에 StackView의 topAnchor, bottonAnchor를 contentLayoutGuide에 constraint한 것이 문제가 되었다고 판단했다.
따라서, StackView의 heightAnchor를 지정해주어 해결했다.
    
</details>

</br>

<details>
    
<summary> 배너 뷰의 이미지가 무한 반복하도록 구현하는 방법
    
</summary>

이미지의 마지막 인덱스에서 다시 처음 인덱스로 넘어가는 로직에 대해서 고민하였다.  

![](https://i.imgur.com/4DsUbs4.png)
    
해결 방법으로는 첫번째 이미지 및 마지막 이미지에 이미지 뷰를 추가한다음 해당 이미지 뷰에 다음에 올 이미지를 추가해주고 그 이미지가 화면에 나올때 scrollView의 contentOffset을 해당 이미지의 원래 위치로 이동시킨다. 그렇게 되면 사용자입장에서는 이질감을 느끼지 않고 무한 스크롤이 된다는 착각을 하게 된다.  
    
</details>
    
</br>

<details>
    
<summary> 
   화면 이동간의 리스트 셀 위치 이동 문제
</summary>
    
리스트 뷰의 특정위치에서 특정 셀에 대한 수정이나, 삭제가 이루어질때 해당 작업이후 다시 셀로 돌아 올때 위치가 변경되는 문제가 있었다.
    
![](https://i.imgur.com/JsVv7AR.png)
    
![](https://i.imgur.com/XTxLFME.png)

화면이동간에 해당 셀의 indexPath 값을 할당 받은다음 할당 받은 indexPath 위치로 스크롤해주었다.
    
</details>
    
</br>

<details>
    
<summary> 
   RegistView Image 삭제하는 방법
</summary>
    
CollectionView로 이미지 추가만 구현한 상태에서 "X"버튼을 만들어 삭제를 구현해야됐다.
각 Cell에 구현된 "X"버튼에 액션을 넣는 방법에서 문제가 발생했다.
삭제 버튼을 누른 index를 구할 수 없었다.
왜냐하면 DiffableDataSource를 사용하고 있었기 때문이다. DiffableDataSource는 indexPath가 아닌 지정된 타입으로 알기 때문에 index를 이용하는 것은 DiffableDataSource의 특징을 이용하지 못한다고 생각했다.
그래서 각 Cell을 지정할 때 클로저를 이용하여 Action을 넣어주기로 했다.

```swift
let cell = UICollectionView.CellRegistration<ProductRegistCollectionViewCell, UIImage> { cell, indexPath, item in
    cell.removeImage = {
        self.deleteDataSource(image: item)
    }
    cell.configureImage(data: item)
}
```
    위 코드와 같이 각 cell에 item을 지정할 때 그 item을 dataSource에서 지우는 action을 클로저로 이용하여 넘겨주게 된다.
```swift
@objc private func didTapRemoveButton() {
    removeImage?()
}
    
```
    
위 코드와 같이 각 Cell에 지정된 "X"버튼 action에 클로저를 추가해주어 Delete기능을 구현했다.

    </details>
</details>

    

---

### MVVM

<details>
    
<summary> Observable 타입의 설정 
</summary>
        
이벤트 흐름을 단방향으로 처리하기 위해 초반에 클로저의 형태로 구현을 하였다. 하지만 이벤트의 갯수 만큼 뷰모델이 클로저와 데이터 모델을 소유하고 있어야 했기에 이를 합치는 개념이 필요했다. 
    
RxSwift의 Observable 타입을 참고하여 다음과 같이 리스너를 소유하는 커스텀 Observable 타입을 생성하여 이를 해결해보았다.
    
```swift 
    
class Observable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
    
```
    
이 Observable 타입을 활용함으로써 ViewModel에 Input과 Output으로 이벤트 입출력을 정리하고 최종적으로 View Controller에서 상태값이 변경되면 이에 대응되는 데이터모델을 클로저로 넘겨주어 RxSwift의 bindindg작업과 유사하게 UIKit만을 사용하여 구현할 수 있었다.
    
    
</details>
    

</br>

<details>
    
<summary> 뷰 모델의 Input에 어떤 값을 넣어야 할지에 대하여 </summary>

RxSwift의 경우 UIComponents에 rx를 이용하여 접근하고 이에 대한 이벤트 흐름을 이끌어 올 수 있다. 
다만 Pure MVVM을 목표로 개발을 하다보니 이 이벤트 흐름의 시작점이 어디에 위치할 것인가에 대해서 굉장히 고민을 많이 했다. 
    
Main ViewController의 경우 초기 데이터 로드만 불러오기 때문에 binding 작업에서 Observable 타입을 넘겨 주었다.
    
```swift
// MainViewController.swift
private func bind() {
    let miniListFetchAction = Observable<(InitialPageInfo)></(InitialPageInfo)>(MainViewControllerNameSpace.initialPageInfo)
    let output = mainViewModel.transform(input: .init(
        pageInfoInput: miniListFetchAction
    ))
    
    output.fetchedProductListOutput.subscribe { list in
        DispatchQueue.main.async {
            self.updateDataSource(data: list)
        }
    }
} 
    
```

하지만 상품 목록 뷰에서는 현재 불러온 페이지와 페이지당 아이템의 개수, 현재 상태가 update인지 혹은 add인지에 대해서 변화를 ViewController가 소유하고 있어야 해서 ViewController에 `pageState`라는 Observable타입을 프로퍼티로 소유하도록 하였다. 또한 SearchController를 통해 입력되는것도 필터링 값의 이벤트 변화로 연결하기 위해 Observable타입으로 만들었다.
    
```swift 
//ProductListViewController.swift
private let pageState = Observable<(
    pageNumber: Int,
    itemsPerPage: Int,
    fetchType: FetchType)
>((
    ProductListViewControllerNameSpace.initialPageInfo.pageNumber,
    ProductListViewControllerNameSpace.initialPageInfo.itemsPerPage,
    .update
))
    
private let filteringState = Observable<String>("")
    
```

이 프로퍼티 두가지를 뷰 모델의 transform 메서드를 통해 바인딩 작업을 거쳤다.

```swift
let output = productListViewModel.transform(input: .init(
    productListPageInfoUpdateAction: pageState,
    filteringStateUpdateAction: filteringState
))
```

    
</details>
    
</br>
<details>
<summary> 뷰모델의 에러 핸들링의 처리에 관하여</summary>

기존의 코드는 에러 핸들링이 네트워크 코드에 위임 되어 있었다. SessionProtocol로 부터 ResultType을 반환받아 이를 분기 처리하여 Completion Handler를 넘겨주는 방식이었다.
    
하지만 결과의 분기 처리 자체를 뷰 컨트롤러가 진행하게 되는 것 자체가 비즈니스 로직이라고 생각되었다. 또한 실패의 경우 AlertDirector를 통해 실패 내용을 출력 해야하는데 비즈니스 로직이 뷰모델로 이관되면서 에러 타입을 넘겨 받도록 구조를 짜야했다.
    
https://benoitpasquier.com/error-handling-swift-mvvm/
    
위 블로그를 참고하여 에러코드에 대해서 분리를 했다.
    
먼저 뷰모델 내부에 에러 핸들링을 실제로 진행 할 클로저를 선언하였다.
    
```swift
var onErrorHandling : ((APIError) -> Void)?
```

그리고 bind 메서드에서 실제 에러가 발생할 경우 띄워줄 AlertDirector를 호출하도록 하였다.
    
```swift
mainViewModel.onErrorHandling = { failure in 
    AlertDirector(viewController: self).createErrorAlert(
        message: MainViewControllerNameSpace.getDataErrorMassage
    )
}
```

뷰 모델에서는 에러의 분기 처리를 진행한다. success라면 Completion Handler를 호출하고, failure라면 ViewController로 부터 주입받은 클로저를 실행한다.
    
```swift
input.pageInfoInput.subscribe { (pageNumber: Int, itemsPerPage: Int) in
    self.fetchProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage) { (result: Result<[Product], APIError>) in
        switch result {
            case .success(let productList):
                fetchedProductListOutput.value = productList
            case .failure(let failure):
                self.onErrorHandling?(failure)
        }
    }
}
```
    
이렇게하여 ViewController는 실패시 동작해야할 View와 관련된 로직만을 소유하게 되고, ViewModel에서 에러 처리분기에 관련된 비즈니스 로직을 배치함과 동시에 View관련 작업은 하지 않도록 할 수 있었다.

</details>    

</br>

<details>
<summary>View Model 내부에 데이터의 형태</summary>

최초에 Input Output 구조를 작성할 때 뷰 모델 내부에 데이터를 배치시키지 않으려고 했다. ViewController의 상태 변화에 따른 비즈니스 로직을 거쳐 핸들링된 데이터를 넘겨주기만 하는 역할만을 뷰 모델에 부여하려했다. 

하지만 상품 목록의 경우 Search Controller로 부터 넘어오는 검색어의 상태변화에 따라 검색을 진행할 데이터가 필요했기에 결국 ProductListViewModel 내부에 `[Product]` 타입을 저장하게 되었다.
    
<img src=https://i.imgur.com/0luKtLW.png width=60%>

다만 dataSource 자체를 뷰 모델에 위치시키게 되면 이러한 문제를 해결할 수 있을것이라 생각했었는데 UIKit관련 모든 코드를 뷰 모델에서 선언하는것 자체가 모순이라 생각하여 이런식으로 작성하게 되었다.
    
    
</details>

</br>

<details>
<summary>RegistViewModel subscribe시 초기 실행 문제</summary>
    초기 값이 설정되고 값이 변경될 때마다 output을 이용하여 post, patch해야되는데, 초기 값으로도 post가 되는 문제가 발생했다.
    Enum 타입을 새로 만들어 초기에만 unUpdatable case를 넣어주어 초기에만 네트워킹을 하지 않는 방식으로 코드를 넣었지만 불필요한 타입이 추가되고, 필요한 데이터가 아닌 정보를 viewModel에 넘겨준다고 생각하였다.
    그래서 input에 들어가는 Observable의 RegistrationProduct타입을 옵셔널로 설정하여 nil일 경우 closure을 return하는 방식으로 넘기는 방식으로 해결했다.
</details>
