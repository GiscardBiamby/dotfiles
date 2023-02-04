
/usr/bin/google-chrome-stable \
    --use-gl=egl \
    --disable-features=UseChromeOSDirectVideoDecoder

This seems to work but it doesn't enable any additional hardware acceleration


## This flag causes Gnome to crash:
    --enable-features=VaapiVideoDecoder \


## Does this enable hardware compositing?
/usr/bin/google-chrome-stable \
    --use-gl=desktop

    No, it crashes Gnome, but use-gl=egl works.

One issue that still comes up is sometimes if I open chrome with my Personal/Home profile, and then right click Chrome -> New Window, and then select my School/Work profile, it restarts Gnome. It happened again on 2023-02-03, after the system had been running for a while and had undergone several suspend/resume cycles, and also at least one hibernate/resume cycle. Not sure if the suspend/hibernate stuff contributes to the issue.

I restarted Gnome by logging out and logging back in (no reboot), and was able to start Chrome with both profiles. This time started the school profile first. This is with a default, clean Exec command in /usr/share/applications/google-chrome.desktop