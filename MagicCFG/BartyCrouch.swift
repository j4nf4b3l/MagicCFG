//
//  BartyCrouch.swift
//  MagicCFG
//
//  Created by Jan Fabel on 05.07.20.
//  Copyright © 2020 Jan Fabel. All rights reserved.
//
//  This file is required in order for the `transform` task of the translation helper tool BartyCrouch to work.
//  See here for more details: https://github.com/Flinesoft/BartyCrouch

import Foundation

enum BartyCrouch {
    enum SupportedLanguage: String {
        // TODO: remove unsupported languages from the following cases list & add any missing languages
        case chineseKong = "zh-HK" // @zao_shen
        case english = "en" // @j4nf4b3l
    }

    static func translate(key: String, translations: [SupportedLanguage: String], comment: String? = nil) -> String {
        let typeName = String(describing: BartyCrouch.self)
        let methodName = #function

        print(
            "Warning: [BartyCrouch]",
            "Untransformed \(typeName).\(methodName) method call found with key '\(key)' and base translations '\(translations)'.",
            "Please ensure that BartyCrouch is installed and configured correctly."
        )

        // fall back in case something goes wrong with BartyCrouch transformation
        return "BC: TRANSFORMATION FAILED!"
    }
}
