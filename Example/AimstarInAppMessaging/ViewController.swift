//
//  ViewController.swift
//  AimstarInAppMessaging
//
//  Created by k-kubo on 2024/01/18.
//

import UIKit
import AimstarInAppMessagingSDK

class ViewController: UIViewController {
    
    private lazy var button = {
        let btn = UIButton(type: .system)
        btn.setTitle("send viewed event", for: UIControl.State())
        btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // ログインしているユーザーIDを連携します
        AimstarInAppMessaging.shared.customerId = "Your Customer ID"
    }

    private func setupViews() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func tapped() {
        // 擬似的にページ閲覧イベントを発生させます。
        AimstarInAppMessaging.shared.fetch(screenName: "Your Screen Name")
    }
}
