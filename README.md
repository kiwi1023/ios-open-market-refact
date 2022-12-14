# My Market ๐ช (MVVM + UIKit)
> <ํ๋ก์ ํธ ๊ธฐ๊ฐ>

- MVC: 2022-11-10 ~ 2022-12-02 
- MVVM: 2022-12-05 ~ 2022-12-20

## ํ์

[์ก๊ธฐ์](https://github.com/kiwi1023), [์ ํ์](https://github.com/yusw10), [์ด์์ฐฌ](https://github.com/apwierk2451)

## ๐ ํ๋ก์ ํธ ์๊ฐ

**์๋ฒ์์ ๋คํธ์ํน์ ํตํด ์ํ์ ๋ฑ๋ก, ์์ , ์ญ์ ๊ฐ ๊ฐ๋ฅํ ๋๋ง์ ๋ง์ผ**

## ๐ ํค์๋

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

## ๐ฑ ํ๋ก์ ํธ ์คํํ๋ฉด
|๋ฉ์ธํ๋ฉด (๋ฐฐ๋๋ทฐ)|๋ฌดํ์คํฌ๋กค|UISearch Bar ๊ตฌํ
|-|-|-|
![](https://i.imgur.com/YNCvTrG.gif)|![](https://i.imgur.com/IetZB5q.gif)|![](https://i.imgur.com/XsmOkXR.gif)
|์ํ ๋ฑ๋ก|์ํ ์์ |์ํ ์ญ์ 
![](https://i.imgur.com/lG54iB0.gif)|![](https://i.imgur.com/LYpv4HT.gif)|![](https://i.imgur.com/9CXdCm6.gif)

## ๐ํธ๋ฌ๋ธ ์ํ



### MVC 

<details>
<summary>Launch Screen ์ด์</summary>
    
์ด๊ธฐ CollectionView๋ฅผ ์ค์ ํ๋ฉด์ ํ๋ฉด์ ํ์ธํด๋ณด์๋๋ฐ ๋ค์๊ณผ ๊ฐ์ด ์ํ๋จ์ ์์ญ์ด ์๋ ค์ ๋์ค๋๊ฑธ ํ์ธํ  ์ ์์๋ค.
    
<img src=https://i.imgur.com/xdtPbDP.png width=40%>
    
CollectionView์ ๊ฐ anchor๋ฅผ ๋ฉ์ธ View Controller์ View์ safeAreaLayoutGuide์ ๋ง์ถฐ์ฃผ์ง ์์๋ค๊ณ  ์๊ฐ๋์ด ๋ทฐ ๊ณ์ธต ์ฐฝ์ ๋ณด์๋๋ฐ ์คํ๋ ค ๋ทฐ ๊ณ์ธต์์์๋ ์ ํ ๋ฌธ์ ๊ฐ ์์๋ค.
    
<img src=https://i.imgur.com/vhbb1HH.png width=40%>

์๋ ธ๋ค๊ธฐ ๋ณด๋ค๋ ์์ window์์ฒด๊ฐ ์๊ฒ ์กํ์๋ค๋ ๊ฒ์ ๊ฐ๊น์ด ํํ์๋ค. 
    
<img src=https://i.imgur.com/9z4bjck.png width=50%>
    
๋ฌธ์ ๋ ์์ ํ์ง ๋ชปํ๊ณณ์์ ๋ฐ์ํ๊ณ  ์์๋ค. 
ํ๋ก์ ํธ์ UI๋ฅผ ์ฝ๋๊ธฐ๋ฐ์ผ๋ก ๋ณ๊ฒฝํ๋ฉด์ ๊ธฐ๋ณธ์ผ๋ก ์์ฑ๋๋ ์คํ ๋ฆฌ๋ณด๋ ํ์ผ๋ค์ ๋ชจ๋ ์ ๊ฑฐํ๋ ๊ณผ์ ์ ๊ฑฐ์ณค๋ค.

๊ทธ ๊ณผ์  ์ค์ LaunchScreen์ ์์ฑํ๋ ์ต์์ ๊ป๋๋ฐ ์ด ์ต์์ ๊บผ๋ฒ๋ฆฌ๋ ์์ ๊ฐ์ด window ์์ฒด๊ฐ ์๊ฒ ์กํ๋ค.

์ด ์ต์์ ๋ค์ ํด์ผ๋ก์จ ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ  ์ ์์์ง๋ง, ์ ํํ ์ด๋ค ์๋ฆฌ๋ก ์ด์๊ฐ์ด ๋์๋์๋์ง ๊ด๋ จ ๊ธ์ด ๋ถ์กฑํด์ ์ ์ ์์๋ค...(๋ฐ์น ์คํฌ๋ฆฐ์ ์ค์ ํ๋ ๋ฐฉ๋ฒ์ ๊ธ์ด ์ฃผ๋ฅ์๋ค)
    
๋ค๋ง ์์ํด๋ณด์๋ฉด, SceneDelegate์์ ์๋์ฐ๋ฅผ ์ธ์คํด์คํ ํ๋ ๊ณผ์ ์์ ๊ธฐ์กด์๋ ๋ฐ์น์คํฌ๋ฆฐ์ด ํ๋ฉด ์ ์ฒด ํฌ๊ธฐ์ ๋ง๊ฒ ์ต์์ Frame์ ์ก๊ณ  ์ด๋ฅผ ๊ธฐ๋ฐ์ผ๋ก windowํฌ๊ธฐ๊ฐ ์กํ์์ง๋ง, ์ฐ๋ฆฌ์ ์ฝ๋์์๋ ์ด ๊ณผ์ ์ด ์๋ต๋์ด์ ์ปจํ์ธ  ์ต์ ํฌ๊ธฐ๋๋ก ์๋์ฐ๊ฐ ์ค์ ๋๊ฒ์ผ๋ก ์ถ์ธกํ๋ค. ์๋ง๋ SceneDelegate์์ Scene์ ์์ฑ์์ ์๋์ฐ ํฌ๊ธฐ๋ฅผ ์คํฌ๋ฆฐ ํฌ๊ธฐ๋ก ์ง์ ํด์ค๋ค๋ฉด ์๋์ฐ ํฌ๊ธฐ๊ฐ ์๋ํ ๋๋ก ๋์ค์ง ์์๊น ์ถ๋ค.


</details>

</br>

<details>
    
<summary> ์ํ ๋ชฉ๋ก ํ๋ฉด์ด๋์ ์์น๋ฐ๊ฐ ๋ณด์ฌ์ง๋๋ก ์์  </summary>
    
์ํ ๋ชฉ๋ก ํ๋ฉด์ผ๋ก ์ง์์ ๋ค์๊ณผ ๊ฐ์ด ์์น๋ฐ๊ฐ ๋ณด์ฌ์ง๋๋ก ์ค์ ํ๊ณ ์ ํ๋ค.
    
<img src=https://i.imgur.com/S5HlxtC.png width=50%>
    
์ด๋ฅผ NavigationItem์ `hidesSearchBarWhenScrolling` ์์ฑ์ ํตํด ์ง์ ํ๊ณ ์ ํ๋๋ฐ ๋ทฐ ์ง์์ ์์น๋ฐ๊ฐ ๋ณด์ด๊ฒ ํ๊ธฐ ์ํด ์ด ์์ฑ์ false๋ก ํ๋ฉด ์คํฌ๋กค์ ์์ฐ์ค๋ฝ๊ฒ ์ฌ๋ผ์ง์ง ์์๋ค.
    
๋ฐ๋ผ์ ๋ทฐ ์ต์ด ์ง์ํ์ฌ ViewWillAppear์์ ์ด๋ฅผ ํด์ ํ์ฌ ์์น๋ฐ๊ฐ ๋์ค๊ฒ ํ๊ณ  ์คํฌ๋กค๋ง์ด ์์๋  ๋ true๋ก ๋ฐ๊ฟ ์์น๋ฐ๊ฐ ์์ฐ์ค๋ฝ๊ฒ ๋ค๋น๊ฒ์ด์ ์์ดํ์ ์ ์ฉ๋์ด ์คํฌ๋กคํ๋ฉด ์ฌ๋ผ์ง๋๋ก ํ์๋ค. 


</details>

###

<details>
    <summary>์ด๋ฏธ์ง ์บ์ ์ฑ๊ธํค ๊ฐ์ฒด </summary>
    
    ์ํ ๋ฆฌ์คํธ ๋ทฐ์์ ์ด๋ฏธ์ง๋ฅผ ๋ก๋ํ๊ธฐ ์ํด DataTask ์์์ UIImageView์ extension์ผ๋ก ํ์ฅํ์ฌ ์ฌ์ฉํ๊ณ  ์์๋ค. 
    
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
    
๋ค๋ง ์์์ค ๋ค์๊ณผ ๊ฐ์ ๋ฌธ์ ๋ฅผ ์๊ฐํ๋ค.
    1. ๋ฐ์ดํฐ๋ฅผ loadํ๊ธฐ ์ํด dataTask์ฝ๋๋ฅผ ํ์ฌ ํ์ฅํ๊ณ ์๋๋ฐ ๋ชจ๋  UIImageView๊ฐ ๋ฐ์ดํฐ๋ฅผ ๋ก๋ํ๋๊ฒ ์๋๋ค.

๋ฐ๋ผ์ ๊ธฐ์กด์ ๋ชจ๋  UIImageView๋ฅผ ๋์์ผ๋ก ํ์ฅํ๋ ๋ฐฉ์์์ UIImageView๋ฅผ ์์๋ฐ๋ ์๋ก์ด ๋ฐ์ดํฐ ํ์์ ๋ง๋ค์๋ค.

    
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
    
๊ทธ๋ฌ๋ ์ด ๋ถ๋ถ์์๋ ์ข ๋ ๊ทผ๋ณธ์ ์ธ ๊ณ ๋ฏผ์ ํ๊ฒ ๋์๋ค. "๊ณผ์ฐ UIImageView๊ฐ ๋คํธ์ํฌ ํต์  ์ฝ๋๋ฅผ ์์ ํ๋๊ฒ ๋ง์๊น? UIImageView๋ ๋ง ๊ทธ๋๋ก UI์ ์ฐ์ด๋ ์ด๋ฏธ์ง ๋ทฐ ๊ด๋ จ ์ฝ๋๋ง ์์งํด์ผํ์ง ์์๊น?" 

๊ฒฐ๊ตญ ์บ์ฑ ์์์ ์ถ๊ฐํ๋ฉด์ UIImageView์์ ๋คํธ์ํฌ ํต์  ์ฝ๋๋ฅผ ๋ถ๋ฆฌํ๋ ์์์ ํ๋ฒ ๋ ์ํํ๋ค.
    
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
    
์บ์์ ์กด์ฌํ๋ ์ด๋ฏธ์ง๋ผ๋ฉด ๋คํธ์ํฌ ์์ฒญ์ ์ทจ์ํ๋๋ก ํ๊ณ , ๋์ผํ URL์ ์ด๋ฏธ์ง๋ผ๋ ํ์ฌ ๋คํธ์ํฌ ์์ฒญ ์ค์ธ์ง, ์๋ฃํ์ฌ ์บ์์ ์กด์ฌํ๋์ง ๋ฑ ๊ฐ๊ฐ์ ๊ฒฝ์ฐ๋ง๋ค ์ค๋ณต ์์์ ํผํ๋๋ก ์ค๊ณํด๋ณด์๋ค. ๊ฐ URL ์ ๋ฐ๋ผ ๋ฐ์ดํฐ ํ์คํฌ, ์๋ฃ์ ํด๋ก์ , ์บ์๋ฅผ ๋์๋ค.
    
</details>

</details>
    
###

<details>
    
<summary>UITextView์ ํฌ๊ธฐ๊ฐ ๋์ด๋์ง ์๋ ๋ฌธ์ </summary>
    
<img src="https://i.imgur.com/KXhDRWW.png" width="250" height="500"/>
    
UITextView๊ฐ ์ํ StackView์ bottomAnchor๋ฅผ ScrollView์ bottomAnchor์ constraint๋ฅผ ๊ฐ๊ฒ ๋ง์ถ์ด ์ฃผ์์์๋ ๋์ด๋์ง ์๋ ๋ฌธ์ ๊ฐ ๋ฐ์ํ๋ค.
    
<img src="https://i.imgur.com/m9ZM32G.png" width="250" height="500"/>
    
์ view Hierarchy์์ ๋ณด๋ฏ StackView์ ํฌ๊ธฐ ์์ฒด๊ฐ ๋์ด๋์ง ์๋ ๊ฒ์ ํ์ธํ๋ค. ์ธ๋ก๋ก ์คํฌ๋กค์ด ๋์ด์ผํ๋ ํน์ฑ์ ์ฃผ์ด์ผํ๊ธฐ ๋๋ฌธ์ StackView์ topAnchor, bottonAnchor๋ฅผ contentLayoutGuide์ constraintํ ๊ฒ์ด ๋ฌธ์ ๊ฐ ๋์๋ค๊ณ  ํ๋จํ๋ค.
๋ฐ๋ผ์, StackView์ heightAnchor๋ฅผ ์ง์ ํด์ฃผ์ด ํด๊ฒฐํ๋ค.
    
</details>

</br>

<details>
    
<summary> ๋ฐฐ๋ ๋ทฐ์ ์ด๋ฏธ์ง๊ฐ ๋ฌดํ ๋ฐ๋ณตํ๋๋ก ๊ตฌํํ๋ ๋ฐฉ๋ฒ
    
</summary>

์ด๋ฏธ์ง์ ๋ง์ง๋ง ์ธ๋ฑ์ค์์ ๋ค์ ์ฒ์ ์ธ๋ฑ์ค๋ก ๋์ด๊ฐ๋ ๋ก์ง์ ๋ํด์ ๊ณ ๋ฏผํ์๋ค.  

![](https://i.imgur.com/4DsUbs4.png)
    
ํด๊ฒฐ ๋ฐฉ๋ฒ์ผ๋ก๋ ์ฒซ๋ฒ์งธ ์ด๋ฏธ์ง ๋ฐ ๋ง์ง๋ง ์ด๋ฏธ์ง์ ์ด๋ฏธ์ง ๋ทฐ๋ฅผ ์ถ๊ฐํ๋ค์ ํด๋น ์ด๋ฏธ์ง ๋ทฐ์ ๋ค์์ ์ฌ ์ด๋ฏธ์ง๋ฅผ ์ถ๊ฐํด์ฃผ๊ณ  ๊ทธ ์ด๋ฏธ์ง๊ฐ ํ๋ฉด์ ๋์ฌ๋ scrollView์ contentOffset์ ํด๋น ์ด๋ฏธ์ง์ ์๋ ์์น๋ก ์ด๋์ํจ๋ค. ๊ทธ๋ ๊ฒ ๋๋ฉด ์ฌ์ฉ์์์ฅ์์๋ ์ด์ง๊ฐ์ ๋๋ผ์ง ์๊ณ  ๋ฌดํ ์คํฌ๋กค์ด ๋๋ค๋ ์ฐฉ๊ฐ์ ํ๊ฒ ๋๋ค.  
    
</details>
    
</br>

<details>
    
<summary> 
   ํ๋ฉด ์ด๋๊ฐ์ ๋ฆฌ์คํธ ์ ์์น ์ด๋ ๋ฌธ์ 
</summary>
    
๋ฆฌ์คํธ ๋ทฐ์ ํน์ ์์น์์ ํน์  ์์ ๋ํ ์์ ์ด๋, ์ญ์ ๊ฐ ์ด๋ฃจ์ด์ง๋ ํด๋น ์์์ดํ ๋ค์ ์๋ก ๋์ ์ฌ๋ ์์น๊ฐ ๋ณ๊ฒฝ๋๋ ๋ฌธ์ ๊ฐ ์์๋ค.
    
![](https://i.imgur.com/JsVv7AR.png)
    
![](https://i.imgur.com/XTxLFME.png)

ํ๋ฉด์ด๋๊ฐ์ ํด๋น ์์ indexPath ๊ฐ์ ํ ๋น ๋ฐ์๋ค์ ํ ๋น ๋ฐ์ indexPath ์์น๋ก ์คํฌ๋กคํด์ฃผ์๋ค.
    
</details>
    
</br>

<details>
    
<summary> 
   RegistView Image ์ญ์ ํ๋ ๋ฐฉ๋ฒ
</summary>
    
CollectionView๋ก ์ด๋ฏธ์ง ์ถ๊ฐ๋ง ๊ตฌํํ ์ํ์์ "X"๋ฒํผ์ ๋ง๋ค์ด ์ญ์ ๋ฅผ ๊ตฌํํด์ผ๋๋ค.
๊ฐ Cell์ ๊ตฌํ๋ "X"๋ฒํผ์ ์ก์์ ๋ฃ๋ ๋ฐฉ๋ฒ์์ ๋ฌธ์ ๊ฐ ๋ฐ์ํ๋ค.
์ญ์  ๋ฒํผ์ ๋๋ฅธ index๋ฅผ ๊ตฌํ  ์ ์์๋ค.
์๋ํ๋ฉด DiffableDataSource๋ฅผ ์ฌ์ฉํ๊ณ  ์์๊ธฐ ๋๋ฌธ์ด๋ค. DiffableDataSource๋ indexPath๊ฐ ์๋ ์ง์ ๋ ํ์์ผ๋ก ์๊ธฐ ๋๋ฌธ์ index๋ฅผ ์ด์ฉํ๋ ๊ฒ์ DiffableDataSource์ ํน์ง์ ์ด์ฉํ์ง ๋ชปํ๋ค๊ณ  ์๊ฐํ๋ค.
๊ทธ๋์ ๊ฐ Cell์ ์ง์ ํ  ๋ ํด๋ก์ ๋ฅผ ์ด์ฉํ์ฌ Action์ ๋ฃ์ด์ฃผ๊ธฐ๋ก ํ๋ค.

```swift
let cell = UICollectionView.CellRegistration<ProductRegistCollectionViewCell, UIImage> { cell, indexPath, item in
    cell.removeImage = {
        self.deleteDataSource(image: item)
    }
    cell.configureImage(data: item)
}
```
    ์ ์ฝ๋์ ๊ฐ์ด ๊ฐ cell์ item์ ์ง์ ํ  ๋ ๊ทธ item์ dataSource์์ ์ง์ฐ๋ action์ ํด๋ก์ ๋ก ์ด์ฉํ์ฌ ๋๊ฒจ์ฃผ๊ฒ ๋๋ค.
```swift
@objc private func didTapRemoveButton() {
    removeImage?()
}
    
```
    
์ ์ฝ๋์ ๊ฐ์ด ๊ฐ Cell์ ์ง์ ๋ "X"๋ฒํผ action์ ํด๋ก์ ๋ฅผ ์ถ๊ฐํด์ฃผ์ด Delete๊ธฐ๋ฅ์ ๊ตฌํํ๋ค.

    </details>
</details>

    

---

### MVVM

<details>
    
<summary> Observable ํ์์ ์ค์  
</summary>
        
์ด๋ฒคํธ ํ๋ฆ์ ๋จ๋ฐฉํฅ์ผ๋ก ์ฒ๋ฆฌํ๊ธฐ ์ํด ์ด๋ฐ์ ํด๋ก์ ์ ํํ๋ก ๊ตฌํ์ ํ์๋ค. ํ์ง๋ง ์ด๋ฒคํธ์ ๊ฐฏ์ ๋งํผ ๋ทฐ๋ชจ๋ธ์ด ํด๋ก์ ์ ๋ฐ์ดํฐ ๋ชจ๋ธ์ ์์ ํ๊ณ  ์์ด์ผ ํ๊ธฐ์ ์ด๋ฅผ ํฉ์น๋ ๊ฐ๋์ด ํ์ํ๋ค. 
    
RxSwift์ Observable ํ์์ ์ฐธ๊ณ ํ์ฌ ๋ค์๊ณผ ๊ฐ์ด ๋ฆฌ์ค๋๋ฅผ ์์ ํ๋ ์ปค์คํ Observable ํ์์ ์์ฑํ์ฌ ์ด๋ฅผ ํด๊ฒฐํด๋ณด์๋ค.
    
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
    
์ด Observable ํ์์ ํ์ฉํจ์ผ๋ก์จ ViewModel์ Input๊ณผ Output์ผ๋ก ์ด๋ฒคํธ ์์ถ๋ ฅ์ ์ ๋ฆฌํ๊ณ  ์ต์ข์ ์ผ๋ก View Controller์์ ์ํ๊ฐ์ด ๋ณ๊ฒฝ๋๋ฉด ์ด์ ๋์๋๋ ๋ฐ์ดํฐ๋ชจ๋ธ์ ํด๋ก์ ๋ก ๋๊ฒจ์ฃผ์ด RxSwift์ bindindg์์๊ณผ ์ ์ฌํ๊ฒ UIKit๋ง์ ์ฌ์ฉํ์ฌ ๊ตฌํํ  ์ ์์๋ค.
    
    
</details>
    

</br>

<details>
    
<summary> ๋ทฐ ๋ชจ๋ธ์ Input์ ์ด๋ค ๊ฐ์ ๋ฃ์ด์ผ ํ ์ง์ ๋ํ์ฌ </summary>

RxSwift์ ๊ฒฝ์ฐ UIComponents์ rx๋ฅผ ์ด์ฉํ์ฌ ์ ๊ทผํ๊ณ  ์ด์ ๋ํ ์ด๋ฒคํธ ํ๋ฆ์ ์ด๋์ด ์ฌ ์ ์๋ค. 
๋ค๋ง Pure MVVM์ ๋ชฉํ๋ก ๊ฐ๋ฐ์ ํ๋ค๋ณด๋ ์ด ์ด๋ฒคํธ ํ๋ฆ์ ์์์ ์ด ์ด๋์ ์์นํ  ๊ฒ์ธ๊ฐ์ ๋ํด์ ๊ต์ฅํ ๊ณ ๋ฏผ์ ๋ง์ด ํ๋ค. 
    
Main ViewController์ ๊ฒฝ์ฐ ์ด๊ธฐ ๋ฐ์ดํฐ ๋ก๋๋ง ๋ถ๋ฌ์ค๊ธฐ ๋๋ฌธ์ binding ์์์์ Observable ํ์์ ๋๊ฒจ ์ฃผ์๋ค.
    
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

ํ์ง๋ง ์ํ ๋ชฉ๋ก ๋ทฐ์์๋ ํ์ฌ ๋ถ๋ฌ์จ ํ์ด์ง์ ํ์ด์ง๋น ์์ดํ์ ๊ฐ์, ํ์ฌ ์ํ๊ฐ update์ธ์ง ํน์ add์ธ์ง์ ๋ํด์ ๋ณํ๋ฅผ ViewController๊ฐ ์์ ํ๊ณ  ์์ด์ผ ํด์ ViewController์ `pageState`๋ผ๋ Observableํ์์ ํ๋กํผํฐ๋ก ์์ ํ๋๋ก ํ์๋ค. ๋ํ SearchController๋ฅผ ํตํด ์๋ ฅ๋๋๊ฒ๋ ํํฐ๋ง ๊ฐ์ ์ด๋ฒคํธ ๋ณํ๋ก ์ฐ๊ฒฐํ๊ธฐ ์ํด Observableํ์์ผ๋ก ๋ง๋ค์๋ค.
    
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

์ด ํ๋กํผํฐ ๋๊ฐ์ง๋ฅผ ๋ทฐ ๋ชจ๋ธ์ transform ๋ฉ์๋๋ฅผ ํตํด ๋ฐ์ธ๋ฉ ์์์ ๊ฑฐ์ณค๋ค.

```swift
let output = productListViewModel.transform(input: .init(
    productListPageInfoUpdateAction: pageState,
    filteringStateUpdateAction: filteringState
))
```

    
</details>
    
</br>
<details>
<summary> ๋ทฐ๋ชจ๋ธ์ ์๋ฌ ํธ๋ค๋ง์ ์ฒ๋ฆฌ์ ๊ดํ์ฌ</summary>

๊ธฐ์กด์ ์ฝ๋๋ ์๋ฌ ํธ๋ค๋ง์ด ๋คํธ์ํฌ ์ฝ๋์ ์์ ๋์ด ์์๋ค. SessionProtocol๋ก ๋ถํฐ ResultType์ ๋ฐํ๋ฐ์ ์ด๋ฅผ ๋ถ๊ธฐ ์ฒ๋ฆฌํ์ฌ Completion Handler๋ฅผ ๋๊ฒจ์ฃผ๋ ๋ฐฉ์์ด์๋ค.
    
ํ์ง๋ง ๊ฒฐ๊ณผ์ ๋ถ๊ธฐ ์ฒ๋ฆฌ ์์ฒด๋ฅผ ๋ทฐ ์ปจํธ๋กค๋ฌ๊ฐ ์งํํ๊ฒ ๋๋ ๊ฒ ์์ฒด๊ฐ ๋น์ฆ๋์ค ๋ก์ง์ด๋ผ๊ณ  ์๊ฐ๋์๋ค. ๋ํ ์คํจ์ ๊ฒฝ์ฐ AlertDirector๋ฅผ ํตํด ์คํจ ๋ด์ฉ์ ์ถ๋ ฅ ํด์ผํ๋๋ฐ ๋น์ฆ๋์ค ๋ก์ง์ด ๋ทฐ๋ชจ๋ธ๋ก ์ด๊ด๋๋ฉด์ ์๋ฌ ํ์์ ๋๊ฒจ ๋ฐ๋๋ก ๊ตฌ์กฐ๋ฅผ ์ง์ผํ๋ค.
    
https://benoitpasquier.com/error-handling-swift-mvvm/
    
์ ๋ธ๋ก๊ทธ๋ฅผ ์ฐธ๊ณ ํ์ฌ ์๋ฌ์ฝ๋์ ๋ํด์ ๋ถ๋ฆฌ๋ฅผ ํ๋ค.
    
๋จผ์  ๋ทฐ๋ชจ๋ธ ๋ด๋ถ์ ์๋ฌ ํธ๋ค๋ง์ ์ค์ ๋ก ์งํ ํ  ํด๋ก์ ๋ฅผ ์ ์ธํ์๋ค.
    
```swift
var onErrorHandling : ((APIError) -> Void)?
```

๊ทธ๋ฆฌ๊ณ  bind ๋ฉ์๋์์ ์ค์  ์๋ฌ๊ฐ ๋ฐ์ํ  ๊ฒฝ์ฐ ๋์์ค AlertDirector๋ฅผ ํธ์ถํ๋๋ก ํ์๋ค.
    
```swift
mainViewModel.onErrorHandling = { failure in 
    AlertDirector(viewController: self).createErrorAlert(
        message: MainViewControllerNameSpace.getDataErrorMassage
    )
}
```

๋ทฐ ๋ชจ๋ธ์์๋ ์๋ฌ์ ๋ถ๊ธฐ ์ฒ๋ฆฌ๋ฅผ ์งํํ๋ค. success๋ผ๋ฉด Completion Handler๋ฅผ ํธ์ถํ๊ณ , failure๋ผ๋ฉด ViewController๋ก ๋ถํฐ ์ฃผ์๋ฐ์ ํด๋ก์ ๋ฅผ ์คํํ๋ค.
    
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
    
์ด๋ ๊ฒํ์ฌ ViewController๋ ์คํจ์ ๋์ํด์ผํ  View์ ๊ด๋ จ๋ ๋ก์ง๋ง์ ์์ ํ๊ฒ ๋๊ณ , ViewModel์์ ์๋ฌ ์ฒ๋ฆฌ๋ถ๊ธฐ์ ๊ด๋ จ๋ ๋น์ฆ๋์ค ๋ก์ง์ ๋ฐฐ์นํจ๊ณผ ๋์์ View๊ด๋ จ ์์์ ํ์ง ์๋๋ก ํ  ์ ์์๋ค.

</details>    

</br>

<details>
<summary>View Model ๋ด๋ถ์ ๋ฐ์ดํฐ์ ํํ</summary>

์ต์ด์ Input Output ๊ตฌ์กฐ๋ฅผ ์์ฑํ  ๋ ๋ทฐ ๋ชจ๋ธ ๋ด๋ถ์ ๋ฐ์ดํฐ๋ฅผ ๋ฐฐ์น์ํค์ง ์์ผ๋ ค๊ณ  ํ๋ค. ViewController์ ์ํ ๋ณํ์ ๋ฐ๋ฅธ ๋น์ฆ๋์ค ๋ก์ง์ ๊ฑฐ์ณ ํธ๋ค๋ง๋ ๋ฐ์ดํฐ๋ฅผ ๋๊ฒจ์ฃผ๊ธฐ๋ง ํ๋ ์ญํ ๋ง์ ๋ทฐ ๋ชจ๋ธ์ ๋ถ์ฌํ๋ คํ๋ค. 

ํ์ง๋ง ์ํ ๋ชฉ๋ก์ ๊ฒฝ์ฐ Search Controller๋ก ๋ถํฐ ๋์ด์ค๋ ๊ฒ์์ด์ ์ํ๋ณํ์ ๋ฐ๋ผ ๊ฒ์์ ์งํํ  ๋ฐ์ดํฐ๊ฐ ํ์ํ๊ธฐ์ ๊ฒฐ๊ตญ ProductListViewModel ๋ด๋ถ์ `[Product]` ํ์์ ์ ์ฅํ๊ฒ ๋์๋ค.
    
<img src=https://i.imgur.com/0luKtLW.png width=60%>

๋ค๋ง dataSource ์์ฒด๋ฅผ ๋ทฐ ๋ชจ๋ธ์ ์์น์ํค๊ฒ ๋๋ฉด ์ด๋ฌํ ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ  ์ ์์๊ฒ์ด๋ผ ์๊ฐํ์๋๋ฐ UIKit๊ด๋ จ ๋ชจ๋  ์ฝ๋๋ฅผ ๋ทฐ ๋ชจ๋ธ์์ ์ ์ธํ๋๊ฒ ์์ฒด๊ฐ ๋ชจ์์ด๋ผ ์๊ฐํ์ฌ ์ด๋ฐ์์ผ๋ก ์์ฑํ๊ฒ ๋์๋ค.
    
    
</details>

</br>

<details>
<summary>RegistViewModel subscribe์ ์ด๊ธฐ ์คํ ๋ฌธ์ </summary>
    ์ด๊ธฐ ๊ฐ์ด ์ค์ ๋๊ณ  ๊ฐ์ด ๋ณ๊ฒฝ๋  ๋๋ง๋ค output์ ์ด์ฉํ์ฌ post, patchํด์ผ๋๋๋ฐ, ์ด๊ธฐ ๊ฐ์ผ๋ก๋ post๊ฐ ๋๋ ๋ฌธ์ ๊ฐ ๋ฐ์ํ๋ค.
    Enum ํ์์ ์๋ก ๋ง๋ค์ด ์ด๊ธฐ์๋ง unUpdatable case๋ฅผ ๋ฃ์ด์ฃผ์ด ์ด๊ธฐ์๋ง ๋คํธ์ํน์ ํ์ง ์๋ ๋ฐฉ์์ผ๋ก ์ฝ๋๋ฅผ ๋ฃ์์ง๋ง ๋ถํ์ํ ํ์์ด ์ถ๊ฐ๋๊ณ , ํ์ํ ๋ฐ์ดํฐ๊ฐ ์๋ ์ ๋ณด๋ฅผ viewModel์ ๋๊ฒจ์ค๋ค๊ณ  ์๊ฐํ์๋ค.
    ๊ทธ๋์ input์ ๋ค์ด๊ฐ๋ Observable์ RegistrationProductํ์์ ์ต์๋๋ก ์ค์ ํ์ฌ nil์ผ ๊ฒฝ์ฐ closure์ returnํ๋ ๋ฐฉ์์ผ๋ก ๋๊ธฐ๋ ๋ฐฉ์์ผ๋ก ํด๊ฒฐํ๋ค.
</details>
