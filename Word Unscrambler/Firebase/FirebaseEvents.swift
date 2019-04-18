import FirebaseCore
import FirebaseAnalytics

public class FirebaseEvents {

    init() {

    }

    // ADS
    public func logAdLoaded() {
        Analytics.logEvent(LogKey.AD_LOADED, parameters: nil)
    }

    public func logAdClick() {
        Analytics.logEvent(LogKey.AD_CLICK, parameters: nil)
    }

    public func logAdFailedToLoad() {
        Analytics.logEvent(LogKey.AD_FAILED_TO_LOAD, parameters: nil)
    }
    
    // Unscramble
    public func logUnscramble() {
        Analytics.logEvent(LogKey.UNSCRAMBLE, parameters: nil)
    }

    // Words
    public func logAddedWordToFavorite() {
        Analytics.logEvent(LogKey.STARED, parameters: nil)
    }

    public func logRemovedWordFromFavorite() {
        Analytics.logEvent(LogKey.UN_STARED, parameters: nil)
    }
    
    public func logWebDefinitionsClick() {
        Analytics.logEvent(LogKey.WEB_DEFINITIONS_BUTTON_CLICK, parameters: nil)
    }

    public func logDefinitionClick() {
        Analytics.logEvent(LogKey.DEFINITION_BUTTON_CLICK, parameters: nil)
    }

    // Firebase Fetch
    public func logSuccessfulFirebaseFetch() {
        Analytics.logEvent(LogKey.FIREBASE_FETCH_SUCCESS, parameters: nil)
    }

    public func logFailedFirebaseFetch() {
        Analytics.logEvent(LogKey.FIREBASE_FETCH_FAILED, parameters: nil)
    }
}