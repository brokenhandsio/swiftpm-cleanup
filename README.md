# SwiftPM Cleanup

A simple tool to clean up your SwiftPM project's environment.
It will remove:
  - `.build`
  - `.swiftpm`
  - `Package.resolved`
  - `/your/home/directory/.swiftpm`
  - `/your/home/directory/Library/Caches/org.swift.swiftpm`

Optionally, by passing the `--clean-derived-data` flag, it will also remove:
  - `/your_home_directory/Library/Developer/Xcode/DerivedData/your_project`

If you want to specify a project other than the one in the current directory, use the --path option:

  - `--path /path/to/your_project`

## Usage

- Clone the script file into your project's directory
- Run it with 
```bash 
swift cleanup.swift [--path /path/to/your_project] [--clean-derived-data]
```

Make sure to:
  - Run it as normal user and not as root, as that will switch your home directory to `/var/root`
  - Close any IDE or editor that might be using the project's files
