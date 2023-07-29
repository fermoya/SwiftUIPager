//
//  L102Language.swift
//  BaseProjectVIP
//
//  Created by imac on 20/3/19.
//  Copyright © 2019 Selsela. All rights reserved.
//

import Foundation
import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"

class L102Language {
	
	/// get current Apple language
	class func currentAppleLanguage() -> String {
		let userdef = UserDefaults.standard
		let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
		let current = langArray.firstObject as! String
		let endIndex = current.startIndex
		let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
		return currentWithoutLocale
	}
	
	class func currentAppleLanguageFull() -> String {
		let userdef = UserDefaults.standard
		let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
		let current = langArray.firstObject as! String
		return current
	}
	
	/// set @lang to be the first in Applelanguages list
	class func setAppleLAnguageTo(lang: String) {
		let userdef = UserDefaults.standard
		userdef.set([lang, currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
		userdef.synchronize()
        if(lang == "ar") {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
	}
	
	class var isRTL: Bool {
		return L102Language.currentAppleLanguage() == "ar" || L102Language.currentAppleLanguage() == "ur"
	}
}
