# File Manager

Chào mừng bạn đến với **Fx Studio**. Chủ đề quản lý File thì rất quen thuộc với tất cả mọi người khi tìm hiểu một nền tảng nào đó rồi. Và bài viết này giúp bạn tìm hiểu thêm về quản lý file trong iOS với **File Manager**. Hướng dẫn bạn các thao tác cơ bản với file.

Còn nếu mọi việc đã ổn rồi, thì ...

> Bắt đầu thôi!

## Chuẩn bị

Về mặt tools và versions, bạn sẽ không cần phải lo lắng nhiều. Vì đối tượng chúng ta cần tương tác thì có mặt trong Core iOS từ rất lâu rồi.

Về mặt lý thuyết, bạn cần đảm bảo là đã và đang học iOS cơ bản rồi. Còn nếu bạn chưa biết gì về iOS & Swift, thì có thể tham khảo link bài viết sau:

* [Lập trình iOS cho mọi người](https://fxstudio.dev/lap-trinh-ios-cho-moi-nguoi/)

Về mặt demo, chúng ta hãy tạo một iOS project đơn giản nhóe. Bạn sẽ không cần tới giao diện ứng dụng, các kết quả sẽ hiển thị ở console.

## File Manager

Theo định nghĩa, thì File Manager là một giao diện thuận tiện cho nội dung của hệ thống files và là phương tiện chính để tương tác với nó.

Đối tượng File Manager cho phép bạn:

* Kiểm tra nội dung của các file & thư mục của hệ thống hoặc được tạo ra bởi người dùng
* Thực hiện các thay đổi với các file & thư mục

Lớp FileManager sử dụng để thực hiện những công việc cơ bản với file và thư mục như tạo, sửa, ghi , di chuyển, đọc nội dung, đọc thông tin thuộc tính của file, thư mục. Ngoài ra cũng cung cấp phương thức lấy thư mục hiện hành, thay đổi, tạo mới thư mục, liệt kê danh sách nội dung có trong thư mục ...

Chúng ta sẽ bắt đầu tìm hiểu thông qua các ví dụ ở các phần sau.

## File Path

Đường dẫn tới file (*File Path*) là điều quan trọng nhất khi bạn muốn làm việc với hệ thống files trong bất cứ ngôn ngữ hay nền tảng nào. Và iOS thì không phải ngoại lệ. Bên cạnh đó, iOS sẽ có thêm một số vấn đề liên quan tới **File Path** nữa mà bạn cần chú ý tới.

Đối tượng thể hiện File Path chính là **URL**. Bạn sẽ dùng đối tượng URL để lưu trữ các đường đẫn tới File & Thư mục. Bên cạnh đó, bạn cũng dễ dàng thêm bới sửa xứa chúng.

### Get Bundle Resource Path

Đầu tiên, bạn cần phải lấy được đường dẫn tới các files tài nguyên (Resources) mà bạn đính kèm trong Project. Hay cũng chính là Bundle ứng dụng của bạn.

> Bạn sẽ tìm hiểu **Bundle** sau nhóe!

Chúng ta xem ví dụ code để tìm đường dẫn tới một file `*.txt` nào đó trong được đính kèm theo project nhóe.

```swift
let filePath = Bundle.main.url(forResource: "hello_file", withExtension: "txt")
```

Với phương thức được sử dụng là `Bundle.main.url` và cần truyền vào các tham số:

* `forResource` cho tên file
* `withExtension` cho đuôi file (hay format, hay phần mở rộng ...)

Là bạn có được đường dẫn tới đúng file mà bạn đính kèm trong Project rồi nhóe. Và bạn có còn một phương thức khác để lấy trực tiếp đường dẫn, nhưng với kiểu dữ liệu trả về là **String**

```swift
let path = Bundle.main.path(forResource: "hello_file", ofType: "txt")
```

### Get Documents Directory Path

Với ứng dụng iOS, bạn sẽ có thêm một nơi dùng để lưu trữ các files riêng của bạn. Nó không thuộc hệ thống của thiết bị. Nó thuộc về riêng của ưng dụng iOS bạn. Hay còn gọi là **Documents Directory**. 

Và cách lấy đường dẫn tới thư mục đó như sau:

```swift
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
```

Trong đó:

* Sử dụng đối tượng **FileManager** để lấy đường dẫn tới thư mục Documents
* Dữ liệu trả về sẽ là một mãng các AnyObject, do đó bạn chỉ cần lấy phần tử đầu tiên thôi nhóe

Bạn nên tạo riêng một function để lấy đường dẫn tới thư mục này. Chúng ta sẽ dùng lại nó trong nhiều ví dụ phía dưới.

### Append Path Component

Với Bundle thì chúng ta sẽ xác định đường dẫn trực tiếp tới thẳng file. Còn với Document thì ta phải xác định từng bước. 

* Đầu tiên, sẽ là đường dẫn tới thư mục. 
* Sau đó, bạn sẽ nối thêm các đường dẫn khác nên file của bạn nằm trong các thư mục con trong Documents
* Cuối cùng, bạn sẽ nối tiếp tên file vào đường dẫn

Xem ví dụ nhóe!

```swift
func getDocumentFilePath(fileName: String) -> URL {
    let documentPath = getDocumentsDirectory()
    let filePath = documentPath.appendingPathComponent(fileName)
    
    return filePath
}
```

Bạn sử dụng đối tượng URL và gọi phương thức `.appendingPathComponent(_)` của chính nó để thêm các phần đường dẫn tiếp theo. Với phương thức này, bạn hoàn toàn yên tâm với các dấu `/` hay `\` ... khi chỉnh sửa đường dẫn cho phù hợp.

Để dễ so sánh bạn hãy thử thực thi đoạn code sau nhóe!

```swift
print("Documents Directory Path: \(getDocumentsDirectory().absoluteString)")
        
print("Append Path Component:  \(getDocumentFilePath(fileName: "hello.txt"))")
```

### File Exists

Bạn không thể nào biết được file của bạn có tồn tại hay là không. Và bạn cần đảm bảo dữ liệu nội dung của file sẽ lấy được. Thì bạn cần phải kiểm tra được file đó với đường dẫn đó là có tồn tại hay là không.

Chúng ta sẽ sử dụng tới đối tượng **FileManager** để thực hiện công việc này. Xem ví dụ code tiếp nhóe!

```swift
func checkFileExist(fileName: String) -> Bool {
    let filePath = getDocumentFilePath(fileName: fileName)
    let fileManger = FileManager.default
    
    if fileManger.fileExists(atPath: filePath.path) {
        print("FILE: \(fileName) is AVAILABLE")
        return true
    } else {
        print("FILE: \(fileName) NOT AVAILABLE")
        return false
    }
}
```

* Sử dụng đối tượng `FileManager.default` và gọi phương thức `fileExists` để kiểm tra file có tồn tại hay là không.
* Tham số cần truyền là thuộc tính `path` của đối tượng URL

Ngoài ra, bạn có thể tạo 1 extension cho URL để xác định tồn tại của file.

```swift
extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}

// Sử dụng
if fileUrl.checkFileExist()
   {
      // Do Something
   }
```

Thực thi các đoạn code và cảm nhận kết quả nhóe!

## File Handle

Sau khi bạn đã tìm hiểu cơ bản về **File Path**, thì chúng ta sẽ tiếp tục với việc thao tác với các file. Các thao tác cơ bản chính là *đọc* & *ghi* file.

### Read File

Đầu tiên, chúng ta sẽ tìm cách đọc nội dung của một File là như thế nào. Bạn đã có được *path* (đường dẫn) tới một file và nó được lưu trữ bằng một đối tượng **URL**. 

Tiếp theo, bạn sẽ sử dụng kiểu dữ liệu **Data** và khởi tạo bằng phương thức lấy nội dung của từ một *url*.

Bạn xem qua ví dụ nhóe

```swift
guard let txtFileURL = Bundle.main.url(forResource: "hello_file", withExtension: "txt") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: txtFileURL)
            let content = String(data: data, encoding: .utf8)
            print("Content File: \(content ?? "n/a")")
        } catch {
            print(error.localizedDescription)
        }
```

Trong đó:

* Ta sẽ lấy đường dẫn của file `hello_file.txt` có trong Bundle
* Nội dung của file thì sẽ lấy bằng việc khởi tạo một **Data** với phương thức `(contentsOf)`
* Chuyển đổi định dạng của **Data** về kiểu dữ liệu mong muốn, là **String**
* Quá trình này có thể sinh ra lỗi nên tốt nhất là đặt trong `try catch` và bắt các error phát sinh

Tuy nhiên, Swift cũng hỗ trợ một số kiểu chuyển đổi trực tiếp nhanh hơn cho các kiểu dữ liệu cơ bản. Bạn thử thay đoạn code xử lý `data` trên bằng dòng code sau nhóe!

```swift
let content = try String(contentsOf: txtFileURL)
```

Khá là EZ phải không nào. Bạn có thể khám phá thêm với các kiểu dữ liệu khác khi đọc trực tiếp nội dung từ file. Tuy nhiên, chúng ta nên sử dụng **Data** như là một kiểu dữ liệu trung gian & an toàn nhất.

Ví dụ với việc đọc một file chung chung trong Documents và sử dụng **Data** như sau:

```swift
func readFile(fileName: String) -> Data? {
    if checkFileExist(fileName: fileName) {
        let filePath = getDocumentFilePath(fileName: fileName)
        do {
            let data = try Data(contentsOf: filePath)
            return data
        } catch {
            print("Can not read file")
            return nil
        }
    } else {
        print("File not available.")
        return nil
    }
}
```

### Write File

Bạn có thể áp dụng cách ngược lại với việc đọc file. Và bạn sử dụng phương thứ `.write()` có trong một số lớp dữ liệu cơ bản để tiến hành ghi vào file với đường dẫn cho trước.

> Việc lưu file hay việc ghi file chỉ thực hiện với các file ở thư mục Documents. Với các file tài nguyên ở Bundle thì chúng ta chỉ đọc mà thôi.

Ví dụ với việc ghi một nội dung String vào một file TXT nhóe!

```swift
func writeFile(fileName: String, content: Data) -> Bool {
    let filePath = getDocumentFilePath(fileName: fileName)
    
    do {
        try content.write(to: filePath)
        return true
        
    } catch {
        print("Can not write file")
        return false
    }
}
```

Trong đó:

* Sử dụng kiểu dữ liệu **Data** như là một lớp trung gian cho việc đọc nội dùng của file
* Sử dụng phương thức `.write` với tham số là `path`.
* Bạn sẽ tiến hành ghi đè file, nên việc xác định file tồn tại hay không thì không quan trọng.

Ví dụ tiếp cho việc sử dụng như sau:

```swift
        // infor
        let stringContent = "Hello, I am supperman!"
        let fileName = "superman.txt"
        
        // write file
        if let stringData = stringContent.data(using: .utf8) {
            let okay = writeFile(fileName: fileName, content: stringData)
            if okay {
                print("DONE")
            } else {
                print("FAILED")
            }
        }
        
        // read file
        if let dataFile = readFile(fileName: fileName) {
            let content = String(data: dataFile, encoding: .utf8) ?? "n/a"
            print("File: \(fileName) : \(content)")
        }
```

Còn với các kiểu dữ liệu khác (*như: Array, Dictionary, UIImage ...*) bạn vẫn sử dụng **Data** là lớp trung gian để xử lý nội dung của file.

### Attributes

Tiếp theo, đối tượng **File Manager** còn hỗ trợ bạn có thể thấy được các thuộc tính(*Attributes*) của một file. Và công việc này cũng khá đơn giản. Bạn chỉ chần xác định được *file path* mà thôi.

Xem ví dụ code nhóe!

```swift
        let fileSupperManPath = getDocumentFilePath(fileName: "superman.txt").path
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: fileSupperManPath)
            print("File Attributes:")
            for item in attributes {
                print(item)
            }
        } catch {
            print(error.localizedDescription)
        }
```

Trong đó, với phương thức `.attributesOfItem(atPath: )` giúp bạn lấy được tất cả thuộc tính của một file theo đường dẫn cho trước. Bạn hãy thực thi đoạn code và cảm nhận kết quả nhóe.

```
File Attributes:
(key: __C.NSFileAttributeKey(_rawValue: NSFileCreationDate), value: 2022-03-07 07:49:33 +0000)
(key: __C.NSFileAttributeKey(_rawValue: NSFileExtensionHidden), value: 0)
(key: __C.NSFileAttributeKey(_rawValue: NSFileSystemFileNumber), value: 49429720)
(key: __C.NSFileAttributeKey(_rawValue: NSFileGroupOwnerAccountName), value: staff)
(key: __C.NSFileAttributeKey(_rawValue: NSFileGroupOwnerAccountID), value: 20)
(key: __C.NSFileAttributeKey(_rawValue: NSFileOwnerAccountID), value: 503)
(key: __C.NSFileAttributeKey(_rawValue: NSFileType), value: NSFileTypeRegular)
(key: __C.NSFileAttributeKey(_rawValue: NSFileSystemNumber), value: 16777230)
(key: __C.NSFileAttributeKey(_rawValue: NSFileReferenceCount), value: 1)
(key: __C.NSFileAttributeKey(_rawValue: NSFileModificationDate), value: 2022-03-08 03:04:02 +0000)
(key: __C.NSFileAttributeKey(_rawValue: NSFilePosixPermissions), value: 420)
(key: __C.NSFileAttributeKey(_rawValue: NSFileSize), value: 22)
```

Cũng khá nhiều thuộc tính đó. Ahihi!

### Copy, Move & Remove file

Tiếp theo, bạn sẽ cần tới một số lệnh cơ bản trên file nhóe. Ví dụ như là: *copy, move & remove* ... Tất cả cũng đều thực hiện bằng đối tượng **File Manager** và bạn cần xác định *file path* của file cần thao tác trước.

``` swift
moveItem(atPath: toPath:)

copyItem(atPath: toPath:)

removeItem(atPath:)
```

Bạn thử tạo ví dụ riêng cho mình nhóe!

## Bundles

Bây giờ, ta sẽ bàn tới khái niệm **Bundles** được đề cập ở trên. Vì:

* Trên nền tảng của Apple, các ứng dụng được phân phối dưới dạng bundles.
* Một Project của bạn có thể có nhiều Bundles.
* Các file có trong Bundle được xem là file tài nguyên (resources) và nó được thêm vào project.
* Tất cả chúng chỉ ở trạng thái chỉ đọc (read-only)
* Bundle mà bạn hay dùng nhất là `.main`

Về demo cho việc tương tác file có trong Bundle thì mình có thể tổng hợp theo ví dụ code sau đây:

```Swift
struct ContentLoader {
    enum Error: Swift.Error {
        case fileNotFound(name: String)
        case fileDecodingFailed(name: String, Swift.Error)
    }

    func loadBundledContent(fromFileNamed name: String) throws -> Content {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json"
        ) else {
            throw Error.fileNotFound(name: name)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(Content.self, from: data)
        } catch {
            throw Error.fileDecodingFailed(name: name, error)
        }
    }
    
    // ...
}
```

Trong đó:

* Struct ContentLoader chỉ là mình họa cho việc handle các file thuộc Bundle
* Trước tiên, bạn phải xác định được *file path* của file trong bundler với funtion `Bundle.main.url(forResource:_, withExtension:_)`
* Tiếp theo, bạn sẽ dùng **Data** làm lớp dữ liệu trung gian để lấy nội dung của file
* Cuối cùng chính là việc xử lý dữ liệu về đúng kiểu dữ liệu mong muốn. Trong ví dụ là kiểu **JSON**.

Và điều quan trọng bạn cần nhớ là:

> Xác định đúng bundle mà bạn muốn sử dụng. Vì không phải lúc nào cũng chỉ dùng **Main Bundle** mà thôi.

## System Defined Folders

Với các file thuộc Bundles thì nhược điểm lớn nhất chính là việc chỉ đọc (read-only). Nên bạn sẽ tìm tới một giải pháp khác cho việc đọc/ghi các file trong quá trình sử dụng ứng dụng. 

### Documents

Đầu tiên, chính là thư mục Documents của ứng dụng. Với MacOS, bạn có thể sử dụng chính thư mục Documents của `user` trong MacOS. Nhưng với iOS, với cơ chế `sandbox` thì các ứng dụng sẽ có các thư mục Documents riêng lẻ với nhau. Và ta có các ưu điểm sau:

* Đảm bảo bảo mật với các file của ứng dụng
* Đọc & ghi file
* Hỗ trợ các phương thức đọc khi khá đơn giản
* Bạn có thể tạo thêm các thư mục khác của bạn bên trong thư mục Documents, giúp cho việc quản lý file hiệu quả hơn.

Với đối tượng **File Manager** thì việc đọc/ghi file khá đơn giản. Với:

* `write` dùng cho ghi file
* `contentOf` dùng cho đọc file

Với các ví dụ trên, thì bạn cũng đã được thao tác nhiều với các file từ Documents rồi. Sau đây, mình tóm tắt lại với ví dụ code sau:

```swift
struct FileIOController {
    func write<T: Encodable>(
        _ value: T,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let fileURL = folderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
    
    // ...
}
```

### Temporary Diretory

Tương tự, chúng ta cũng có thể sử dụng API *FileManager* ở trên để giải quyết các system folders khác. Ví dụ: folder mà hệ thống cho là thích hợp nhất để sử dụng cho `disk-based caching`:

```swift
let cacheFolderURL = try FileManager.default.url(
    for: .cachesDirectory,
    in: .userDomainMask,
    appropriateFor: nil,
    create: false
)
```

Trong đó:

* Với `cachesDirectory` là tham số dùng để xác định thư mục tạm thời

Tuy nhiên, nếu tất cả những gì chúng ta đang tìm là URL cho một folder tạm thời, chúng ta có thể sử dụng hàm **NSTemporaryDirectory** đơn giản hơn nhiều. Hàm trả về một URL cho một system folder có thể được sử dụng để lưu trữ dữ liệu mà chúng ta chỉ muốn tồn tại trong thời gian ngắn:

```swift
let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory())
```

Lợi ích của việc sử dụng các API ở trên, thay vì *hard coding* các đường dẫn thư mục cụ thể trong code, chúng ta cho phép hệ thống quyết định thư mục nào phù hợp nhất cho nhiệm vụ hiện tại.

### Custom Foders

Mặc dùng bạn có thể tạo được thêm các thư mục của riêng bạn trong ứng dụng. Tuy nhiên, với iOS thì mọi thứ bạn có thể làm thì đều ở trong thư mục Document của ứng dụng mà thôi.

Nhưng với việc bạn có một thư mục riêng để lưu trữ các file của riêng bạn thì sẽ tránh đi việc xung đột với các file/thư mục hệ thống.

Xem ví dụ code tổng hợp như sau:

```swift
struct FileIOController {
    var manager = FileManager.default

    func write<T: Encodable>(
        _ object: T,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let nestedFolderURL = rootFolderURL.appendingPathComponent("MyAppFiles")
        
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        let fileURL = nestedFolderURL.appendingPathComponent(documentName)
        print("File URL: \(fileURL.path)")
        let data = try encoder.encode(object)
        try data.write(to: fileURL)
    }
    
}
```

Trong đó:

* Bạn sẽ có một thư mục riêng với tên là `MyAppFiles`.
* Để xác định URL tới thư mục đó thì bạn thực hiện như bình thường
* Các công việc đọc/ghi file cũng tương tự với thao tác ở trên

Điều chú ý, là việc bạn tạo mới thư mục. Bạn cần phải kiểm tra sự tồn tại của nó trước.

```swift
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }
```

Nếu thư mục chưa tồn tại, thì khi đó bạn sẽ tạo mới một thư mục theo đường dẫn `nestedFolderURL`.

Xem qua ví dụ sử dụng struct trên nhóe.

```swift
        let fileIO = FileIOController()
        let fileContent = "Custom Folder"
        let customFileName = "abc.txt"
        
        do {
            try fileIO.write(fileContent, toDocumentNamed: customFileName)
        } catch {
            print(error.localizedDescription)
        }
```

Hãy thực thi đoạn code và cảm nhận kết quả nhóe.

## Tạm kết

* Tìm hiểu cơ bản về hệ thống file được sử dụng trong ứng trong ứng dụng iOS
* File Manager và các thao tác cơ bản trên files
* Phân biệt giữa Bundles & Documents files
* Đọc ghi với files
* Xử lý các Custom Folder

---

*Cảm ơn bạn đã theo dõi các bài viết từ Fx Studio & hãy truy cập [website](https://fxstudio.dev/) để cập nhật nhiều hơn.*