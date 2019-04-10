import Foundation
import UIKit

public enum Device {
    case iPhoneSE_1136
    case iPhoneNormal_1334
    case iPhonePlus_1920
    case iPhoneX_2436
    case iPhoneXR_1792
    case iPhoneXSMax_2688

    case iPadPro9_2048
    case iPadPro10_2388
    case iPadPro12_2732

    static var type: Device {
//        Log.i("Screen Height: \(UIScreen.main.nativeBounds.height)")
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhoneSE_1136
        case 1334:
            return .iPhoneNormal_1334
        case 1792:
            return .iPhoneXR_1792
        case 2208:
            return .iPhonePlus_1920
        case 1920:
            return .iPhonePlus_1920
        case 2436:
            return .iPhoneX_2436
        case 2688:
            return .iPhoneXSMax_2688
        case 2048:
            return .iPadPro9_2048
        case 2388:
            return .iPadPro10_2388
        case 2732:
            return .iPadPro12_2732
        default:
            return .iPhoneNormal_1334
        }
    }

    static var hasNotch: Bool {
        switch type {
        case .iPhoneX_2436, .iPhoneXR_1792, iPhoneXSMax_2688:
            return true
        default:
            return false
        }
    }

}