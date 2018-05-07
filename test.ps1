where.exe /Q bazel
if ($LASTEXITCODE -ne 0) {
  echo "ERROR: could not find bazel"
  exit 1
}

cd C:\workspace
bazel build //main:main
