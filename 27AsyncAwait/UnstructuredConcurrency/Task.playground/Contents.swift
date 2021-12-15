import UIKit
/*:
 ## Unstructured Concurrency
 
 Như các bài viết trước, chúng ta đã tìm hiểu nhiều về Structured concurrency trong Swift 5.5 rồi. Với các APIs mới từ Structured concurrency thì bạn có trong tay rất nhiều công cụ để tương tác bất đồng bộ và xử lý đồng thời. Nó giữ cho mạch chương trình của bạn luôn tường mình và dễ theo dõi. Bản thân bạn chủ động trong việc điều kiển các tác vụ đó. Cũng như khống chế tác vụ khi lỗi xuất hiện.
 
 Structured concurrency sẽ là công cụ tuyệt vời cho bạn thực thi nhiều tác vụ một lúc. Nhưng bản thân nó cũng tồn tại một vấn đề cố hữu. Đó là ...
 
 > Code của bạn sẽ khó đọc hơn!
 
 Nhưng ... đôi lúc chúng ta lại không cần sử dụng tới Structured concurrency. Mà cần Unstructured concurrency. Với tiêu chí hi sinh đi cấu trúc để đổi lấy sự đơn giản khi cần giải quyết một số bài toán cụ thể. Bạn có thể tưởng tượng ra các ví dụ mà bạn sẽ hay gặp như sau:
 
 * Cần làm một tác vụ tại bất cứ đâu và bất cứ lúc nào tại ngữ cảnh đồng bộ. Như kích vào button và thực hiện API hay gì khác
 * Tách từ cấu trúc chính ra một tác vụ riêng lẽ và không phụ thuộc vào luồng tác vụ lúc đó. Như download ảnh và tách luồng save ảnh vào files.
 
 Trong phạm vi bài viết này thì chúng ta sẽ quan tâm tới việc khởi chạy 1 tác vụ ở bất cứ đầu và bất cứ lúc nào. Còn với việc tách tác vụ thì đó chính là Detached Task mà chúng ta đã trình bày ở bài viết trước.
 */
/*:
 ## Non-async contexts
 
 Non-async contexts (hay gọi là ngữ cảnh đồng bộ). Bạn đã biết về các function async thì sẽ được gọi được ở các function async khác. Đó chính là các ngữ cảnh bất đồng bộ. Và cũng áp dụng cho các đối tượng của Structured Concurrency là async let, Task & Group Task.
 
 Và khi bạn muốn thực thi chúng từ gốc thì có 2 cách:
 
 * async main
 * Task { ... }
 
 Về async main thì bạn sẽ ít cơ hội làm, nhưng với Task { ... } thì lại được sử dụng rất là nhiều rồi. Điều đặc biệt đó là bạn có thể sử dụng Task { ... } ở bất cứ đâu, dù là ngữ cảnh đồng bộ hay bất đồng bộ đi nữa. Ngay các function không có khai báo với async thì bạn vẫn sử dụng được Task { ... } để gọi các tác vụ đồng thời đơn giản.
 
 Và ngay cả các API trong SDK của Apple ngay từ đầu cũng đã không thiết kế cho việc bất đồng bộ hay đồng thời. Lấy ví dụ với UIKit, khi một ViewController khởi chạy thì các function viewDidAppear cũng không đánh dấu là async hay bất đồng bộ. Với Task { ... }, bạn sử dụng nó để thực thi các tác vụ bất đồng bộ cần thiết ngay tại các API đồng bộ.
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
            print("Hello & Goodbye!")
        }
    }

}
/*:
 Hoặc bạn có thể gọi các function async khác trong chính khối lệnh của Task { ... }. Kèm với từ khóa await, xem ví dụ sau nhóe!
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
            print("Hello & Goodbye!")
            await hello(name: "Fx Studio")
        }
    }

    func hello(name: String) async {
        print("Hello, \(name)!")
    }
}
/*:
 ## Task<T, Error>
 
 Ở phần trên, bạn đã hiểu được ngữ cảnh đồng bộ và cách bạn thực thi một tác vụ bất đồng bộ rồi. Với Task { ... } thì bạn sẽ sử dụng closure để gọi hoặc thực thi tác vụ bất động bộ đó.
 
 > Nó là một Unstructured Concurrency
 
 Tác vụ của bạn chạy dựa vào việc tách closure của Task ra và thực thi khối lệnh đó. Tương tự như các task async khác. Chúng ta sẽ sử dụng Task theo cách này thực sự sẽ trả về cho bạn một xử lý kiểu Task<T, Error>. Sau đó, bạn có thể xử lý nó như cancel, đợi result và nhiều cái khác.
 
 Đây là lúc phần “phi cấu trúc” (Unstructured) phát huy tác dụng. Chúng ta có thể bắt đầu một tác vụ ở đâu đó, và sau đó chúng ta có thể hủy bỏ nó từ một nơi hoàn toàn không liên quan.
*/
/*:
 ## Property with Task<Void, Never>
 
 Chúng ta sẽ sang phần áp dụng Task vào phi cấu trúc đồng thời như thế nào nào. Phạm vi lần này sẽ sử dụng chúng như một kiểu dữ liệu để khai báo các thuộc tính của class.
 
 ### Khai báo
 
 Bắt đầu, ta sẽ khai báo thêm một thuộc tính như sau cho ViewController:
 */
var downloadImageTask: Task<Void, Never>? {
    didSet {
        if downloadImageTask == nil {
            tapButton.setTitle("Download", for: .normal)
        } else {
            tapButton.setTitle("Cancel", for: .normal)
        }
    }
}
/*:
 Trong đó, bạn đã tạo một IBOutlet là tapButton trước rồi. Bằng việc lắng nghe việc didSet khi thuộc tính được gán dữ liệu mà chúng ta cập nhật lại giao diện nhóe. Phần này không khó!
 
 Với kiểu dữ liệu cho Task là Void và Never, thì xem là an toàn nhất.
 
 * Void thì sẽ không có dữ liệu nào tác động tới UI
 * Never thì sẽ không có error nào trả về
 
 Đây là lựa chọn an toàn khi sử dụng Task<T, Error> như một thuộc tính. Và bạn vẫn có thể khai báo nó như là một Optinals
 
 ### Xử lý
 
 Tiếp theo, chúng ta cần các function thực thi việc download ảnh. Bạn xem qua ví dụ 2 function sau nhóe!
 */
func downloadImage(urlString: String) async throws -> UIImage {
    let imageUrl = URL(string: urlString)!
    let imageRequest = URLRequest(url: imageUrl)
    let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
    guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
        throw ImageDownloadError.badImage
    }
    return image
}

func downloadRandom() {
    let index = Int.random(in: 0...2)
    let urlStrings = [
        "url 1", "url 2", "url 3"
    ]
    
    downloadImageTask = Task {
        do {
            let image = try await downloadImage(urlString: urlStrings[index])
            
            imageView.image = image
        } catch {
            print(error.localizedDescription)
        }
        
        downloadImageTask = nil
    }
}
/*:
 Với downloadImage là một hàm bất đồng bộ và có trả về lỗi nếu xãy ra lỗi. Còn function downloadRandom là một hàm đồng bộ. Trong đó xử lý logic cơ bản. Bạn quan tâm tới việc truyền cho thuộc tính downloadImageTask một giá trị. Chính là một Task { ... }. Vì đây là khối lệnh cơ bản của Task { ... }, nên kiểu của nó sẽ là <Void, Never>
 
 Trong khối lệnh đó, bạn sẽ xử lý như bình thường. Với await để đợi download ảnh về và cập nhật lại UI.
 */
/*:
 ### Sử dụng
 
 Tiếp theo, chúng ta sẽ sử dụng thuộc tính downloadImageTask. Vì tất cả chỉ là khai báo mà thôi. Tại sự kiện IBAction khi người dùng nhấn vào. Chúng ta sẽ tiến hành thực thi downloadImageTask. Xem ví dụ nhóe!
 */
@IBAction func tap(_ sender: Any) {
        if downloadImageTask == nil {
            Task {
                downloadRandom()
            }
        } else {
            cancelDownload()
        }
}
/*:
 Trong đó:
 
 * Nếu giá trị của downloadImageTask, thì tiến hành thực thi hàm downloadRandom().
 * Khi hàm downloadRandom() được thực thi, thì downloadImageTask sẽ có giá trị. Từ đó, chúng ta cập nhật nội dung của Button trên giao diện.
 * Khi thực thi downloadRandom(), cũng là thực thi khố lệnh được gán cho downloadImageTask. Chúng ta có await để chờ đợi việc download ảnh.
 * Khi việc download ảnh hoàn thành, thì bạn sẽ được cập nhật lại nội dung có UIImageView trên giao diện.
 
 Như vậy, chúng ta đã hoàn thành 1 vòng thao tác bất đồng bộ theo xử lý đồng thời không cấu trúc. Và nếu thời gian download quá lâu thì bạn có thể cancel nó từ một nơi khác, không liên quan tới tiến trình đang chạy.
 
 Xem code cho phần cancel nhóe!
 */
func cancelDownload() {
    downloadImageTask?.cancel()
}
/*:
 > EZ Game!
 
 Quá đơn giản phải không nào. Đây là thể hiện của việc "phi cấu trúc" trong xử lý đồng thời. Bạn có thể tùy ý hũy tác vụ đang thực thi tại bất cừ đâu bằng việc lưu trữ chúng dưới dạng Unstructured Concurrency.
 */
/*:
 ## Property with Task<T, Error>
 
 
 downloadImageTask thuộc loại Task<Void, Never> vì bản thân tác vụ không trả về bất kỳ thứ gì và nó không gây ra lỗi. Hầu như sẽ không ảnh hưởng tới Main Thread. Và chúng ta sẽ tiếp tục với việc sử dụng Task với giá trị trả về xác thực. Nhằm mục đích không xử lý trực tiếp dữ liệu, chúng ta sẽ xử lý chúng ở một nơi khác.
 
 ### Khai báo
 
 Nhưng trước tiên, bạn cần xác thực thêm @MainActor cho cả ViewControler. Vì lúc này, việc tồn tại dữ liệu cho thuộc tính thì sẽ gây ảnh hưởng trực tiếp tới Main Thread từ các thread khác nhau.
 */
@MainActor
class ViewController: UIViewController //...
/*:
 Tiếp theo, bạn sẽ khai báo một thuộc tính mới và cũng sử dụng Task<T, Error> là kiểu dữ liệu.
 */
var downloadDataImageTask: Task<Data, Error>? {
    didSet {
        if downloadDataImageTask == nil {
            tapButton.setTitle("Download", for: .normal)
        } else {
            tapButton.setTitle("Cancel", for: .normal)
        }
    }
}
/*:
 Cũng tương tự như cách trên. Điểm khác là bạn thêm các kiểu dữ liệu cho Task, là Task<Data, Error>.
 
 * Data là kiểu dữ liệu chính của Task
 * Error là kiểu dữ liệu cho lỗi phát sinh
 */
/*:
 ### Xử lý
 
 Ta tìm hiểu tiếp phần xử lý Task<T, Error> thông qua function đầu tiên cung cấp giá trị cho thuộc tính downloadDataImageTask.
 */
func downloadImageData(urlString: String) async throws -> Data {
    let imageUrl = URL(string: urlString)!
    let imageRequest = URLRequest(url: imageUrl)
    let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
    guard (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
        throw ImageDownloadError.badImage
    }
    return data
}

func beginDownloadDataRandowm() {
    let index = Int.random(in: 0...2)
    let urlStrings = [
        "https://media-cldnry.s-nbcnews.com/image/upload/newscms/2021_26/3487828/210630-stock-cat-bed-ew-245p.jpg",
        "https://s.w-x.co/in-cat_in_glasses.jpg",
        "https://www.gannett-cdn.com/-mm-/735f994d042682a89f8a4f2fcfd5ea505f3dc1cd/c=0-127-2995-1819/local/-/media/2015/10/31/USATODAY/USATODAY/635818943680464639-103115cute-kitty.jpg"
    ]
    
    downloadDataImageTask = Task {
        return try await downloadImageData(urlString: urlStrings[index])
    }
}
/*:
 Trong đó, function downloadImageData là một function bất đồng bộ và có lỗi trả về nếu phát sinh. Cũng khá bình thường, khác ví dụ trên là chúng ta trả về Data thay vì UIImage. Còn với function beginDownloadDataRandowm, xem như là tiền xử lý thuộc tính Task.
 
 Tại beginDownloadDataRandowm, bạn sẽ thấy việc return về giá trị bằng việc gọi từ một function khác. Cái này cũng dễ hiểu:
 
 * downloadImageData có return về kiểu là Data
 * Data cũng là kiểu dữ liệu chính của thuộc tính downloadDataImageTask
 * Ta sẽ return function downloadImageData trong closure Task, thì xem như đã gán đúng giá trị cho thuộc tính downloadDataImageTask
 * Về Error thì tương tự nhau và sử dụng Error Protocol cơ bản nên hầu như đảm bảo về khai báo
 */
/*:
 ### Sử dụng
 
 Ta sẽ đến với việc sử dụng thuộc tính Task này thông qua các function sau:
 */
func showImageData(data: Data) {
    imageView.image = UIImage(data: data)
}

func downloadDataRandom() async {
    beginDownloadDataRandowm()
    
    do {
        if let data = try await downloadDataImageTask?.value {
            showImageData(data: data)
        }
    } catch {
        print(error.localizedDescription)
    }
    
    downloadDataImageTask = nil
}
/*:
 Function showImageData thì rất cơ bản và đơn giản. Function downloadDataRandom là nơi gọi function gán giá trị cho thuộc tính downloadDataImageTask. Sau đó, bạn sẽ sử dụng await để lấy giá trị từ thuộc tính downloadDataImageTask, bằng việc truy cập downloadDataImageTask?.value của thuộc tính.
 
 > Đó là cách bạn lấy giá trị của Task
 
 Tiếp theo, là cách bạn gọi thuộc tính Task khi người dùng tương tác.
 */
@IBAction func tap(_ sender: Any) {
    if downloadDataImageTask == nil {
        Task {
            await downloadDataRandom()
        }
    } else {
        cancelDownload()
    }
}
/*:
 Cũng tương tự cách trên, bạn sẽ gọi function xử lý chính. Ngoài ra, function cancel sẽ thực thi ở một nơi khác, không liên quan tới tiến trình đang chạy.
 */
func cancelDownload() {
    downloadImageTask?.cancel()
    downloadDataImageTask?.cancel()
}
/*:
 Bạn cập nhật lại cancelDownload như trên. Bạn cũng nhận ra là chúng ta có thể cancel nhiều thuộc tính một lúc vẫn được. Đây cũng là ưu điểm mà Unstructured Concurrency đem lại cho bạn.
 
 Thực thi chương trình và bạn cảm nhận được việc bạn có thể hoàn toàn xử lý tiến trình bất đồng bộ & đồng thời đang chạy. Bạn có thể lưu trữ nó vào một thuộc tính, xử lý và hũy chúng.
 */
/*:
 ## Tạm kết
 
 * Tìm hiểu về khái niệm Unstructured Concurrency
 * Sử dụng Unstructured Concurrency trong các ngữ cảnh đồng bộ
 * Khai báo thuộc tính Unstructured Concurrency với Task<T, Error>
 * Lưu trữ, xử lý và hũy cho các tác vụ của thuộc tính Task<T, Error>
 */
