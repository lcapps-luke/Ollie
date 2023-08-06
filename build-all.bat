lime build html5 -clean -final
del "export/package/ollie-bonk-html5.zip"
7z a "export/package/ollie-bonk-html5.zip" "./export/html5/bin/*"

lime build neko -clean -final
del "export/package/ollie-bonk-neko.zip"
7z a "export/package/ollie-bonk-neko.zip" "./export/neko/bin/*"

lime build windows -clean -final
del "export/package/ollie-bonk-windows.zip"
7z a "export/package/ollie-bonk-windows.zip" "./export/windows/bin/*"
