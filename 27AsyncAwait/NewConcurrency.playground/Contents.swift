import UIKit
/*:
 # Concurrency Roadmap - Swift 5.5
 
 Chào mừng bạn đến với Fx Studio. Bài viết lần này sẽ mang tính chất tổng hợp và giới thiệu các khái niệm mới của New Concurrency trong Swift 5.5 tới bạn. Cũng như cách tiếp cận theo từng bước để bước vào thế giới huyền bí này.
 
 Nếu mọi thứ đã ổn rồi, thì ...
 
 > Bắt đầu thôi!
 */
/*:
 ## Concurrency Roadmap
 
 Từ WWDC21, Apple đã giới thiệu Swift 5.5 với rất nhiều cập nhật cho Xử lý bất đồng bộ & Đồng thời. Tới hiện này, Apple vẫn tiếp tục cập nhất thêm các API mới của New Concurrency này. Các API này ra đời với mục đích giúp Swift tiếp cận với các ngôn ngữ lập trình mới trong xử lý đồng thời.
 
 Quan trọng hơn nữa là thay đổi cách tư duy lập trình của bạn về Concurrency trong Swift. Vì trước đây, lý do hầu như là ...
 
 > Concurrency là khó!
 
 Nhưng với các khái niệm mới (như là: async/await, Task ...) sẽ là logic code của bạn gọn đi rất nhiều. Tính liền mạch trong code đảm bảo. Bạn không cần phải tưởng tượng hoặc suy nghĩ các tiến trình chạy nhảy như thế này. Chúng ta sẽ chia tay một số khái niệm kinh điển khi xử lý bất đồng bộ & đồng thời trước đây là:
 
 > Callback & Delegate
 
 Từ đó, các bạn newbie khi học Swift sẽ đỡ phải áp lực hơn trước đây. Nhưng đó là về mặt tiếp cận, còn về bản chất thì bạn phải nắm được các kiến thức cơ bản trước. Và New Concurrency này cũng là một phần nâng cao của Swift.
 
 Cuối cùng, mục đích quan trọng nhất của New Concurrency đó là tích hợp vào hệ sinh thái của Apple. Nó sẽ hỗ trợ trực tiếp cho cách nền tảng mới, như SwiftUI. Tằng cường thêm sức mạnh của Combine và xóa bỏ dần lệ thuộc với Rx ...
 
 > Và vấn đề lớn nhất lúc này là bạn sẽ tiếp cận chúng bắt đầu từ đâu?
 
 Bài viết này sẽ hướng dẫn bạn cách tìm hiểu như thế nào để bạn không phải tẩu hỏa nhập ma. Nào tiếp tục thôi!
 */
/*:
 ## async & await
 
 Về async & await là 2 keyword của hệ thông. Chúng là 2 keyword sẽ đi theo bạn rất nhiều. Để bắt đầu tìm hiểu về Concurrency mới này thì bạn sẽ phải hiểu được cách sử dụng của async & await trong Swift 5.5 nhóe.
 
 ### Vấn đề
 
 Chúng ta đã được học lập trình với kiểu lập trình tuyến tính, nghĩa là code của bạn sẽ chạy từ trên xuống dưới và theo các cấu trúc nhất định. Nhưng khi chuyển sang bất đồng bộ thì bạn phải suy nghĩ rằng một số đoạn của bạn sẽ được thực thi tại một nơi nào đó hoặc một thời điểm nào đó.
 
 Bạn sẽ nhận được giá trị của tác vụ trả về thông qua callback & delegate. Đó cũng chính là thiết kế cơ bản của Objective-C & Swift từ lúc khai thiên lập địa tới bây giờ.
 
 > Điều đó dẫn tới việc hiểu được bất đồng bộ & đồng thời rất là khó.
 
 ### Giải pháp
 
 async / await cho phép chúng ta viết mã đồng thời tuyến tính thực thi từ trên xuống dưới. Để làm việc với điều này, các hàm có thể được gọi là không đồng bộ nên được đánh dấu là không đồng bộ trong chữ ký hàm.
 */
func doSomething() async -> String {
    return "n/a"
}
/*:
 Khi chúng ta gọi một hàm được đánh dấu là bất đồng bộ, nó cần được thêm vào trước từ await.
 */
func call() async {
    let str = await doSomething()
    print(str)
}
/*:
 
 Khi quá trình thực thi mã của chúng ta đến từ khóa await, việc thực thi mã của chúng tôi có thể bị tạm ngừng và các đoạn code khác vẫn thực thi công việc của nó.
 
 Đó là những gì cơ bản nhất của async & await trong Swift 5.5. Tất nhiên vẫn còn nhiều vấn đề liên quan tới chúng nữa, bạn sẽ tìm hiểu ở ở các bài viết dưới đây.
 
 * https://fxstudio.dev/co-ban-ve-async-await-trong-10-phut-swift-5-5/
 
 ### Ứng dụng
 
 Để giúp bạn thấy được ứng dụng của async & await thì đọc tiếp bài viết dưới đây:
 
 * https://fxstudio.dev/async-await-to-fetch-rest-api-swift-5-5/
 
 Lần này, chúng ta sẽ thử sử dụng nó vào việc lấy dữ liệu từ một Rest API. Bên cạnh đó, ta cũng sẽ phân tích xem cách dùng mới và cũ có gì khác nhau. Hy vọng bạn sẽ bắt đầu hứng thú với async/await mới này.
 
 Quan trong hơn, bạn sẽ thấy việc chúng ta sẽ nói lời chia tay với Callback trong xử lý tương tác với API.
 */
/*:
 ## Structured Concurrency
 
 Khái niệm cần tìm hiểu tiếp theo là Structured Concurrency. Vì với async & await là dừng chờ, chứ không phải là Đồng thời. Độ khó công việc của bạn cần giải quyết là xử lý một lúc nhiều tác vụ bất đồng bộ với nhau.
 
 Structured Concurrency cho phép chúng ta viết mã đồng thời cũng có thể được đọc từ trên xuống dưới. Chúng ta có thể khởi chạy song song nhiều tác vụ một cách dễ dàng.
 
 Và bạn sẽ có 2 kiểu mà Structured Concurrency cung cấp cho bạn, đó là:
 
 * async let
 * Task Group
 */
/*:
 ### async let
 
 Bạn cần biết với các tác vụ gọi với await thì chúng cũng có thể thực hiện đồng thời. Chúng ta sẽ tưởng tượng các tác vụ đó như là một giá trị và việc cần làm lúc này định nghĩa chúng thành một biến.
 
 Từ đó, ta sẽ kết hợp thêm cho việc khai báo đó là:
 
 > async + let
 
 Và bỏ đi từ khóa await. Chúng sẽ như thế này:
 */
async let thing = doSomething()
makeUseOf(await thing)
/*:
 Lúc nào bạn sử dụng tới giá trị của chúng thì sẽ sử dụng từ khóa await. Đơn giản như vậy thôi!
 
 Còn khi bạn kết hợp nhiều async let lại với nhau, thì sẽ thấy được tính năng đồng thời của chúng. Xem ví dụ nhóe!
 */
func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {
    async let image = downloadImage(imageNumber: imageNumber)
    async let metadata = downloadMetadata(for: imageNumber)
    return try DetailedImage(image: await image, metadata: await metadata)
}
/*:
 Trong đó:
 
 * Khai báo 2 async let cho image và metadata thì chúng không cần phải dừng chờ lẫn nhau mà sẽ được thực thi ngay
 * Khi muốn lấy giá trị của chúng thì bạn sử dụng await
 * Toàn bộ tiến trình sẽ kết thúc khi cả 2 async let đó kết thúc hết
 
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:
 
 * https://fxstudio.dev/structured-concurrency-async-let/
 */
/*:
 ### Group Task
 
 Tiếp theo, bạn có nhiều tác vụ trả về kiểu dữ liệu giống nhau. Thì các tốt nhất là nhóm chúng nó lại thành một nhóm để dễ quản lý. Từ đó, Group Task được ra đời.
 
 Chúng ta sẽ sử dụng 2 phương thức withThrowingTaskGroup hoặc withTaskGroup, để tạo ra các Group Task. Với mỗi async let được xem như là một Task con, hoặc các function async cũng xem là một Task con. Bạn sử dụng group.addTask { ... } để thêm chúng vào.
 */
func printMessage() async {
    let string = await withTaskGroup(of: String.self) { group -> String in
        group.addTask { "Hello" }
        group.addTask { "From" }
        group.addTask { "A" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        for await value in group {
            collected.append(value)
        }

        return collected.joined(separator: " ")
    }

    print(string)
}

// thực thi
Task {
    await printMessage()
}
/*:
 Ưu điểm của Group Task sẽ giúp bạn quản lý các task con tốt hơn. Chủ động cancel chúng hoặc xử lý giá trị trả về của các task con ...
 
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:

 * https://fxstudio.dev/task-task-group-trong-10-phut-swift-5-5/
 */
/*:
 ## Sendable Types
 
 Để phục vụ cho các function và API của Concurrency, chúng ta cần phải có kiểu dữ liệu phù hợp với chúng. Đó là Sendable Type.
 
 > Sendable Type là kiểu dữ liệu mà có thể được chia sẽ một cách an toàn trong Concurrency.
 
 Apple định nghĩa chúng với Sendable Protocol và được tích hợp sẵn vào các kiểu dữ liệu cơ bản (như: Int, String, Float ...). Còn với các kiểu dữ liệu của riêng bạn thì cần thuân thủ Sendable Protocol khi khai báo.
 */
final class User: Sendable {
    let name: String
    init(name: String) {
        self.name = name
    }
}
/*:
 Cuối cùng là @Sendable closure, sẽ sử dụng trong khai báo các function với các tham số là closure. Và cũng để đảm bảo các function & closure được an toàn trong các thread đồng thời.
 
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:
 
 * https://fxstudio.dev/sendable-protocol-sendable-trong-10-phut-swift-5-5/
 */
/*:
 ## Unstructured Concurrency
 
 Đây là cách bạn tiếp cận với xử lý đồng thời linh hoạt nhất. Khi bạn hi sinh logic và cấu trúc các tiến trình bất đồng bộ để lấy sự đơn giản. Bạn có thể áp dụng nó ở bất cứ ngữ cảnh nào trong project của bạn, mà không thay đổi tới cấu trúc code hiện tại.
 
 Ngoài ra, Unstructured Concurrency vẫn giúp bạn kiểm soát được các tác vụ của mình. Có thể lưu trữ, lấy giá trị và hủy bỏ.
 
 Chúng ta có 2 cách tiếp cận tới Unstructured Concurrency như sau:
 */
/*:
 ### Task
 
 
 Khi bạn sử dụng Tác vụ {}, bạn thực sự đang khởi chạy một tác vụ đồng thời. Đây là cách thực hiện cầu nối giữa thế giới bất đồng bộ và đồng bộ hóa.
 */
Task {
    print("hello")
}
/*:
 Bạn có thể lưu trữ chúng trong các biến để có thể hủy chúng theo cách thủ công khi cần thiết. Chúng ta có thể khai báo một thuộc tính với kiểu dữ liệu là Task<T, Error>.
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
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:
 
 * https://fxstudio.dev/unstructured-concurrency-swift-5-5/
 */
/*:
 ### Detached Task
 
 Cách bạn tạo ra một task mới không thuộc các task đang chạy. Nó hoàn toàn độc lập và không chịu sự ảnh hưởng của các task cha nó. Bằng cách sử dụng:
 */
Task.detached {
    print("hello 2")
}
/*:
 
 Không giống như các loại nhiệm vụ khác, chúng không kế thừa bất kỳ thứ gì từ nhiệm vụ mẹ của chúng. Thậm chí không phải là ưu tiên. Chúng độc lập với bối cảnh mà chúng được khởi chạy.
 
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:
 
 * https://fxstudio.dev/detached-tasks-swift-5-5/
 */
/*:
 ## Actors
 
 Vấn đề sẽ phát sinh với dữ liệu khi xử lý bất đồng bộ & đồng thời, đó là Data Race. Khái niệm mới cho một kiểu dữ liệu mới được ra đời nhằm giải quyết vấn đề trên.
 
 Actor là một dữ liệu tham chiếu (reference type) mà bảo vệ việc truy cập vào các trạng thái có thể thay đổi được của nó. Trạng thái của tác nhân (Actor) chỉ được truy cập bởi một luồng duy nhất tại bất cứ thời điểm nào. Giúp loại bỏ đi nhiều lỗi nghiêm trọng ngay ở level compiler.
 
 Tóm tắt lại các đặc điểm của một Actor đó là:

 * Là một kiểu dữ liệu tham chiếu, tương tự như class
 * Các thuộc tính của nó sẽ được đảm bảo an toàn
 * Chỉ cho phép mỗi thời điểm chỉ một thread có thể truy cập được.
 */
actor MyNumber {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    func show() {
        print(value)
    }
}
/*:
 Làm việc với Actor thì bạn cần sẽ phải tìm hiểu thêm các khái niệm isolate và các tương tác với Actor nữa. Để tìm hiểu nhiều hơn thì đọc thêm bài viết này:
 
 * https://fxstudio.dev/co-ban-ve-actor-trong-10-phut-swift-5-5/
 */
/*:
 ## @MainActor and Global Actors
 
 Đây là sự nâng câp của Actor, khi các đối tượng chính sẽ được sử dụng ở Main Thread. Mục đích duy nhất là giải quyết các bài toán liên quan tới giao diện ứng dụng.
 
 Chúng ta sẽ đọc qua 2 bài viết để giải quyết 2 vấn đề cốt lõi ở Main Thread:
 
 * Với UI: https://fxstudio.dev/mainactor-va-dieu-gi-xay-ra-voi-ui-tren-main-thread/
 * Với Data: https://fxstudio.dev/mainactor-va-dieu-gi-xay-ra-voi-data-tren-main-thread/
 */
/*:
 ## Sharing Data with @TaskLocal
 
 Về định nghĩa, TaskLocal Property Wrapper hay @TaskLocal là một Property Wrapper. Với giá trị của TaskLocal thì có thể đọc & ghi được từ ngữ cảnh của một Task. Nó được hiểu chia sẽ ngầm định và truy cập được từ bất kỳ Task con nào mà Task cha đó tạo ra.
 */
class ViewController: UIViewController {
    
    @TaskLocal static var currentName: String?
    
    //....
}
/*:
 Property wrapper @TaskLocal có thể được sử dụng để chia sẻ dữ liệu trong tác vụ cục bộ. Quản lý được việc chia sẽ dữ liệu cho các Task con trong cùng một Task Tree. Cô lập dữ liệu chia sẽ khi xử lý bất đồng bộ & đồng thời tại nhiều Task Tree.
 
 Để biết thêm về chúng thì bạn đọc thêm bài viết này:
 
 * https://fxstudio.dev/tasklocal-property-wrapper-swift-5-5/
 */
/*:
 ## Tạm kết
 
 * Tìm hiểu các khái niệm Concurrency mới trong Swift 5.5
 * Lộ trình tìm hiểu chúng theo từng bước
 * Khái niệm, cách hoạt động & ứng dụng của từng khái niệm mới
 */
