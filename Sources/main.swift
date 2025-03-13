import class AppKit.NSRunningApplication
import class AppKit.NSWorkspace
import struct Foundation.Data
import struct Foundation.Date
import class Foundation.FileHandle
import class Foundation.JSONEncoder
import struct Foundation.URL

public struct AppInfo: Codable {
  public let active: Bool
  public let hidden: Bool
  public let localizedName: String
  public let bundleId: String
  public let bundleUrl: URL?
  public let executableArchitecture: Int
  public let executableURL: URL?
  public let launched: Date?
  public let finishedLaunching: Bool
  public let processIdentifier: Int32
  public let ownsMenuBar: Bool
  public let terminated: Bool

  public static func fromApp(app: NSRunningApplication) -> Self {
    Self(
      active: app.isActive,
      hidden: app.isHidden,
      localizedName: app.localizedName ?? "",
      bundleId: app.bundleIdentifier ?? "",
      bundleUrl: app.bundleURL,
      executableArchitecture: app.executableArchitecture,
      executableURL: app.executableURL,
      launched: app.launchDate,
      finishedLaunching: app.isFinishedLaunching,
      processIdentifier: app.processIdentifier,
      ownsMenuBar: app.ownsMenuBar,
      terminated: app.isTerminated
    )
  }

  public func toJson(_ enc: JSONEncoder) -> Result<Data, Error> {
    Result(catching: {
      try enc.encode(self)
    })
  }
}

@main
struct RunningAppInfo {
  static func main() {
    let wspace: NSWorkspace = .shared
    let apps: [NSRunningApplication] = wspace.runningApplications

    let stdout: FileHandle = .standardOutput

    let enc: JSONEncoder = JSONEncoder()

    for app in apps {
      let inf: AppInfo = .fromApp(app: app)
      let rdat: Result<Data, _> = inf.toJson(enc)
      switch rdat {
      case .failure(let err):
        print("\( err )")
        return
      case .success(let dat):
        do {
          try stdout.write(contentsOf: dat)
        } catch {
          print("\( error )")
          return
        }
      }
    }
  }
}
