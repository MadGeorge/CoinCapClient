// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Error
  internal static let alertErrorTitle = L10n.tr("Localizable", "alert_error_title", fallback: "Error")
  /// Alternative icons not supported on your device
  internal static let altIconError = L10n.tr("Localizable", "altIconError", fallback: "Alternative icons not supported on your device")
  /// Market Cap
  internal static let assetCap = L10n.tr("Localizable", "asset_cap", fallback: "Market Cap")
  /// Supply
  internal static let assetSupply = L10n.tr("Localizable", "asset_supply", fallback: "Supply")
  /// Volume (24h)
  internal static let assetVolume = L10n.tr("Localizable", "asset_volume", fallback: "Volume (24h)")
  /// Assets
  internal static let assets = L10n.tr("Localizable", "assets", fallback: "Assets")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "delete", fallback: "Delete")
  /// Unexpected error! Take a screenshot and contact support.
  internal static let errUnexpectedError = L10n.tr("Localizable", "err_unexpected_error", fallback: "Unexpected error! Take a screenshot and contact support.")
  /// General
  internal static let general = L10n.tr("Localizable", "general", fallback: "General")
  /// Icon
  internal static let icon = L10n.tr("Localizable", "icon", fallback: "Icon")
  /// Black
  internal static let iconBlack = L10n.tr("Localizable", "iconBlack", fallback: "Black")
  /// White
  internal static let iconWhite = L10n.tr("Localizable", "iconWhite", fallback: "White")
  /// Yellow
  internal static let iconYellow = L10n.tr("Localizable", "iconYellow", fallback: "Yellow")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok", fallback: "OK")
  /// Remove
  internal static let remove = L10n.tr("Localizable", "remove", fallback: "Remove")
  /// Search
  internal static let search = L10n.tr("Localizable", "search", fallback: "Search")
  /// Search
  internal static let searchPlaceholder = L10n.tr("Localizable", "search_placeholder", fallback: "Search")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings", fallback: "Settings")
  /// Watch
  internal static let watch = L10n.tr("Localizable", "watch", fallback: "Watch")
  /// Your Watchlist will appear here
  internal static let watchPlaceholderSubtitle = L10n.tr("Localizable", "watch_placeholder_subtitle", fallback: "Your Watchlist will appear here")
  /// No assets yet
  internal static let watchPlaceholderTitle = L10n.tr("Localizable", "watch_placeholder_title", fallback: "No assets yet")
  /// All watched assets were removed
  internal static let watchedClearedBody = L10n.tr("Localizable", "watched_cleared_body", fallback: "All watched assets were removed")
  /// Done!
  internal static let watchedClearedTitle = L10n.tr("Localizable", "watched_cleared_title", fallback: "Done!")
  /// Watching
  internal static let watching = L10n.tr("Localizable", "Watching", fallback: "Watching")
  /// Watchlist
  internal static let watchlist = L10n.tr("Localizable", "watchlist", fallback: "Watchlist")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
