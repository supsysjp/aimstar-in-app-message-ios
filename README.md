# Aimstar In App Messaging SDK
## Requirements
ランタイム: iOS 13以上をサポート  
開発環境: Xcode 15.2 on macOS 14.2.1

## 制限事項
- マルチウインドウアプリには対応していません
- SwiftUIベースのアプリも現時点では非推奨です
- 後述する `5.ページ閲覧イベントの送出` 実行後にポップアップが表示される可能性がありますが、現時点では表示を抑制する機能が存在しないため、ポップアップ表示時には実行しないなどの排他制御を行なっていただく必要がございます

## SDKで提供する機能について
- アプリのページ閲覧イベントを送信する
- 対象と判定されたユーザーに、ポップアップを表示する
- ポップアップ表示、ユーザー操作による非表示、コンバージョンボタンのタップの各イベントを送信する

## 用語

| 用語 | 説明 |
| - | - |
| API Key | AimstarMessaging を利用するために必要な API キーで、Aimstar 側で事前にアプリ開発者に発行されます。 |
| Tenant ID | AimstarMessaging を利用するために必要なテナント ID で、Aimstar 側で事前にアプリ開発者に発行されます。 |
| Customer ID | アプリ開発者がユーザーを識別する ID で、アプリ開発者が独自に発行、生成、または利用します。 |
| ScreenName | アプリ側で設定するトリガーの一種（アプリ開発者が任意に設定する識別名）で、ユーザーが特定の画面を表示したり、またはアクションを行うなどの条件を満たした場合に、識別名を使ってメッセージを呼び出すために利用されます。 |

## 導入手順
### 1.SDKをアプリに追加する
#### CocoaPodsを利用する場合
Podfileに以下を追記し、`pod install` を実行してください

```ruby
pod "AimstarInAppMessaging"
```

#### 手動で追加する場合
[releases](https://github.com/supsysjp/aimstar-in-app-message-ios/releases) から `AimstarInAppMessagingSDK.zip` をダウンロードして展開し、AimstarInAppMessagingSDK.xcframeworkをプロジェクトに含めてください

### 2.SDKの初期化とイベントリスナーを設定する
`application(_:didFinishLaunchingWithOptions:)` メソッド内に初期化コードを追加します

```swift
import AimstarInAppMessagingSDK

...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let API_KEY = "Your API KEY"
    let TENANT_ID = "Your TENANT ID"
    // SDKの初期化を行います
    AimstarInAppMessaging.shared.setup(apiKey: API_KEY, tenantId: TENANT_ID)
    // イベントリスナーを設定します
    AimstarInAppMessaging.shared.delegate = self
    ...
}

...

extension AppDelegate: AimstarInAppMessagingDelegate {
    func messageDismissed(_ message: InAppMessage) {
        // ポップアップが非表示になったタイミングで実行
    }
    
    func messageClicked(_ message: InAppMessage) {
        // ポップアップ内のボタンがタップされたタイミングで実行
    }
    
    func messageDetectedForDisplay(_ message: InAppMessage) {
        // 表示対象のメッセージが見つかった際に実行。この後ポップアップが表示される
    }
    
    func messageError(_ message: InAppMessage?, error: Error) {
        // SDK内でエラーが発生した際に実行
    }
}
```

### 3.Customer IDの設定
SDKの初期化後に必要に応じてCustomer IDを設定してください

```swift
// アプリにユーザーがログインした後など、ユーザーが識別できるようになった後に実行
AimstarInAppMessaging.customerId = "ユーザーを識別するID"
```

#### ユーザーのログイン・ログアウト状態の判定
`AimstarInAppMessaging.customerId` にユーザーIDが設定されているかどうかで状態が判定されます。従って、ユーザーがログアウトを実行した際には `null` を設定いただく必要がございます。

### 4.isStrictLoginフラグの設定
ユーザーのログイン・ログアウト状態を厳密に判定する場合は true を設定していただく必要があります。初期値は false です。

### 5.ページ閲覧イベントの送出
スクリーン名を設定して fetch メソッドを実行します。

```swift
AimstarInAppMessaging.shared.fetch(screenName: "Your Screen Name")
```

---

# SDK References
## AimstarInAppMessaging
```swift
class AimstarInAppMessaging
```

SDKのエントリーポイントです。  
setupメソッドを通じて初期化を行います。初期化が行われていない場合は、SDKの機能が利用できません。

### Properties
### delegate: AimstarInAppMessagingDelegate?（任意）
```swift
delegate: AimstarInAppMessagingDelegate?
```
delegateを通じて、SDK側で発生したイベントをアプリ側に通知することができます

### isStrictLogin: Boolean
```swift
var isStrictLogin = false
```
このメンバをtrueにすると、ユーザーのログイン・ログアウト状態を厳密に判定するようになります。

### customerId: String?
```swift
var customerId: String?
```
ユーザーのIDを設定します。  
nilが設定されている場合は、ログアウト状態として扱われます。

### Functions
### setup(apiKey: String, tenantId: String)
```swift
func setup(apiKey: String, tenantId: String)
```

SDKの初期化を行います。

### fetch(screenName: String)
```swift
func fetch(screenName: String)
```
任意のタイミングでこのメソッドを呼び出すと、SDKが指定されたscreenNameでメッセージを取得します。メッセージが取得できた場合、Windowを生成し、その上にメッセージUIを表示します。

## AimstarInAppMessagingDelegate
protocolです  
このDelegateを実装したオブジェクトをAimstarInAppMessagingに設定することによって、以下のイベントを検知できます

### Functions
### messageDismissed(InAppMessage)

```swift
func messageDismissed(_ message: InAppMessage)
```

メッセージUIが表示された後、閉じられる際にコールされます。

### messageClicked(InAppMessage)

```swift
func messageClicked(_ message: InAppMessage)
```

メッセージUIでユーザーによるポジティブなタップアクション（OKボタンのタップ）を行った際にコールされます。

### messageDetectedForDisplay(InAppMessage)

```swift
func messageDetectedForDisplay(_ message: InAppMessage)
```

メッセージUIを表示すべき対象のメッセージが取得された際にコールされます。

### messageError(InAppMessage?, AimstarException)

```swift
func messageError(_ message: InAppMessage?, error: Error)
```

SDK内でメッセージの取得や表示の際にエラーが発生した場合にコールされます。