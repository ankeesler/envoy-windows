$bazel = "C:\ProgramData\chocolatey\bin\bazel.exe"
if (Test-Path $bazel) {
  echo "PASS: bazel.exe exists at expected location ($bazel)"
} else {
  echo "FAIL: bazel.exe does NOT exist at expected location ($bazel)"
  exit 1
}
