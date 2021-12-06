import UIKit
/*:
 # AsyncStream
 
 Chào mừng bạn đến với Fx Studio. Chúng ta đã lăn lộn qua nhiều khái niệm mới trong New Concurrency của Swift 5.5 rồi. Và lần này, chúng ta lại tiếp tục với một khái niệm mới nữa. Đó là AsyncStream. Nó sẽ giúp bạn đơn giản hóa AsyncSequence đi rất nhiều và tính ứng dụng sẽ rất là cao
 
 Nếu mọi việc đã ổn rồi, thì ...
 
 > Bắt đầu thôi!
 */
/*:
 ## AsyncStream là gì?
 
 Chúng ta đã có AsyncSequence được giới thiệu trong Swift 5.5 và thuộc vũ trụ New Concurrency mới của Swift. Bạn sẽ nhận được các giá trị theo Sequence ở các thời điểm khác nhau & bất đồng bộ. Apple cũng đưa ra tiếp một khái niệm nữa, đó là AsyncStream. Mục đích làm cho việc tạp ra một một Chuỗi bất đồng bộ một cách đơn giản nhất.
 
 > Mọi thứ lúc này bạn tưởng tưởng như là một dòng chảy. Với các dữ liệu được gởi tới tại những thời điểm khác nhau mà ta không biết được.
 
 Về bản chất thì AsyncStream cũng tuần thủ AsyncSequence Protocol. Nó tạo ra các giá trị từ 1 closure cung cấp cho nó. Tại closure đó, bạn sẽ thoải mái với logic của bạn. Với đặc điểm này, AsyncStream giúp đơn giản hóa đi rất nhiều độ phức tạp trong code của bạn. Tất nhiên, AsyncStream cũng kế thừa lại các đặc tính của AsyncSequence.
 
 ### Khởi tạo
 
 Như giới thiệu ở trên, thì bạn sẽ có 2 cách tạo cơ bản để có một AsyncStream:
 
 * init(_:bufferingPolicy:_:) : cũng là cách hay sử dụng nhất. Closure sẽ sử dụng một thứ gọi là continuation, để trả giá trị về. Việc này có thể thực hiện được nhiều lần. Bạn có thêm một tùy chọn bộ đệm để giới hạn việc lưu trữ.
 * init(unfolding:onCancel:) : Một Steam mới cũng sẽ được tạo ra băng việc cung cấp cho nó một Closure. Tuy nhiên, chúng ta sẽ trả giá trị về bằng return trong closure. Bạn cũng có thêm một closure tùy chọn nữa, đó là onCancel khi nó bị hũy.
 
 Chúng ta sẽ tìm hiểu cả 2 cách khởi tạo AsyncStream này qua các ví dụ ở các phần dưới. Bạn yên tâm là chúng rất đơn giản và dễ hiểu.
 */
/*:
 ## Ví dụ cơ bản với AsyncStream
 
 Bắt đầu, chúng ta sẽ tạo một function trả về một Stream. Để trả về một Async Stream thì bạn cần phải cung cấp kiểu dữ liệu cho Stream nhóe. Ví dụ với khai báo sau:
 
 ```
 func make123StarStream() -> AsyncStream<Int> { ... }
 ```
 
 Bạn sẽ có một Stream với các giá trị trả về là kiểu Int. Khá đơn giản phải không nào. Tiếp theo, bạn sẽ xem qua việc triển khai function trên là như thế nào. Xem tiếp ví dụ code nhóe!
 */
func make123StarStream() -> AsyncStream<Int> {
    AsyncStream { continuation in
        // #1
        continuation.onTermination = { @Sendable termination in
            switch termination {
            case .finished:
                print("⭐️⭐️⭐️")
            case .cancelled:
                print("❌")
            }
        }
        
        // #2
        Task.detached {
            for n in 1...3 {
                continuation.yield(n)
                sleep(2)
            }
            
            continuation.finish()
        }
        
    }
}
/*:
 Trong đó:
 
 * Chúng ta sử dụng cách khởi tạo với continuation. Nó sẽ là trung tâm của cả toàn bộ quán trình.
 * Phần #1 sẽ theo dõi quán trình kết thúc của Stream. Về kết thúc thì có 2 trường hợp, kết thúc toàn bộ các giá trị hoặc là chủ động hủy Stream
 * Phần #2 sẽ tạo ra một Task mới. Nhiệm vụ của nó là liên tục phát đi các giá trị trong vòng lặp cứ sau mỗi 2 giây.
 * continuation.yield(n) dùng để phát giá trị đi.
 * continuation.finish() dùng để kết thúc toàn bộ Stream
 
 Bạn sẽ cần khai báo thêm cho closure của onTermination là một kiểu Sendable. Đó là yêu cầu từ Swift, nhằm tránh data race trong quá trình bất đồng bộ diễn ra. Cuối cùng, bạn sẽ thực thi function đó như sau:
 */
Task {
    for await n in make123StarStream() {
      print("\(n) ...")
    }
    print("DONE")
}
/*:
 Bạn sẽ thấy cách sử dụng AsyncStream rất giống với AsyncSequence không nào. Ta sẽ dùng một vòng lặp và đợi các giá trị từ Stream trả về. Qua ví dụ, bạn đã có thể tự tin với AsyncStream rồi đó. Mấu chốt của phần này là bạn sử dụng:

 * continuation để diễn đạt logic
 * Kết thúc cả quá trình bằng .finish()
 */
/*:
 ## Đơn giản hóa AsyncSequence
 
 Ví dụ tiếp theo, bạn sẽ thấy việc đơn giản hóa đi rất nhiều khi bạn tạo ra một kiểu dữ liệu mới thuân thủ AsyncSequence Protocol. Chúng ta sẽ hồi tưởng lại ví dụ AsyncSequence ở bài trước nhóe.
 
 ```
 copy code bài trước
 ```
 
 Còn với AsyncStream, thì trông nó như sau:
 */
var phrase = "Fx Studio"
var index = phrase.startIndex
let stream = AsyncStream<String> {
    guard index < phrase.endIndex else { return nil }
    
    do {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    } catch {
        return nil
    }
    
    defer { index = phrase.index(after: index) }
    return String(phrase[phrase.startIndex...index])
}
/*:
 Cùng một công việc nhưng với AsyncStream thì code bạn đơn giản đi rất nhiều. Không cần tạo thêm các kiểu dữ liệu mới đi kèm theo AsyncSequence. Và bạn chú ý đoạn code trên có:
 
 * Tạo một Stream bằng việc return giá trị từ closure
 * Bạn sẽ cần tới giá trị nil để kết thúc toàn bộ quán trình. Đây cũng là điểm quan trọng nhất trong phương pháp này.
 
 Một điểm khác nữa so với ví dụ trên, là bạn có thể tạo ra một đối tượng AsyncStream. Dùng nó để tương tác hoặc lấy giá trị từ nó. Lúc này, bạn sẽ có một đối tượng sẽ mang đầy đủ các thuộc tính và tính chất của một chuỗi (Sequence) trong Swift.
 
 Thực thi ví dụ nhóe!
 */
Task {
    for try await item in stream {
        print(item)
    }
}
/*:
 ## AsyncThrowingStream với API
 
 Cái hay của AsyncStream đó là tính ứng dụng rất cao. Bạn có thể áp dụng nó vào các project và bài toán giao diện. Như tạo các Counter, lắng nghe các Notification ... Hoặc có thể sử dụng để theo dõi cập nhật từ các CLLocationManager trong project. Nhưng mình sẽ tạm thời quan tâm tới ứng dụng cụ thể hơn. Đó là tương tác với API.
 
 ### Tương tác với một API
 
 Người anh em song sinh với AsyncStream là AsyncThrowingStream. Mang đầy đủ tính chất của AsyncStream. Nhưng bạn sẽ thêm các tính năng kết thúc với một lỗi (error). Nó phát huy hiện quả trong các bài toán có thể phát sinh ra lỗi trong quán trình thực thi. Một trong đó là việc tương tác với API.
 
 Để khởi tạo chúng bạn sẽ cần cung cấp 2 liểu dữ liệu cho AsyncThrowingStream. Gồm:
 
 * Kiểu dữ liệu chính cho giá trị trả về
 * Kiểu Error cho việc trả về lỗi
 
 Ví dụ khai báo với function như sau:
 
 ```
 func loadAPI(url: URL) -> AsyncThrowingStream<Data, Error> { ... }
 ```
 
 Tiếp theo, cúng ta sẽ hoàn thiện function trên nhóe. Xem code ví dụ như sau:
 */
func loadAPI(url: URL) -> AsyncThrowingStream<Data, Error> {
    AsyncThrowingStream { continuation in
        
        continuation.onTermination = { @Sendable termination in
            switch termination {
            case .finished:
                print("Finised")
            case .cancelled:
                print("Cancel")
            }
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                continuation.yield(data)
                continuation.finish(throwing: nil)
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
}
/*:
 Trong đó:
 
 * Sử dụng kiểu continuation để diễn đạt logic của bạn
 * continuation.yield(data) trả giá trị về
 * Kết thúc với lỗi thì sử dụng continuation.finish(throwing: error)
 
 Nếu bạn sử dụng nil cho việc kết thúc continuation.finish(throwing: nil) thì cũng sẽ kết thúc toàn bộ Stream luôn nhóe. Nếu bạn không sử dụng tới nil thì Stream vẫn ở đó và sẽ không kết thúc, nên bạn hãy chú ý kĩ vấn đề này.
 
 Khá đơn giản cho việc tương tác với API. Cuối cùng, bạn xem cách mà chúng ta thực thi AsyncThrowingStream nhóe.
 */
let url = URL(string: "https://fxstudio.dev/")
Task {
    do {
        for try await data in loadAPI(url: url!) {
            print("Total: \(data.count)")
        }
    } catch {
        print(error.localizedDescription)
    }
}
/*:
 Giá trị sẽ nhận được trong vòng for và error nhận được ở phần catch. Chạy đoạn code trên và tự cảm nhận kết quả nhóe.
 */
/*:
 ### Tương tác với nhiều API
 
 Thực sự bài toán tương tác với 1 API vẫn chưa phát huy được toàn bộ thế mạnh của AsyncStream & AsyncThrowingStream. Chúng ta sẽ nâng cấp bài toàn với việc tương tác đồng thời nhiều API. Tuy nhiên, bạn cần phải xác định kiểu giá trị trả về của tất cả API là đồng nhất với nhau. Để đảm bảo việc khái báo cho AsyncThrowingStream nhóe.
 
 Xem ví dụ khai báo lại function tương tác API với nhiều URL cung cấp cho nó.
 
 ```
 func loadAPI(urls: [URL]) -> AsyncThrowingStream<Data, Error> { ... }
 ```
 
 Hầu như, bạn sẽ không phải thay đổi nhiều về kiểu giá trị trả về. Chỉ thay đổi lại tham số cho function từ 1 URL thành 1 Array URL mà thôi. Chúng ta tiếp tục hoàn thiện function ở trên nhóe.
 */
func loadAPI(urls: [URL]) -> AsyncThrowingStream<Data, Error> {
    AsyncThrowingStream { continuation in
        Task {
            do {
                for url in urls {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    continuation.yield(data)
                }
                
                continuation.finish(throwing: nil)
                
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
}
/*:
 Hầu như toàn bộ phần khung sẽ được giữ lại. Bạn chỉ cần lặp các giá trị của urls và trả giá trị về bằng continuation.yield(data). Và chỉ có như vậy thôi. Chúng ta sẽ không quan tâm nhiều tới những thứ linh tinh trước đây như là call back, delegate, thread ....
 
 Cách sử dụng thì như sau:
 */
let urls = [
    URL(string: "https://fxstudio.dev/")!,
    URL(string: "https://www.youtube.com/c/FxStudioDev")!,
    URL(string: "https://www.facebook.com/FxStudio.Dev")!,
    URL(string: "https://github.com/fx-studio")!,
]

Task {
    do {
        for try await data in loadAPI(urls: urls) {
            print("Total: \(data.count)")
        }
    } catch {
        print(error.localizedDescription)
    }
}
/*:
 Với ví dụ này, bạn sẽ thấy được ý nghĩa của vòng for cho AsyncStream nhiều hơn rồi. Và vẫn còn nhiều thứ hay ho nữa từ New Concurrency. Hẹn gặp lại bạn ở các bài viết tiếp theo!
 */
/*:
 ## Tạm kết
 
 * Tìm hiểu về AsyncStream & AsyncThrowingStream. Khởi tạo & cách sử dụng chúng
 * Sử dụng AsyncStream trong việc đơn giản hóa AsyncSequence
 * Áp dụng AsyncThrowingStream vào bài toán tương tác với API
 */
