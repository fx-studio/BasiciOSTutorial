import UIKit
/*:
 # @TaskLocal
 
 Chào mừng mọi người đến với Fx Studio. Chúng ta lại tiếp tục khám phá vũ trụ New Concurrency trong Swift 5.5. Chủ đề lần này là @TaskLocal. Bài toán chúng ta cần giải quyết là việc lưu trữ và chia sẽ dữ liệu giữa các Task với nhau trong lập trình bất đồng bộ.
 
 Còn nếu mọi việc đã ổn rồi, thì ...
 
 > Bắt đầu thôi!
 */
/*:
## Vấn đề
Chúng ta đã tìm hiểu nhiều về Concurrency mới trong Swift 5.5 và cũng thấy được các Task & Task Group tạo nên các cấu trúc đồng thời. Từ đó, chúng ta có sự phân cấp các Task. Và Task Tree là kết quả có được của việc gọi Task trong Task. Một điều quan trọng chính là ngữ cảnh mà chúng thực thi. Dữ liệu sẽ là đối tượng bị ảnh hướng trực tiếp nhất.
 
 Bạn có thể sử dụng các Actor hay MainActor để chống lại các Data Races, nhưng việc chia sẽ dữ liệu hay lưu trữ giữa các Task con trong một Task cha thì lại là một câu chuyện phức tạp.
 
 Ví dụ nhóe!
 */
class ViewController: UIViewController {
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.name = "Fx Studio"
            self.printName()
            
            Task {
                self.name = "Fx Studio 2"
                self.printName()
            }
        }
    }

    func printName() {
        if let name = self.name {
            print("Name is \(name)")
        } else {
            print("Nomane")
        }
    }

}
/*:
 Ví dụ với Task Tren đơn giản và chúng sẽ hoạt động ổn với Task. Vì nó được tách ra từ Main Thread. Tuy nhiên, các cuộc Data Race vẫn có thể xảy ra khi chúng ta sử dụng như vậy. Nhưng điều này không đám sợ với ví dụ tiếp sau.
 */
Task.detached {
    self.name = "Fx Studio 3"
    self.printName()
}
/*:
 Bạn thêm đoạn code trên vào sau Task ở trên. Điều này sẽ không thực hiện được, vì với Task.detached thì ta lại có một ngữ cảnh mới cho việc thực thi nó. Do đó, việc cập nhật dữ liệu là điều không thể.
 
 Tóm lại, bạn sẽ thấy vấn đề chính vẫn là:
 
 > Lưu trữ & Chia sẽ dữ liệu
 */
/*:
## @TaskLocal Property Wrapper
 
 Về định nghĩa thì @TaskLocal là một Property Wrapper. Với giá trị của TaskLocal thì có thể đọc & ghi được từ ngữ cảnh của một Task. Nó được hiểu chia sẽ ngầm định và truy cập được từ bất kỳ task con nào mà task cha đó tạo ra.
 
 Về khai báo thì bạn đánh dấu một thuộc tính là @TaskLocal với khai báo là static. Về kiểu giá trị thì có thể là Optional hoặc có giá trị mặc định được cung cấp lúc khai báo.
 
 Ví dụ với ViewController ở trên nhóe!
 */
class ViewController: UIViewController {
    
    @TaskLocal static var currentName: String?
    
    //....
}
/*:
 Tùy thuộc vào kiểu dữ liệu khai báo cho @TaskLocal của bạn mà khi bạn gọi nó từ một Task Tree khác thì sẽ nhận được giá trị:
 
 * nil nếu khai báo là Optinal
 * Giá trị gán ban đầu nếu khai báo bình thường (non-Optinal)
 */
/*:
 ## Đọc & ghi @TaskLocal
 
 Để đọc & ghi dữ liệu cho các thuộc tính @TaskLocal thì cũng khá đơn giản. Ví dụ với đọc như sau:
 */
func asyncPrintName() async {
    if let name = await ViewController.currentName {
        print("Current Name is \(name)")
    } else {
        print("Nomane")
    }
}
/*:
 Function asyncPrintName() được khai báo ở ngoài class ViewController. Bạn sẽ sử dụng if let để unwrapp optinal và thê await để sử chờ đợi trong tương tác bất đồng bộ.
 
 Về ghi hay gán dữ liệu cho thuộc tính @TaskLocal thì chúng ta sẽ gọi là binding. Vì ta không thể gán trực tiếp giá trị cho nó thông qua phương thức withValue(). Xem quá ví dụ nhóe!
 */
Self.$currentName.withValue("Fx Studio") {
    // coding here
}
/*:
 Để có thể Binding dữ liệu cho thuộc tính @TaskLocal bạn sẽ phải sử dụng tới $ làm tiền tố. Tại closure cung cấp cho withVaue thì bạn có thể tùy ý đặt logic của bạn vào đó. Nhằm xử lý giá trị nhận được của thuộc tính @TaskLocal.
 */
/*:
 ## Sharing Data
 
 Sau khi, bạn đã biết viết @TaskLocal rồi. Chúng ta sẽ tiến hành sử dụng chúng. Và điều đầu tiên trong việc áp dụng, đó là chia sẽ dữ liệu trong các task con của 1 Task Tree.
 
 Xem ví dụ sau nhóe!
 */
Self.$currentName.withValue("Fx Studio") {
    Task {
        print("#1 - 0")
        await asyncPrintName() // Fx Studio
        
        Task {
            print("#1 - 1")
            await asyncPrintName() // Fx Studio
        }
        
        Task {
            sleep(2)
            print("#1 - 2")
            await asyncPrintName() // Fx Studio
        }
    }
}
/*:
 Với việc binding dữ liệu mới cho currentName là Fx Studio. Chúng ta tiến hành xử lý giá trị đó. Bạn sẽ thấy ta sẽ có tới 2 Task con trong một Task lớn. Task con thứ 2 sẽ sau hoạt động sau 2 giây. Thực thi đoạn code, bạn sẽ thấy được dữ liệu của currentName sẽ vẫn tồn tại và chia sẽ qua tất cả các Task trong Task Tree.
 
 Nhưng khi ta tạo thêm một nhánh mới từ đó thì sẽ như thế nào. Xem ví dụ tiếp nha
 */
Self.$currentName.withValue("Fx Studio") {
    Task {
        print("#1 - 0")
        await asyncPrintName() // Fx Studio
        
        Task {
            print("#1 - 1")
            await asyncPrintName() // Fx Studio
            
            //update
            await Self.$currentName.withValue("Fx Studio 2") {
                print("#1 - 1 - 1")
                await asyncPrintName() // Fx Studio 2
            }
            
            print("#1 - 1 - 2")
            await asyncPrintName() // Fx Studio

        }

        
        Task {
            sleep(2)
            print("#1 - 2")
            await asyncPrintName() // Fx Studio
        }
    }
}
/*:
 Với sự cập nhật dữ liệu mới cho @TaskLocal, bạn đã tạo ra một nhánh mới và dữ liệu mới sẽ áp dụng cho nhánh đó. Với Task thuộc cách nhánh khác (nếu không được cập nhật) thì sẽ nhận được dữ liệu từ nhánh gốc.
 
 > Khá là ảo diệu phải không nào!
 */
/*:
 ## Detached Task
 
 Ta tiếp tục bóc tách thêm khi chúng ta có 2 Task Tree thì sẽ như thế nào. Bằng cách sử dụng Task.detached { ... } để có được một Task Tree mới. Xem tiếp code ví dụ sau nhóe.
 */
Self.$currentName.withValue("Fx Studio") {
    Task {
        print("#1 - 0")
        await asyncPrintName() // Fx Studio
        
        Task {
            print("#1 - 1")
            await asyncPrintName() // Fx Studio
            
            //update
            await Self.$currentName.withValue("Fx Studio 2") {
                print("#1 - 1 - 1")
                await asyncPrintName() // Fx Studio 2
            }
            
            print("#1 - 1 - 2")
            await asyncPrintName() // Fx Studio

        }

        
        Task {
            sleep(2)
            print("#1 - 2")
            await asyncPrintName()
        }
    }
    
    Task.detached {
        print("#3 - 0")
        await asyncPrintName() // Noname

        await Self.$currentName.withValue("Fx Studio 3", operation: {
            print("#3 - 1")
            await asyncPrintName() // Fx Studio 3
        })
    }
}
/*:
 Khi bạn truy cập dữ liệu của thuộc tính @TaskLocal từ một Task Tree mới thì chúng ta sẽ nhận được nil hoặc giá trị cung cấp ban đầu. Giá trị chúng ta binding từ Task Tree khác sẽ không nhận được. Thực thi chương trình và xem kết quả nhóe.
 
 Và khi bạn tiếp tục binding dữ liệu cho thuộc tính @TaskLocal tại Task Tree đó. Thì bạn sẽ nhận được giá trị binding mới kìa. Và nó cũng áp dụng đúng với một Task tree bất kỳ khác khi muốn truy cập vào dữ liệu của thuộc tính @TaskLocal
 */
// #1
Self.$currentName.withValue("Fx Studio") {
    Task {
        print("#1 - 0")
        await asyncPrintName() // Fx Studio
        
        Task {
            print("#1 - 1")
            await asyncPrintName() // Fx Studio
            
            //update
            await Self.$currentName.withValue("Fx Studio 2") {
                print("#1 - 1 - 1")
                await asyncPrintName() // Fx Studio 2
            }
            
            print("#1 - 1 - 2")
            await asyncPrintName() // Fx Studio

        }

        
        Task {
            sleep(2)
            print("#1 - 2")
            await asyncPrintName() // Fx Studio
        }
    }
    
    Task.detached {
        print("#3 - 0")
        await asyncPrintName() // Noname

        await Self.$currentName.withValue("Fx Studio 3", operation: {
            print("#3 - 1")
            await asyncPrintName() // Fx Studio 3
        })
    }
}

// #2
Task {
    print("#4 - 0")
    await asyncPrintName() //Noname
}
/*:
 Bạn sẽ thấy #1 & #2 là nhóm tách biệt. Và dữ liệu của cùng một thuộc tính @TaskLocal sẽ khác nhau ở mỗi Task Tree hoặc mỗi nhánh tạo ra khi có sự cập nhật lại dữ liệu.
 */
/*:
 ## Tạm kết
 
 * Tìm hiểu về @TaskLocal và cách hoạt động của nó trong project
 * Quản lý được việc chia sẽ dữ liệu cho các Task con trong cùng một Task Tree
 * Cô lập dữ liệu chia sẽ khi xử lý bất đồng bộ & đồng thời tại nhiều Task Tree
 */
