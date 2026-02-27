# AIMSTAR In-App Messaging iOS SDK

## Requirements

- ランタイム: iOS 16.0 以上
- 開発環境: Xcode (Swift 5.10 対応バージョン)

## 制限事項

- マルチウインドウアプリには対応していません

## SDKで提供する機能について

- アプリのページ閲覧イベントを送信する
- 対象と判定されたユーザーに、以下の3種類のメッセージを表示する
  - **ポップアップモーダル**: 画面中央に表示されるモーダルダイアログ
  - **ポップアップバナー**: 画面上部/中央/下部に表示されるバナー（位置は9箇所から指定可能）
  - **埋め込みバナー**: アプリの任意の場所に埋め込み表示するバナー
- メッセージの表示、ユーザー操作による非表示、コンバージョンボタンのタップの各イベントを送信する
- UIKit / SwiftUI の両方に対応

## 用語

| 用語 | 説明 |
| - | - |
| API Key | AimstarInAppMessaging を利用するために必要な API キーで、AIMSTAR 側で事前にアプリ開発者に発行されます。 |
| Tenant ID | AimstarInAppMessaging を利用するために必要なテナント ID で、AIMSTAR 側で事前にアプリ開発者に発行されます。 |
| Customer ID | アプリ開発者がユーザーを識別する ID で、アプリ開発者が独自に発行、生成、または利用します。 |
| ScreenName | アプリ側で設定するトリガーの一種（アプリ開発者が任意に設定する識別名）で、ユーザーが特定の画面を表示したり、またはアクションを行うなどの条件を満たした場合に、識別名を使ってメッセージを呼び出すために利用されます。 |
| ComponentID | 埋め込みバナーを識別するための文字列 ID です。AIMSTAR 管理画面で設定した値と、アプリ側で指定する値を一致させる必要があります。 |

## 導入手順

### 1. SDKをアプリに追加する

#### CocoaPodsを利用する場合

Podfileに以下を追記し、`pod install` を実行してください。

```ruby
pod "AimstarInAppMessaging"
```

#### 手動で追加する場合

[Releases](https://github.com/supsysjp/aimstar-in-app-message-ios/releases) から `AimstarInAppMessagingSDK.zip` をダウンロードして展開し、AimstarInAppMessagingSDK.xcframeworkをプロジェクトに含めてください。

### 2. SDKの初期化とイベントリスナーを設定する

`application(_:didFinishLaunchingWithOptions:)` メソッド内に初期化コードを追加します。

```swift
import AimstarInAppMessagingSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let API_KEY = "Your API KEY"
    let TENANT_ID = "Your TENANT ID"
    // SDKの初期化を行います
    AimstarInAppMessaging.shared.setup(apiKey: API_KEY, tenantId: TENANT_ID)
    // イベントリスナーを設定します（任意）
    AimstarInAppMessaging.shared.delegate = self
    ...
}

extension AppDelegate: AimstarInAppMessagingDelegate {
    func messageDismissed(_ message: InAppMessage) {
        // メッセージが非表示になったタイミングで実行
    }

    func messageClicked(_ message: InAppMessage) {
        // メッセージ内のボタンがタップされたタイミングで実行
    }

    func messageDetectedForDisplay(_ message: InAppMessage) {
        // 表示対象のメッセージが見つかった際に実行。この後メッセージが表示される
    }

    func messageError(_ message: InAppMessage?, error: AimstarError) {
        // SDK内でエラーが発生した際に実行
    }
}
```

### 3. Customer IDの設定

SDKの初期化後に必要に応じてCustomer IDを設定してください。

```swift
// アプリにユーザーがログインした後など、ユーザーが識別できるようになった後に実行
AimstarInAppMessaging.shared.customerId = "ユーザーを識別するID"
```

#### ユーザーのログイン・ログアウト状態の判定

`AimstarInAppMessaging.shared.customerId` にユーザーIDが設定されているかどうかで状態が判定されます。従って、ユーザーがログアウトを実行した際には `nil` を設定してください。

### 4. isStrictLoginフラグの設定

ユーザーのログイン・ログアウト状態を厳密に判定する場合は `true` を設定してください。初期値は `false` です。

```swift
AimstarInAppMessaging.shared.isStrictLogin = true
```

### 5. メッセージの取得と表示

#### UIKit

スクリーン名を設定して `fetch` メソッドを実行します。

```swift
// シンプルな呼び出し（最前面のViewControllerに自動表示）
AimstarInAppMessaging.shared.fetch(screenName: "Your Screen Name")

// ポップアップバナーの表示先ViewControllerを指定する場合
AimstarInAppMessaging.shared.fetch(screenName: "Your Screen Name", on: self)
```

デフォルトでは、ポップアップバナーは対象ViewControllerのセーフエリア上端・下端を基準に表示されます。カスタムヘッダーやタブバーなど、アプリ固有のUI要素とバナーが重ならないようにするには、`topAnchor` / `bottomAnchor` を指定してください。

```swift
// ヘッダーの下端〜タブバーの上端の範囲内にバナーを表示する
AimstarInAppMessaging.shared.fetch(
    screenName: "Your Screen Name",
    on: self,
    topAnchor: headerView.bottomAnchor,
    bottomAnchor: tabBar.topAnchor
)
```

#### SwiftUI

`.aimstarScreen()` モディファイアを使用します。

```swift
import AimstarInAppMessagingSDK

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ContentView()
        }
        .aimstarScreen("Your Screen Name")
    }
}
```

**カスタムタブバー等との重なりを避ける場合:**

`.aimstarScreen()` は内部の overlay がセーフエリアを自動的に尊重します。カスタムタブバーなどアプリ固有のUI要素とポップアップバナーが重ならないようにするには、`.safeAreaInset` でその領域をセーフエリアに含めたうえで、`.aimstarScreen()` を `.safeAreaInset` の**後**に適用してください。

```swift
ContentView()
    .safeAreaInset(edge: .bottom) {
        CustomTabBar()  // このタブバー領域を避けてバナーが表示される
    }
    .aimstarScreen("Your Screen Name")
```

> **注意:** `.aimstarScreen()` を `.safeAreaInset` より**前**に適用すると、セーフエリアの変更がバナーの配置に反映されず、バナーとカスタムUI要素が重なる可能性があります。

#### 埋め込みバナー

アプリの任意の場所にバナーを埋め込む場合は、埋め込みバナーコンポーネントを使用します。

**SwiftUI:**

```swift
import AimstarInAppMessagingSDK

struct ContentView: View {
    var body: some View {
        VStack {
            IAMEmbeddedBanner(componentId: "your_component_id")
        }
        .aimstarScreen("Your Screen Name")
    }
}
```

**UIKit:**

```swift
import AimstarInAppMessagingSDK

let embeddedBanner = IAMUIEmbeddedBanner()
embeddedBanner.componentId = "your_component_id"
view.addSubview(embeddedBanner)
```

### 6. カスタムパラメータの送信

`fetch` やモディファイアにカスタムパラメータを付与できます。

```swift
// UIKit
AimstarInAppMessaging.shared.fetch(screenName: "Your Screen Name") {
    putString("category", "electronics")
    putInteger("age", 25)
    putBoolean("is_premium", true)
    putDouble("price", 99.9)
    putStringArray("tags", ["sale", "new"])
}

// SwiftUI
ContentView()
    .aimstarScreen("Your Screen Name") {
        putString("category", "electronics")
        putInteger("age", 25)
    }
```

対応する型: `putString`, `putInteger`, `putDouble`, `putBoolean`, `putStringArray`, `putIntegerArray`, `putDoubleArray`, `putBooleanArray`

---

# SDK References

## AimstarInAppMessaging

```swift
class AimstarInAppMessaging
```

SDKのエントリーポイントです。
setupメソッドを通じて初期化を行います。初期化が行われていない場合は、SDKの機能が利用できません。

### Properties

#### delegate: AimstarInAppMessagingDelegate?

```swift
weak var delegate: AimstarInAppMessagingDelegate?
```

delegateを通じて、SDK側で発生したイベントをアプリ側に通知することができます。すべてのメソッドはデフォルト実装が提供されているため、必要なメソッドのみ実装できます。

#### isStrictLogin: Bool

```swift
var isStrictLogin: Bool
```

このプロパティを `true` にすると、ユーザーのログイン・ログアウト状態を厳密に判定するようになります。初期値は `false` です。

#### customerId: String?

```swift
var customerId: String?
```

ユーザーのIDを設定します。
`nil` が設定されている場合は、ログアウト状態として扱われます。

### Functions

#### setup(apiKey:tenantId:)

```swift
func setup(apiKey: String, tenantId: String)
```

SDKの初期化を行います。

#### setup(apiKey:tenantId:apiHost:)

```swift
func setup(apiKey: String, tenantId: String, apiHost: String)
```

APIホストを指定してSDKの初期化を行います。

#### fetch(screenName:customParameter:)

```swift
func fetch(
    screenName: String,
    @CustomParameterBuilder customParameter: () -> [CustomParameterEntry] = { [] }
)
```

任意のタイミングでこのメソッドを呼び出すと、SDKが指定されたscreenNameでメッセージを取得します。メッセージが取得できた場合、メッセージタイプに応じたUIを表示します。

#### fetch(screenName:on:topAnchor:bottomAnchor:customParameter:)

```swift
func fetch(
    screenName: String,
    on targetVC: UIViewController,
    topAnchor: NSLayoutYAxisAnchor? = nil,
    bottomAnchor: NSLayoutYAxisAnchor? = nil,
    @CustomParameterBuilder customParameter: () -> [CustomParameterEntry] = { [] }
)
```

ポップアップバナーの表示先ViewControllerと表示位置を指定してメッセージを取得・表示します。

## View.aimstarScreen(_:customParameter:)

```swift
func aimstarScreen(
    _ screenName: String,
    @CustomParameterBuilder customParameter: @escaping () -> [CustomParameterEntry] = { [] }
) -> some View
```

SwiftUI用のViewモディファイアです。ビューの表示時にアプリ接客コンテンツを取得し、ポップアップバナー等を自動的に表示します。

## IAMEmbeddedBanner (SwiftUI)

```swift
struct IAMEmbeddedBanner: View
```

SwiftUI用の埋め込みバナーコンポーネントです。`componentId` を指定して初期化します。

## IAMUIEmbeddedBanner (UIKit)

```swift
class IAMUIEmbeddedBanner: UIView
```

UIKit用の埋め込みバナーコンポーネントです。`componentId` プロパティを設定してバナーを表示します。

## AimstarInAppMessagingDelegate

```swift
protocol AimstarInAppMessagingDelegate: AnyObject
```

このDelegateを実装したオブジェクトをAimstarInAppMessagingに設定することによって、以下のイベントを検知できます。すべてのメソッドに空のデフォルト実装が提供されているため、必要なメソッドのみ実装してください。

### Functions

#### messageDismissed(_:)

```swift
func messageDismissed(_ message: InAppMessage)
```

メッセージUIが表示された後、閉じられる際にコールされます。

#### messageClicked(_:)

```swift
func messageClicked(_ message: InAppMessage)
```

メッセージUIでユーザーによるポジティブなタップアクション（OKボタンのタップ）を行った際にコールされます。

#### messageDetectedForDisplay(_:)

```swift
func messageDetectedForDisplay(_ message: InAppMessage)
```

メッセージUIを表示すべき対象のメッセージが取得された際にコールされます。

#### messageError(_:error:)

```swift
func messageError(_ message: InAppMessage?, error: AimstarError)
```

SDK内でメッセージの取得や表示の際にエラーが発生した場合にコールされます。

## InAppMessage

```swift
enum InAppMessage {
    case popupModal(PopupModalContent)
    case popupBanner(PopupBannerContent)
    case embeddedBanner(EmbeddedBannerContent)
}
```

SDKが取り扱うメッセージの型です。デリゲートメソッドの引数として渡されます。
