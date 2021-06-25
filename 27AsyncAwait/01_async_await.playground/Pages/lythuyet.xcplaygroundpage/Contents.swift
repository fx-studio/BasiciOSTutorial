import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
/*:
 # Cơ bản về async/await trong 10 phút - Swift 5.5
 
 Bài viết mang tính chất liệt kê những gì bạn cần nắm bắt nhanh về một phần rất là mới được Apple ra mắt vào WWDC21. Đó là async/await.
 */
/*:
 ---
 ## 1. Vấn đề với Completion Handle
 
 Commletion Handle là thứ mà bạn và các đồng nghiệp iOS developer của bạn đã và đang dùng ngày qua ngày. Hầu như nó là một phần máu thịt đối với mỗi dev iOS rồi. Điểm hình như:
 * Trả về một Callback
 * Thay thế các Delegate & DataSource
 * Trả Result về trong thương tác connect API/Webservice
 * Các xử lý tính toán logic khác
 
 ### 1.1. Ví dụ
 
 Cách truyền thống với Completion Handle. Ví dụ: ta có 2 hàm xử lý với closure để trả kết quả về
 */
func cong(a: Int, b: Int, completion: @escaping (Int) -> Void) -> Void {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        completion(a + b)
    }
}
func nhan(a: Int, b: Int, completion: @escaping (Int) -> Void) -> Void {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        completion(a * b)
    }
}
/*:
 Sau một thời gian là 3 giây thì trả kết quả về. Ta sử dụng chúng xem ổn không nhoé.
 */
let A = 10
let B = 20
// Gọi đơn giản
cong(a: A, b: B) { result in
    print("cộng OKE nè : \(result)")
}
// Gọi lồng nhau
cong(a: A, b: B) { result in
    print("cộng OKE nè : \(result)")
    
    nhan(a: A, b: B) { result in
        print("nhân OKE nè : \(result)")
        
        cong(a: A, b: B) { result in
            print("cộng OKE 2 nè : \(result)")
            
            nhan(a: A, b: B) { result in
                print("nhân OKE 2 nè : \(result)")
            }
        }
    }
}
/*:
 Việc gọi lồng nhau như thế này, người ta gọi là Kim tử tháp huỷ diệt.
 
 >Bạn thấy việc lồng nhau như vậy ổn không? Và bạn dám chắc là bạn có quản lý việc gọi lẫn nhau đó tốt không?
 
 ### 1.2. Vấn đề khác
 
 Qua ví dụ trên thì bạn sẽ thấy một số điều bất hợp lý trong Completion Handle với Closure
 * Gọi completion có thể được gọi nhiều lần hoặc không gọi do quên
 * Thêm từ khoá `@escaping` nếu function là bất đồng bộ. Khó tiếp cận và sẽ rối với những bạn mới vào nghề
 * Nếu như gọi nhiều function với Completion Handle liên tiếp, để nhằm mục đích là chờ hàm này xong rồi mới thực hiện hàm kia.
    * Gây khó chịu trong cú pháp gọi.
    * Nhiều closure lồng nhau.
    * Khó quản lý lỗi
    * Quên gọi Completion thì sẽ bock các phần còn lại
 * Với `Result` type trong Swift 5.0 thì sẽ khó trong việc *Callback* lại Error
 */
/*:
 ---
 ## 2. ASYNC/AWAIT
 
 Qua những lý do trên mà `Swift 5.5` đã cung cấp thêm 2 từ khoá `async` & `await` trong việc khai báo và gọi function.
 
 Cho phép chúng ta chạy các đoạn code bất đồng bộ nếu chúng chạy bất đồng bộ.
 
 Các dùng khá là EZ:
 * Dùng `async` trong khai báo function
 * Dùng `await` trong gọi thực thi function
 
 ### 2.1. Cú pháp
 
 * Khai báo function với `async`
 */
func somefunction() async -> Void {
    // bla bla bla
}
/*:
 Cách thực thi cũng chia ra làm 2 loại:
 * Gọi trong code đồng bộ để thực thi function với `await`. Cần có `async { }` để bọc lại.
 */
async {
    await somefunction()
}
/*:
 * Gọi thực thi trong một function bất đồng bộ khác
 */
func anotherFunction() async {
    await somefunction()
}
/*:
 Ta hãy xem với việc viết lại 2 function trên với `async/await` như thế nào. Có thêm trường hợp function có trả giá trị về.
 */
func cong(a: Int, b: Int) async -> Int {
    a + b
}

func nhan(a: Int, b: Int) async -> Int {
    a * b
}
/*:
 Khá là đơn giản phải không nào. Giờ chúng ta tiếp tục thực hiện việc gọi function đó chạy xem kết quả tra sao.
 */
func tinh() async {
    let A = 10
    let B = 20
    print("... #1")
    let Cong = await cong(a: A, b: B)
    print("... #2")
    let Nhan = await nhan(a: A, b: B)
    print("2 kết quả nè: \(Cong) & \(Nhan)")
}
/*:
 Bạn thấy chúng ta đã gọi các hàm `cong` & `nhan`. Với từ khoá `await` thì chương tình sẽ dừng chờ tới khi nào function kia thực hiện xong và trả kết quả về. Sau đó, dòng lệnh tiếp heo mới được thực thi.
 */
/*: Nhớ import thêm UIKit để chạy `async { }` nhé, nếu bạn là người chơi hệ PlayGround. */
async {
    await tinh()
}
/*:
 Khi thực thi hàm `tinh()` thì:
 * Chương trình dùng chờ lại dòng tính `Cong`, sau đó thì chạy dòng lệnh tiếp theo.
 * Chương trình tiếp tục với `Nhan`và cũng tính chờ.
 * Khi cả 2 biến có đầy đủ giá trị thì lệnh `print` cuối cùng mới đc thực thi.
 */
/*:
 ### 1.3. Quy tắc
 
 Ta cũng có một số quy tắc sau cho `async/await`

 * Các hàm đồng bộ `Synchronous` sẽ không gọi trực tiếp được các hàm bất đồng bộ
 * Các hàm bất đồng bộ có thể gọi được các hàm bất đồng bộ khác và các hàm đồng bộ bình thường khác
 * Nếu các hàm đồng bộ & bất đồng mà giống nhau về cách gọi hàm. Thì Swift sẽ dựa vào ngữ cảnh để gọi.
 */
/*:
 ---
 ## 3. ERROR
 
 Với Completion Handle mà cụ thể ở đây là bạn sẽ sử dụng Closure. Chúng ta hầu như sẽ không `throw error`. Thay vào đó, ta lại ném chúng thành đối số cho việc gọi `closure` để call back trở lại.
 
 > Điều này nó hơi phản khoa học một chút. Tuy nhiên, mọi người vẫn nhắm mắt mà làm.
 
 Còn với `async/await`, bạn có thể giải toả nỗi lo này rồi.
 
 * Khi đưa ra `async/await` thì bạn có thể dùng với `try/catch`
 * Bạn có thể `throw` error trong các function bất đồng bộ hoặc khới tạo bất đồng bộ
 * Thứ tự `throw` lỗi sẽ ngược lại với thứ tự gọi hàm
 */
/*:
 ### 3.1. Ví dụ khai báo hàm với `async throws`
 */
/*:
 Khai báo một enum Error cho riêng mình sài.
 */
enum MyError : Error {
    case soBeHon
    case soAm
    case bangKhong
}
/*:
 Thêm 2 function mới. Hai function này có việc kiểm tra điều kiện nhập số và nếu không thoải điều kiện thì ta sẽ `throw` lỗi.
 */
func tru(a: Int, b: Int) async throws -> Int {
    if a < b {
        throw MyError.soBeHon
    } else {
        return a - b
    }
}

func chia(a: Int, b: Int) async throws -> Float {
    if b == 0 {
        throw MyError.bangKhong
    } else {
        return Float(a) / Float(b)
    }
}
/*:
 ### 3.2. Cách sự dụng với `try await`
 
 Thì cũng khá đơn giản khi bạn kết hợp giữa 2 cái cơ bản:
 * Cú pháp `do catch` và `try` để cố gắng thực hiện việc gì đó mà sẽ có lỗi
 * `await` dùng để chờ hàm bất đồng bộ hoàn thành công việc của nó
 */
func tinh2() async {
    let A = 30
    let B = 20
    
    do {
        print("... #1")
        let Tru = try await tru(a: A, b: B)
        print("... #2")
        let Chia = try await chia(a: A, b: B)
        print("2 kết quả nè: \(Tru) & \(Chia)")
    } catch {
        print("Lỗi nhoé!")
    }
}
/*:
 Cách gọi hàm trong code đồng bộ.
 */
async {
    await tinh2()
}
/*:
 Bạn tự thay đổi giá trị ban đầu để xem chúng nó thay đổi gì nha.
 
 ### 3.3. Ý nghĩa
 * Khi thêm việc `throw error` giúp cho bạn cải thiện nhiều hơn về mặt diễn giải logic của code. Và giúp làm cho kiểu `Result` bớt đi áp lực mà nó phải gánh khi bạn có nhiều loại Error và đôi lúc bạn phải miễn cưỡng chấp nhận nó.
 * Sử dụng chúng thì không làm cho code của bạn trở lên magic hơn. Mà chỉ giúp bạn giảm tải đi rất nhiều code lồng nhau khi gọi liên tiếp nhiều hàm bất động bộ mà thôi.
 * Theo khuyến khích của Apple thì bạn không nên gọi hàm bất động bộ trong các hàm đồng bộ. Nếu bất khả khán thì hãy dùng `async { ... }` nhoé
 */
/*:
 ---
 ## 4. Checked Continuation
 
 Phần này, mình sẽ trình bày về cách sử dụng các đoạn mã đồng bộ với các tác vụ bất đồng bộ, bằng cách sử dụng `async`.
 
 > Nghe hơi khó hiểu phải không nào.
 
 Nôm na phần này, bạn sẽ sử dụng khá là hay khi việc tương tác API kết hợp với `async/await` cho nó hợp thời thượng.
 Chúng ta sẽ bắt đầu tìm hiểu qua các ví dụ sau:
 */
/*:
 ### 4.1. DispatchQueue truyền thống kết hợp với Closure
 */
/*:
 Khá đơn giản phải không hè. Bạn chỉ cần khai báo 1 enum cho Error
 */
enum APIError: Error {
    case anError
}
/*:
 Bạn viết thêm 1 function. Ở đây, bạn giả định đây làm hàm gọi API nha. Với
 * `completion` trả về result
 * `@escaping` để không bị mất đi khi thực hiện bất đồng bộ.
 * kiểu trả về là `Void` với hệ người chơi vô trách nhiệm
 */
func fetchLatestNews(completion: @escaping ([String]) -> Void) {
    DispatchQueue.main.async {
        completion(["Swift 5.5 release", "Apple acquires Apollo"])
    }
}
/*:
 Sử dụng thì như sau
 */
fetchLatestNews { strings in
    for str in strings {
        print(str)
    }
}
/*:
 Cũng không có gì phức tạp hết. Ahihi! mục đích giúp bạn hồi tưởng lại kiến thức thôi.
 */
/*:
 ### 4.2. async/await
 Với `async/await` khi bạn sử dụng với function trên thì vẫn ổn. Nhưng nếu bạn sử dụng một thư viện bên ngoài (nhất là cái liên quan tới connect API), bạn khó lòng thay đổi lại nội của nó.
 > Mục đích là cho nó hợp thời mà thôi nhoé.
 
 Tiếp theo, bạn cũng biết được rằng `async func` thì sẽ chỉ được triệu hồi bởi các function bất đồng bộ mà thôi.
 
 Và nếu, bạn phải sử dụng code đồng bộ bình thường. Thì nó là một vấn đế khá đau đầu nhoé.
 
 Tất nhiên, ta sẽ có một giải pháp mới cung cấp cho việc kết hợp `async code` & `sync code` với nhau:
 * `withCheckedContinuation()` giúp bạn tiếp tục sử dụng để triệu hồi bất đồng bộ trong đồng bộ
 * `resume(returning:)` giúp bạn trả về giá trị mong muốn
 */
/*:
### 4.3. Checked Continuation
 
 Viết lại cái trên theo cách 1 (thay thế hoàn toàn). Bạn sẽ khác biệt một tí.
*/
func fetchLatestNews() async -> [String] {
   await withCheckedContinuation({ c in
       c.resume(returning: ["Fx", "Studio"])
   })
}
/*:
 > Chúng ta từ bây giờ sẽ nói lời chia tay với DispatchQueue là được rồi.
 
 Đó là điểm khác biệt mà `async/await` mang tới cho bạn. Mọi việc sẽ đơn giản hơn cho bạn. Tiếp theo, bạn xem cách thực thi function đó như thế nào. (À cũng giống như trên thôi)
 */
async {
   let items = await fetchLatestNews()
   for item in items {
       print(item)
   }
}
/*:
 Tiếp tục demo lại với việc triệu hồi function trong vỏ `async`. Có điểm khác biệt đó là:
 * Bạn không còn phải lo lắng khi nào có `@escaping` nữa. Vì đã là bất đồng bộ thì với khai báo `async` thì nó sẽ hoạt động theo bất đồng bộ.
 * Kết quả nhận được sẽ chờ `await` sau khi hàm xử lý xong và trả về.
 * Các đoạn code ở dưới vẫn chạy tốt và không có crash. Bởi vì nó chờ hàm bất đồng bộ thực thi xong trước rồi.
 */
/*:
 ### 4.4. With Error
 
 Ta sẽ tiếp tục thực thi code bất đồng bộ trong đồng bộ mà có thể sinh ra lỗi. Một điều cũng khá hiển nhiên, khi bạn thực thi một việc gì đó và có nguy cơ sinh ra lỗi.
 
 Bạn chỉ cần thêm `async throws` cho function bất đồng bộ để có thể nén lỗi về lại. Tham khảo ví dụ dưới nha.
 */
func fetchLatestNews2() async throws -> [String] {
   try await withCheckedThrowingContinuation({ c in
       /// chỗ này bạn gọi API nè
       fetchLatestNews { items in
           if Bool.random() {
               /// Giả sử đúng là API trả về kết quả nhoé
               c.resume(returning: items)
           } else {
               /// Đây là chỗ bạn trả về lỗi nhoé
               c.resume(throwing: APIError.anError)
           }
       }
   })
}
/*:
 Các sử dụng như sau:
 */
async {
   do {
       let items = try await fetchLatestNews2()
       for item in items {
           print(item)
       }
   } catch {
       print("Lỗi nè")
   }
}
/*:
 Mọi thứ cũng không có gì phức tạp, thêm `do catch` để bắt các error mà thôi.
 
 Cuối cùng, bạn hãy thử nghiệm với `resume` 2 lần trong `withCheckedContinuation`. Xem điều kì diệu là gì?
 */
/*:
 ---
 ## 5. Unsafe Continuation
 
 Chúng ta sẽ thử nghiệm nó với việc không kiểm tra tại thời điểm runtime. Với cách dùng này thì bạn sẽ thoải mái hơn nhiều. Mà việc check với `safe` không làm được.
 
 * `resume` được nhiều lần. Nhưng sẽ hên xui
 *  Tăng được tốc độ runtime
 */
/*:
 Kiểm tra tiếp với việc triệu hồi `resume` 2 lần ở function trên.
 */
func fetchLatestNews3() async -> [String] {
    await withUnsafeContinuation({ uc in
        uc.resume(returning: ["Fx2", "Studio2"])
        uc.resume(returning: ["Fx3", "Studio3"])
    })
}
/*:
 Thực thi nhoé, chương trình của bạn vẫn bình an vô sự.
 */
async {
    let items = await fetchLatestNews3()
    for item in items {
        print(item)
    }
}
/*:
 **Lưu ý:**
 * Cần có `resume` nên không sẽ bị leak bộ nhớ. Còn nếu 2 lần thì có sự cố nhoé
 * Swift sẽ báo cho bạn biết `resume` nếu bị gọi 2 lần.
 * Nếu bạn mặc kệ dòng đời và méo quan tâm `runtime` như thế nào thì hãy dùng `withUnsafeContinuation()`
 * Tại playground thì nó chiếm sóng cái kia, nên bạn hãy cẩn thận khi dùng chúng nhoé
 */
/*:
 ---
 ## TẠM HẾT
 */
