FROM microsoft/windowsservercore:1709

RUN powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

RUN choco install bazel -y

ENV BAZEL_SH="C:\tools\msys64\usr\bin\bash.exe"
#ENV BAZEL_PYTHON="C:\tools\python2\python.exe" NOTE: this is the recommended location for python, but looks like Chocolatey installs it elsewhere
ENV BAZEL_PYTHON="C:\Python27\python.exe"

COPY vc_redistx64*.exe /vc_redistx64.exe
RUN C:\vc_redistx64.exe /install /quiet
RUN del /F C:\vc_redistx64.exe

# From https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container
# NOTE: if you base your image directly on microsoft/windowsservercore, the .NET Framework may not install properly and no install error is
# indicated. Managed code may not run after the install is complete. Instead, base your image on microsoft/dotnet-framework:4.7.1 or newer.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe /vs_buildtools.exe
RUN C:\vs_buildtools.exe --quiet --wait --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Workload.VCTools
ENV BAZEL_VC="C:\BuildTools"
RUN del /F C:\vs_buildtools.exe

#COPY vs_buildtools*.exe /vs_buildtools.exe
#RUN C:\vs_buildtools.exe install --passive --wait --norestart --add Microsoft.VisualStudio.Workload.VCTools
#RUN del /F C:\vs_buildtools.exe
