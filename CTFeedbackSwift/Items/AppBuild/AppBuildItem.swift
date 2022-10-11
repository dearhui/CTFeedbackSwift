//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public struct AppBuildItem: FeedbackItemProtocol {
    public var buildString: String {
        guard let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        return build
    }

    public let isHidden: Bool

    public init(isHidden: Bool) { self.isHidden = isHidden }
}
