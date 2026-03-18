cask "a2d-clock" do
  version "1.0.0"
  sha256 "126e8b126eacc3b13b1f0df25531531341047a8ff8220584b873beb9e1787567"

  url "https://github.com/lordSauron1710/a2d-clock/releases/download/v#{version}/A2DClock.zip"
  name "A2D Clock"
  desc "Clock-clock screensaver for macOS — 24 analog faces that spell the time"
  homepage "https://github.com/lordSauron1710/a2d-clock"

  app "A2DClock.app"

  caveats <<~EOS
    A2D Clock will install the screensaver automatically on first launch.

    Then open System Settings → Screen Saver → Other and select A2D Clock.

    If macOS blocks the app, run:
      xattr -d com.apple.quarantine /Applications/A2DClock.app
  EOS
end
