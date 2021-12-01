import UIKit

/*:
 # Async Sequence
 
 Chào mừng bạn đến với Fx Studio. Hành trình khám phá của chúng ta trong thế giới New Concurrency của Swift 5.5 vẫn còn rất dài. Lần này, chủ đề là AsyncSequence trong Swift. Cũng là một khái niệm mới được thêm vào. Nó mang trong mình một tham vọng rất là hơn của Swift, nhằm định hình cả tương lai hệ sinh thái Apple.
 
 Nếu mọi việc đã ổn rồi, thì ...
 
 > Bắt đầu thôi!
 */
/*:
 ## AsyncSequence là gì?
 
 Khái niệm về AsyncSequence cũng rất đơn giản.
 
 > AsyncSequence = Async + Sequence
 
 Có nghĩa là bạn sẽ có một chuỗi (Sequence) giống như bao chuỗi bình thường khác trong Swift. Và bạn vẫn áp dụng được các Higher Order Functions cho nó và các thuộc tính & phương thức đặc trưng của một chuỗi.
 
 Điểm khác biệt ở đây là bạn sẽ dùng chúng vào bất đồng bộ. Bạn sẽ phải sử dụng await để chờ lấy giá trị của các phần tử trong AsyncSequence.
 
 Các Async Sequence sẽ được tạo ra bằng việc conform AsyncSequence protocol. Điều này hữu ích khi bạn muốn xử lý các giá trị theo trình tự của chuỗi mà giá trị của nó cần phải tính toán hoặc chờ đợi từ một nơi nào đó trả về. Bạn sẽ thấy sự tương đông của các Async Sequence như là các Task trong TaskGroup vậy.
 
 Qua trên, mình đã khái quá sơ lược nhất về Async Sequence cho bạn có một cái nhìn hình dung đầu tiên. Tuy nhiên, để hiểu nó rõ hơn thì chúng ta sẽ đi vào các ví dụ demo nhóe!
 */
/*:
 ## Ví dụ
 
 Chúng ta sẽ lấy ví dụ với function sau:
 */
func readData() async {
    //Get Path
    if let url = Bundle.main.url(forResource: "data", withExtension: "txt") {
        do {
            for try await line in url.lines {
                print(line)
            }
        } catch {
            print(error)
        }
    }
}
/*:
 Nhiệm cụ của function sẽ là đọc file data.txt. Nhưng có điểm đặc biệt là chúng ta sẽ sử dụng thuộc tính url.lines.
 
 Nó chính là một AsyncSequence, với kiểu dữ liệu khai báo AsyncLineSequence<URL.AsyncBytes>. Qua nó, bạn có thể đọc từng dòng của dữ liệu từ url.
 
 * Vì nó là một Sequence, nên chúng ta có thể loop từng phần tử của nó.
 * Vì nó là một Async, nên cần dùng await để truy cập giá trị của nó hay các phần tử của nó
 
 Bạn hãy tưởng tượng file data.txt này được lưu trử ở server và dữ liệu lấy về thông qua một API. Lúc này chúng ta sẽ không cần tới những tứ rườm ra như là callback, closure, delegate ...
 
 ## Các AsyncSequence trong SDK Apple
 
 Ngoài ra, apple cũng thêm các API sử dụng AsyncSequence trong SDK của Swift. Như:
 
 * FileHandle.standardInput.bytes.lines để đọc dữ liệu theo từng dòng
 * URL với lines hoặc bytes
 * URLSession với phương thức bytes(from:)
 * NotificationCenter để chờ nhận các tin nhắn mới, sử dụng kèm theo await (nó sẽ là một kiểu mới nữa nha)
 
 Đó là những API mà bạn sẽ hoặc sử dụng nhiều. Và vẫn còn nhiều thứ nữa được cập nhật, nhưng trong phạm vi bài viết thì mình chưa thể giới thiệu hết cho bạn biết.
 */
/*:
 ## Higher Order Functions
 
 Một trong những tính năng hay được sử dụng nhất của các chuỗi (Sequence) đó chính là kết hợp với các Higher Order Functions. Và AsyncSequence cũng kế thừa tính năng này nhóe.
 
 > Bạn đừng hiểu nhầm sang Reactive Programming như là RxSwift hay Combine nhóe.
 
 Ta sẽ nâng cấp tiếp ví dụ ở trên.
 */
struct MyItem {
    var number: Int
}

func readData2() async {
    if let url = Bundle.main.url(forResource: "data", withExtension: "txt") {
        do {
            
            let items = url.lines
                .map { Int($0) ?? 0 }
                .filter { $0 % 2 != 0 }
                .map { MyItem(number: $0) }
            
            for try await item in items {
                print(item.number)
            }
            
        } catch {
            print(error)
        }
    }
}
/*:
 Chúng ta sẽ khai báo thêm một struct MyItem để có được kiểu dữ liệu riêng của chúng ta. Và áp dụng các Higher Order Functions vào chính url.lines nhóe. Trong đó:
 
 * map lần 1 để biến AsyncBytes thành Int
 * filter để loại các phần tử lẻ
 * map lần 2 để biến đổi Int thành các MyItem
 
 Cuối cùng, bạn sẽ dùng items vào trong một vòng for để duyệt lần lượt các phần tử của nó. Mọi thứ hoạt động một cách nhịp nhàn với nhau. Bạn sẽ không cần lo lắng tới các việc handle, call back ...
 */
/*:
 ## AsyncSequence Protocol
 
 Như ví dụ trên thì url.lines là một AsyncSequence. Nó được conform với AsyncSequence Protocol. Do đó, bạn có thể tự tạo là một kiểu dữ liệu của riêng bạn là một AsyncSequence. Chỉ cần đơn giản là conform với AsyncSequence Protocol thôi nhóe.
 
 ### Khai báo
 
 Chúng ta sẽ tạo mới một kiểu dữ liệu là AsyncSequence nhóe. Bạn xem qua khai báo ở dưới đây.
 */
//struct Typing: AsyncSequence {
//    typealias Element = String
//
//    func makeAsyncIterator() -> AsyncIterator {
//        // ....
//    }
//}
/*:
 Ví dụ, khi báo struct Typing với conform AsyncSequence. Bạn sẽ cung cấp thêm kiểu dữ liệu chính cho Element. Và cung cấp thêm cho nó một function để thực hiện việc lặp, đó là makeAsyncIterator(). makeAsyncIterator() sẽ trả về một đối tượng với kiểu AsyncIteratorProtocol.
 
 ### AsyncIterator Protocol
 
 Đi kèm thì bạn cần thêm AsyncIterator Protocol để đảm đương nhiệm vụ lặp các phần tử trong Sequence. Công việc sẽ là:
 
 * Conform Protocol nữa là AsyncIteratorProtocol & 1 function để tạo ra đối tượng của Iteractor
 * function next() để tính toán phần tử tiếp theo. Function này sẽ là bất đồng bộ
 * Khi return bằng nil thì sẽ kết thúc Sequence này
 
 Chúng ta sẽ hoàn thiện struct Typing luôn nhóe!
 */
struct Typing: AsyncSequence {
    typealias Element = String
    
    let phrase: String
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var index: String.Index
        let phrase: String
        
        init(_ phrase: String) {
            self.phrase = phrase
            self.index = phrase.startIndex
        }
        
        mutating func next() async throws -> String? {
            guard index < phrase.endIndex else {
                return nil
            }
            
            await Task.sleep(1_000_000_000) //nano sec
            
            defer {
                index = phrase.index(after: index)
            }
            
            return String(phrase[phrase.startIndex...index])
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(phrase)
    }
}
/*:
 Nhiệm vụ của Typing sẽ là:
 * Nhập 1 câu hay 1 chuỗi String cho phrase
 * Tạo ra một Sequence từ bên ngoài có thể thấy được
 * Các phần tử có kiểu dữ liệu là String
 * Giá trị các phần tử là các String mới, được tạo theo các index tăng dần
 * Duyệt các phần tử tại next(), trong đó chúng ta có 1 hành động chờ 1 giây là bất đồng bộ
 * Return nil khi index đã duyệt hết chuỗi ban đầu và kết thúc cả quá trình
 
 Thực thi chương trình và cảm nhận kết quản nào!
 */
Task {
    for try await item in Typing(phrase: "Hello, Fx Studio!") {
      print(item)
    }
}
/*:
 Kết quả in ra thì như sau:
 
 ```
 H
 He
 Hel
 Hell
 Hello
 Hello,
 Hello,
 Hello, F
 Hello, Fx
 Hello, Fx
 Hello, Fx S
 Hello, Fx St
 Hello, Fx Stu
 Hello, Fx Stud
 Hello, Fx Studi
 Hello, Fx Studio
 Hello, Fx Studio!
 ```
 */
/*:
 ## Tạm kết
 
 * Giới thiệu khái niệm AsyncSequence và các đặc tính cơ bản của nó
 * Các AsyncSequence được cung cấp trong SDK
 * Kết hợp với các Higher Order Function
 * Tạo một kiểu AsyncSequence riêng của bạn, với AsyncSequence Protocol
 */
