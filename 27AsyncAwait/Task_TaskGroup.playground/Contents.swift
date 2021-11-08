import Foundation
import PlaygroundSupport
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true
/*:
 Nội dung:
 - Giới thiệu
 - Task
 - Task Group
 
 Tham khảo:
 - https://www.hackingwithswift.com/articles/233/whats-new-in-swift-5-5
 */

/*:
 ## Task
 
 Cập nhật từ Swift mới với Structured Concurrency thì bạn sẽ được cung cấp thêm 2 kiểu mới. Đó là `Task` & `TaskGroup`. Giúp chúng ta chạy các tác vụ đồng thời theo cách riêng lẻ hoặc nhóm lại.
 
 Ở dạng đơn giản nhất, bạn sẽ có `Task`. Tạo ra cho bạn một đối tưởng để thực thi tác vụ mà bạn mong muốn. Ngay lập tức thì nó sẽ dược thưc thi ngày tại background. Bạn có thể sử dụng `await` để đơn gián trị hoàn thành của nó trả về.
 
 ### Cú pháp
 
 Bạn xem qua cú pháp cơ bản của nó nhóe. Ví dụ như sau:
 */

let simpleTask = Task { () -> String in
    return "a simple task"
}

/*:
 
 > Task(priority: <#T##TaskPriority?#>, operation: <#T##() async -> _#>)
 
 Bạn sẽ thấy cú pháp khai báo 1 task sẽ cần:
 * cung cấp độ ưu tiên thực thi cho tham số `priority`
 * `operation` là công việc cần được thi thực.
 
 Mặc định thì công việc của bạn sẽ là function với `async` nhóe. Có thể có giá trị trả về hoặc không. Với ví dụ trên chúng ta sử dụng kiểu `String` trả về cho `operation`.
 
 Sử dụng ví dụ thì như sau:
 */

Task {
    print(await simpleTask.value)
}

/*:
 > Chú ý là việc sử dụng `async { }` đã thay thế bằng `Task.init` rồi nhóe!
 
Đơn giản là bạn tiếp tục tạo thêm 1 Task với kiểu Void để sử dụng kết quả của `simpleTask`. Hoặc bạn có thể sử dụng trong một function bất đồng bộ nào đó cũng được.
 */

func doSomething() async {
    print("Begin")
    print(await simpleTask.value)
    print("End")
}

Task {
    await doSomething()
}

/*:
 ### Áp dụng Task
 
 Tất nhiên, bạn sẽ áp dụng nó vào một bài toán cụ thể thì mới thấy được công dụng của nó nhiều hơn. Chúng ta lấy ví dụ của việc in ra 50 số Fibonacy đầu tiên nhóe.
 
 Bạn sẽ có function tìm một số fibonacy thứ n như sau:
 */
func fibonacci(of number: Int) -> Int {
    var first = 0
    var second = 1

    for _ in 0..<number {
        let previous = first
        first = second
        second = previous + first
    }

    return first
}

print(fibonacci(of: 15)) // số fibo thứ 15 là 610
/*:
 Function sẽ lặp từ 0 tới `number` lần, để xác định được số fibo thứ `number` đó. Có nghĩa bạn đang có 1 `for` để làm việc ấy. Và bạn sẽ nâng cấp độ khó của bài toán n lần khi in ra dãy 50 số fibo đầu tiên nhóe. Có nghĩa lần này là `for` lồng `for`
 */
func printFibonacciSequence() {
    var numbers = [Int]()

    for i in 0..<50 {
        let result = fibonacci(of: i)
        numbers.append(result)
    }
    
    print("🔵 The first 50 numbers in the Fibonacci sequence are: \(numbers)")
}

printFibonacciSequence()
/*:
  Điều này sẽ rất tốn tài nguyên của hệ thống. Vì tất cả công việc sẽ ném vào 1 thread và thưc thi lần lượt. Chúng ta sẽ giải quyết chúng bằng Task và cho chúng chạy đồng thời tại backgroud nhóe. Xem tiếp ví dụ nào!
 */
func printFibonacciSequence2() async {
    let task1 = Task { () -> [Int] in
        var numbers = [Int]()

        for i in 0..<50 {
            let result = fibonacci(of: i)
            numbers.append(result)
        }

        return numbers
    }

    let result1 = await task1.value
    print("⚪️ The first 50 numbers in the Fibonacci sequence are: \(result1)")
}

Task {
    await printFibonacciSequence2()
}

/*:
 Ví dụ trên các task tìm số fibo thứ n sẽ được chạy đồng thời với nhau. Tác vụ bắt đầu chạy ngay sau khi nó được tạo và hàm `printFibonacciSequence()` sẽ tiếp tục chạy trên bất kỳ chuỗi nào trong khi các số Fibonacci đang được tính toán.
 
 Ví dụ cao cấp hơn nhóe.
 */
let task1 = Task {
    (0..<50).map(fibonacci)
}

Task {
    print("🔴 The first 50 numbers in the Fibonacci sequence are: ")
    print(await task1.value)
}
/*:
 Bạn chú ý các hình tròn màu mà mình để trong các lệnh print nhóe. Chúng sẽ thể thứ tự thực thi các task lớn.:
 * Màu xanh là đồng bộ. Các task khác sẽ chờ nó làm xong
 * Màu đỏ sẽ hoàn thành trước vì cấp độ nó ngang cấp với màu xanh
 * Màu xanh thì sẽ tạo ra các child task bên trong nó. Nó sẽ hoàn thành khi tất cả các child task hoàn thành.
 */

/*:
 ### Task priority
 
 Khi tạo 1 task thì bạn sẽ được cung cấp các mức ưu tiên `priority` như sau:
 * high
 * default
 * low
 * background
 
 Mặc định khi bạn không cấp cho tham số `priority`, thì nó sẽ nhận là `default`. Đối chiếu sang hệ thống thì bạn sẽ có quy ước như sau:
 * userInitiated = high
 * utility = low
 * bạn không thể truy cập userInteractive, vì nó là main thread
 
 */

/*:
 ### Static methods
 
 Chúng ta có các phương thức tĩnh của Task, giúp bạn điều kiển các Task thuận lợi hơn.
 * `Task.sleep()` task hiện tại sẽ sang chế độ ngủ. Đơn vị thời gian là nano giây. Nghĩa là `1_000_000_000 = 1 giây`
 * `Task.checkCancellation()` kiểm tra xem ai đó có gỏi nó tự hũy hay không, bằng phương thức `cancel()`. Lúc ấy, sẽ ném về 1 giá trị `CancellationError`
 * `Task.yield()` dừng task hiện tại trong một thời gian. Để dành cho task khác đang chờ. Có ích trong các vòng for không lối thoát.
 
 Ví dụ tổng hợp nhóe!
 */
func cancelSleepingTask() async {
    let task = Task { () -> String in
        print("Starting")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        try Task.checkCancellation()
        return "Done"
    }

    // The task has started, but we'll cancel it while it sleeps
    task.cancel()

    do {
        let result = try await task.value
        print("Result: \(result)")
    } catch {
        print("Task was cancelled.")
    }
}

Task {
    await cancelSleepingTask()
}
/*:
 Trong đó:
 * Ngay khi task bắt đầu thì rơi vào lệnh ngủ 1 giây
 * Nhưng đã bị gọi `cancel` từ bên ngoài
 * Ở trong closure có kiểm tra việc có bị hũy hay không. Lúc này nó sẽ `throw` lỗi về tại `do catch`
 
 Và khi lệnh hũy được đưa ra, thì giá trị `value` sẽ không được gởi về. Và để lấy được giá trị khi hũy vẫn diễn ra thì bạn hay sử dụng tới `task.result`. Đó là 1 kiểu `Result<String, Error>` (theo như ví dụ trên). Công việc chỉ còn là `switch ... case` mà thôi.
 */

/*:
 ## Task Group
 
 Đối với nhiều công việc phức tạp thì việc sử dụng các Task riêng lẻ sẽ không được hiệu quả cao nhất. Lúc này, bạn cần sử dụng tới `Task Group`. Nó sẽ tập hợp các nhiệm vụ (task) để thực hiện cùng nhau nhằm tạo ra 1 giá trị khi hoàn thành.
 
 Task Group sẽ hạn chế nhỏ nhất rủi ro mà bạn sẽ gặp phải.
 
 ### Cú pháp
  
 Bạn không thể tạo ra Task Group một cách trực tiếp. Sử dụng function `withTaskGroup()` để tạo với nội dung công việc bạn muốn hoàn thành. Và bạn sẽ có 2 cách để tạo:
 * `withThrowingTaskGroup`
 * `withTaskGroup`
 
 Chúng tương tự nhau chỉ khác nhau ở có `throw` và không mà thôi.
 
 Các tác vụ con sẻ được thêm vào Task group thông qua phương thức `addTask()`. Các task con được thêm vào sẽ được thực thi ngay.
 
 ### Ví dụ 1
 
 Xem qua ví nhóe!
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

Task {
    await printMessage()
}

/*:
 Trong đó:
 * `string` là biến tạo ra để nhận giá trị cuối cùng task group sau khi hoàn thành.
 * Việc thêm các task con trong group thông qua phương thức `group.addTask { }`
 * kiểu giá trị trả về của Task Group và Task con thường sẽ giống nhau.
 * Các giá trị của các task con mà bạn muốn lấy thì sẽ phải chờ `await`
 * Task group sẽ trả về giá trị sau khi tất cả các task con đã hoaafn thành
 
 Bạn sẽ hiểu mỗi Task con như là một function vậy. Tuy nhiên, chúng sẽ tự độngn thực thi trong khi Task Group sẽ đợi tất cả hoàn thành trước khi trả về giá trị. Dẫn tới một điều rằng, đôi khi thứ tự trả về của các task con sẽ không như mong muốn.
 */

/*:
 ### With Error
 
 Trường hợp, Task Group của bạn đang thực thi mà có lỗi phát sinh trong các task con thì sẽ như thế nào. Bạn cần phải thiết kế lại việc tạo Task Group, lần này bạn sẽ dùng function `withThrowingTaskGroup()` để tạo. Đi kèm với đó là bạn sẽ cần sử dụng thêm `try` trước `await`. Vì có thể sinh ra lỗi trong quá trình thực thi.
 */
/*:
 Ví dụ code như sau:
 */
enum LocationError: Error {
    case unknown
}

func getWeatherReadings(for location: String) async throws -> [Double] {
    switch location {
    case "London":
        return (1...100).map { _ in Double.random(in: 6...26) }
    case "Rome":
        return (1...100).map { _ in Double.random(in: 10...32) }
    case "San Francisco":
        return (1...100).map { _ in Double.random(in: 12...20) }
    default:
        throw LocationError.unknown
    }
}

func printAllWeatherReadings() async {
    do {
        print("Calculating average weather…")

        let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
            group.addTask {
                try await getWeatherReadings(for: "London")
            }

            group.addTask {
                try await getWeatherReadings(for: "Rome")
            }

            group.addTask {
                try await getWeatherReadings(for: "San Francisco")
            }

            // Convert our array of arrays into a single array of doubles
            let allValues = try await group.reduce([], +)

            // Calculate the mean average of all our doubles
            let average = allValues.reduce(0, +) / Double(allValues.count)
            return "Overall average temperature is \(average)"
        }

        print("Done! \(result)")
    } catch {
        print("Error calculating data.")
    }
}

Task {
    await printAllWeatherReadings()
}
/*:
 Trong ví du:
 * các lệnh `group.addTask` hâu như giống nhau. Nên bạn có thể nhóm lại bằng 1 vòng lặp
 * giá trị sẽ được làm gọn từ nhiều array double thành 1 array double, bằng toán tử `reduce`
 * Cuối cùng là tính giá trị trung bình của chúng
 
 Tiếp theo, bạn đặt thử 1 thành phố không có trong dữ liêu vào Task Group và quan sát kết quả nhóe!
 ```
 group.addTask {
     try await getWeatherReadings(for: "Hanoi")
 }
 ```
 
 Lúc này, task groud sẽ gọi `cancelAll()` để hũy bất kỳ task còn nào trong nó. Nhưng các lệnh `addTask` vẫn sẽ được thực thi. Điều này gây ra sự tốn kém tài nguyên. Các khắc phục thì bạn sẽ sử dụng hàm thay thế `addTaskUnlessCancelled()`. Nó sẽ dùng việc thêm Task con khi Group phát lên hũy.
 */

/*:
 ## Tạm kết
 
 Ở trên, mình chỉ giới thiệu lại cơ bản của Task & Task Group trong Swift 5.5 mà thôi. Còn việc áp dụng của nó tùy thuộc vào bạn nắm được bao nhiêu kiến thức của New Concurrency trong Swift mới.
 
 Các khái niệm Concurrency mới có sự liên hệ chặt chẽ với nhau. Và hỗ trợ nhau rất nhiều. Mình sẽ trình bày ở các bài viết khác.
 */
