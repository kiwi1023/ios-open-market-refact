# My Market 🏪 (MVC)
> 프로젝트 기간: 2022-11-10 ~ 2022-12-02

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

## 📱 프로젝트 실행화면
|메인화면 (배너뷰)|무한스크롤|UISearch Bar 구현
|-|-|-|
![](https://i.imgur.com/YNCvTrG.gif)|![](https://i.imgur.com/IetZB5q.gif)|![](https://i.imgur.com/XsmOkXR.gif)
|상품 등록|상품 수정|상품 삭제
![](https://i.imgur.com/lG54iB0.gif)|![](https://i.imgur.com/LYpv4HT.gif)|![](https://i.imgur.com/9CXdCm6.gif)

## 🚀트러블 슈팅

### 
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

###
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


### 
<details>
    
<summary>UITextView의 크기가 늘어나지 않는 문제</summary>
    
<img src="https://i.imgur.com/KXhDRWW.png" width="250" height="500"/>
    
UITextView가 속한 StackView의 bottomAnchor를 ScrollView의 bottomAnchor와 constraint를 같게 맞추어 주었음에도 늘어나지 않는 문제가 발생했다.
    
<img src="https://i.imgur.com/m9ZM32G.png" width="250" height="500"/>
    
위 view Hierarchy에서 보듯 StackView의 크기 자체가 늘어나지 않는 것을 확인했다. 세로로 스크롤이 되어야하는 특성을 주어야하기 때문에 StackView의 topAnchor, bottonAnchor를 contentLayoutGuide에 constraint한 것이 문제가 되었다고 판단했다.
따라서, StackView의 heightAnchor를 지정해주어 해결했다.
    
</details>

### 
<details>
    
<summary> 배너 뷰의 이미지가 무한 반복하도록 구현하는 방법
    
</summary>

이미지의 마지막 인덱스에서 다시 처음 인덱스로 넘어가는 로직에 대해서 고민하였다.  

![](https://i.imgur.com/4DsUbs4.png)
    
해결 방법으로는 첫번째 이미지 및 마지막 이미지에 이미지 뷰를 추가한다음 해당 이미지 뷰에 다음에 올 이미지를 추가해주고 그 이미지가 화면에 나올때 scrollView의 contentOffset을 해당 이미지의 원래 위치로 이동시킨다. 그렇게 되면 사용자입장에서는 이질감을 느끼지 않고 무한 스크롤이 된다는 착각을 하게 된다.  
    
</details>
    
### 
<details>
    
<summary> 
   화면 이동간의 리스트 셀 위치 이동 문제
</summary>
    
리스트 뷰의 특정위치에서 특정 셀에 대한 수정이나, 삭제가 이루어질때 해당 작업이후 다시 셀로 돌아 올때 위치가 변경되는 문제가 있었다.
    
![](https://i.imgur.com/JsVv7AR.png)
    
![](https://i.imgur.com/XTxLFME.png)

화면이동간에 해당 셀의 indexPath 값을 할당 받은다음 할당 받은 indexPath 위치로 스크롤해주었다.
	
</details>
    
### 
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
    
