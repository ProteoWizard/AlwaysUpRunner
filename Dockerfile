ARG BASE_WINDOWS_IMAGE=mcr.microsoft.com/windows/server:ltsc2022-amd64
FROM $BASE_WINDOWS_IMAGE

ADD *.dll c:\\AlwaysUpCLT\\
ADD *.exe c:\\AlwaysUpCLT\\

RUN net USER TestUser /ADD /Y && \
    net LOCALGROUP "Administrators" TestUser /ADD && \
    setx /M SKYLINE_DOWNLOAD_FROM_S3 1 && \
    setx /M SKYLINE_DOWNLOAD_PATH c:\downloads

ADD run.bat c:\\AlwaysUpCLT\\

ENTRYPOINT c:\\AlwaysUpCLT\\run.bat
