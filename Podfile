# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def rx_swift
    pod 'RxSwift', '~> 4.0'
end

def rx_cocoa
    pod 'RxCocoa', '~> 4.0'
end

target 'Mood-Diary' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mood-Diary
  rx_cocoa
  rx_swift
  pod 'Sensitive'
  pod 'PopupDialog'
  pod 'IQKeyboardManager'
  pod 'FSCalendar'
  pod 'QueryKit'
  pod 'Charts'
  pod 'ActiveLabel'
end

target 'Domain' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    rx_swift
end

target 'RealmPlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    rx_swift
    pod 'RealmSwift'
    pod 'RxRealm'
    pod 'QueryKit'
end
