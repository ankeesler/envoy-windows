FROM microsoft/windowsservercore:1709

ADD https://aka.ms/vs/15/release/vc_redist.x64.exe /vc_redistx64.exe
RUN C:\vc_redistx64.exe /install /quiet
RUN del /F C:\vc_redistx64.exe

# From https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container
# NOTE: if you base your image directly on microsoft/windowsservercore, the .NET Framework may not install properly and no install error is
# indicated. Managed code may not run after the install is complete. Instead, base your image on microsoft/dotnet-framework:4.7.1 or newer.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe /vs_buildtools.exe
RUN C:\vs_buildtools.exe --quiet --wait --norestart --nocache \
  --add Microsoft.VisualStudio.Workload.VCTools \
  --add Microsoft.Component.VC.Runtime.UCRTSDK

ENV BAZEL_VC="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC"
RUN del /F C:\vs_buildtools.exe

RUN powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

# This doesn't show up in the container! I think it is this https://github.com/docker/for-win/issues/1947.
#RUN choco install bazel -y

ENV BAZEL_SH="C:\tools\msys64\usr\bin\bash.exe"
#ENV BAZEL_PYTHON="C:\tools\python2\python.exe" NOTE: this is the recommended location for python, but looks like Chocolatey installs it elsewhere
ENV BAZEL_PYTHON="C:\Python27\python.exe"

COPY test.ps1 /test.ps1

COPY workspace /workspace

CMD [ "powershell" ]
