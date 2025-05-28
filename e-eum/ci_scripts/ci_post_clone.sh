#!/bin/bash

# Xcode Cloud에서 자동 패키지 해결 제한을 제거
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution
