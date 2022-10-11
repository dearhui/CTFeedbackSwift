//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public struct AppVersionItem: FeedbackItemProtocol {
    public var version: String {
        guard let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else { return "" }
        return shortVersion
    }

    public let isHidden: Bool

    public init(isHidden: Bool) { self.isHidden = isHidden }
}
